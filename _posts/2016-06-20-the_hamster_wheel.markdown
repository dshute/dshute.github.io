---
layout: post
title: The Hamster Wheel
date:   2016-06-20 23:15:21
categories: automation
---
I really enjoy programming, but the absolute misery of not knowing if the problem is the library you're working with or your own gross inadequacy is maddening.

The Firefox 47 / watir-webdriver / geckodriver drama continues.

The general problem of selenium-webdriver not being able to find the geckodriver binary in the path was [resolved](https://github.com/SeleniumHQ/selenium/issues/2271). Where I ended up getting hung up next was passing the profile through geckodriver to Firefox. It kept failing on browser start up and I couldn't figure out what was going wrong. Turns out [this was already resolved in documentation](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette/WebDriver) I'd skimmed through several times and glazed over because... I don't know why I glazed over it. (I tend to lean toward 75% of what's incoming to be noise assuming I can just pay attention to 25% and get the important parts oblivious to the fact that I can't just arbitrarily determine what to listen to and have that magically be the important part.)

What I was looking for was this little bit of goodness.

{% highlight ruby %}
capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile)
browser = Watir::Browser.new :firefox, marionette: true, desired_capabilities: Capabilities
{% endhighlight %}

Now, any of the profile settings I've set against _profile_ will be passed along appropriately to Firefox on start up. This is wonderful. It's still slower than running scripts against Chrome, but hurray, Firefox!

Not so much.

The test suite I've been building is not so big yet. I'm still figuring out a lot of things. And this little suite now fails in almost every way imaginable against Firefox 47 where it used to glide through (almost) effortlessly in Firefox 46 and performs admirably in Chrome.

Every single test broke. Every. Single. One.

And they all broke in fun and different ways.

In one case, I'm trying to get a hidden menu div to pop up. The menu itself is a bunch of list items with overflow being picked up by our responsive script and crammed into a dropdown that triggers on mousing over the 'More Links' list item / link.

In either Firefox 46, Chrome, or Safari all I needed to was address the list item and send a click.

{% highlight ruby %}
browser.li(id: 'primarynav-more').click
{% endhighlight %}

This totally worked. The hidden popup displays and I can now click links in that list. Run that in Firefox 47 through geckodriver and, well, sure, it completes. It doesn't do anything, but it completes.

In my desperation to get this working I then tried the _.hover_ method, because why not? In case you're wondering, I'll tell you why not. We're connecting to Firefox via geckodriver and this (I think) means we're using the remote connection to do so and the mouse movement controls _don't exist_ here and throws all kinds of happy errors.

No, instead of something logical and sane and that works everywhere I needed to [modify the CSS using inline JS](https://jkotests.wordpress.com/2013/07/10/changing-an-elements-attribute-value/) to change it from a hidden div to a simple block. Then, once it was exposed, I could click on it.

Then there was the joy of determining whether I'd need to click on a link to expose a hidden menu.

{% highlight ruby %}
browser.a(id: 'usermenu').click unless browser.div(id: 'usermenuitems').visible?
{% endhighlight %}

Simple, right? Yeah, that's what I thought. Until I tried to do it. This little bit here:

{% highlight ruby %}
browser.div(id: 'usermenuitems').visisble?
{% endhighlight %}

I went through and checked against five different browsers.

* Firefox 46 => false
* Chrome => false
* IE 11 => false
* Safari => false
* Firefox 47 => true

WTF???

Okay. No problem. Given that my "hidden" items may actually be technically available on the page (0 height, -5000 x, full transparent, or any number of other monstrosities) I'll bite and say fine. I need to have a better way of doing it. I'll working around this. Given that the classes change between hidden and visible that's good enough.

{% highlight ruby %}
if browser.div(id: 'usermenuitems').attribute_value("class").include? 'menu_hidden'
  browser.a(id: 'usermenu').click
end
{% endhighlight %}

That's chunky and gross to read, but it's more explicit and I'm okay with it. I'm okay with all of this. What I'm not okay with is bullshit that breaks for no discernable reason at all.

I have a method I've crammed into my spec_helper that does a basic sanity check in the page.

{% highlight ruby %}
page_text = browser.body.text.to_s #required to prevent rspec expect from puking
expect(page_text).to_not include({error text here})
{% endhighlight %}

I've got three expectations in there for specific text that would indicate a significant problem in the product. This would be great, except that on many, many... many occasions I was getting an error back that it couldn't locate the body element.

The body element.

On a blank page it can find a body element.

But, that's fine. In a couple of cases, I suspect due to AJAX loads, control was returned to the script before the page was finished loading. No problem. Just wait until it's present, right?

{% highlight ruby %}
browser.body.wait_until_present
page_text = browser.body.text.to_s
{% endhighlight %}

I could sit there and babysit the test run. At no point would the wait time out. At no point did it seem like the wait_until_present was failing. Despite this, about 10% of the time, cramming the body text into that variable would flat out fail.

There are limits before I dust my hands off and go back to happy coding against Chrome. That limit has been both reached and breached. I'd love to say I pushed through and got it all working, but I don't have the time or the patience to spend fighting with a system that works differently from _every other browser I've tested against_.

Until newer versions of Firefox can behave it's going in the corner to think about what it's done.
