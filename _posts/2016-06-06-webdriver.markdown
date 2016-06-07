---
layout: post
title: Attempting to Automation with watir-webdriver and page-object
date:   2016-06-06 22:14:26
categories: automation
---
I am not a programmer and generally only know about a fifth of what I'm talking about, so take all of this with a grain of salt.

I've been working on doing some web UI automation recently.  I've been using watir-webdriver and page-object in Ruby to get this work done. I've brushed up against doing this a couple times in the past. It's never been uncommon for me to automate stuff that annoys me and I've got more than a couple specific purpose tools to help me along.

I have taken an ad hoc and undirected stab at automation with watir-webdriver in the past. The way that I went about doing it was a little odd and not really maintainable. I was basically cramming a bunch of helper methods into a great big class and then using that to support rspec tests. It got the job done, but was a bit of an octopus that I wasn't ever able to get to a point of being able to help people.

Coming back to it, I wanted to make sure that I was building up a framework that actually made sense and was maintainable. To do so, I started building with the page-object gem. The page object framework makes a lot of sense; separate the page layout and function from the tests. If the layout or function changes you only have to fix it in one place. Totally makes sense and, at first, I was really excited to work with page-object.

Then I started bumping into some things that bothered me a little. I've spent a decent amount of time, spread out over a long amount of time, using watir-webdriver. I like the way it works and I like the power that it gives me. While the DSL that page-object offers is nice, I feel like I'm divorced from the things that make watir-webdriver great. In the case where the object I'm working with isn't already defined or easy to define I'm working around it, which kind of defeats the purpose.

Another example is configuration pages. Working with page-object I should map my check boxes and then use the generated methods to manipulate the page. That's fine, but what if I have 20 of them? More, what if the only tests I'm concerned with have to do with setting, unsetting, and saving? That would mean 20 individual definitions, then one method that sets each checkbox individually and saves, and then another that clears them all and saves again. That's 64 lines, including the method defs, and what seems like a lot of unnecessary repetition.

I can do all of this with naked ruby / watir-webdriver in four lines.

{% highlight ruby %}
browser.checkboxes.each { |x| x.set }
browser.button(:id => 'save').click

browser.checkboxes.each { |x| x.clear }
browser.button(:id => 'save').click
{% endhighlight %}

Wrap each of those into a method, call it from a test, and then check that the boxes are either checked or not as appropriate. Done in eight lines total.

I could do this, when it seems like it would short cut a lot of work, but I'm not sure if that's even a good idea. If I'm going to spend half of the framework writing directly against watir-webdriver I feel like I should just ditch page-object entirely.

Another alternative is to define my own DSL, but I'm not sure how successful of a project that would be. I've been playing with Ruby for well over a decade at this point. My capability with the language (or programming in general) definitely does not reflect that. I feel like trying to build up my own page object framework would be the merry path into a hell of my own making.

I suspect that I may be able to use the page object framework without defining a DSL. It's just an abstraction layer over top of what watir-webdriver offers (I'm probably wrong about this), in which case I can build up the pages with appropriate functionality while writing directly against watir-webdriver.

I'm intrigued by the option. I'll have to start picking at it and seeing how likely I am to be successful with it.
