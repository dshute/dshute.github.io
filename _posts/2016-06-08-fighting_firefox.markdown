---
layout: post
title: Fighting Fire(fox)
date:   2016-06-08 19:24:48
categories: automation
---
The watir-webdriver automation extravaganza continues!

In ensuring that we're able to get a decent amount of usage out of this project, I'm trying to take care of all the things that I think are going to be difficult to do up front. A decent amount of the functionality I've already figured out in one form another in the past. One of the pieces that eluded me, partially because I hadn't cared enough to chase it down, was working with files. How to get Firefox and Chrome to do file downloads and uploads.

I get it. It's not really meant to do that, so you need work around it. In trying to figure that out, I hit a couple of bumps along the way.

I found [this documentation](https://watirwebdriver.com/browser-downloads/), which got a me a decent amount of the way forward with Firefox. Looking at it again, to complain about how frustrating this has been, I wish I would have noticed and caught the significance of the second line here.

{% highlight ruby %}
directory = "#{Dir.pwd}/downloads"
download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
{% endhighlight %}

While I was doing my initial testing to get this working (love IRB), I couldn't figure out why just cramming in _Dir.pwd_ as my download destination wasn't working. I could pop open the new browser and look into about:config, and the directory I expected would be there. c:/sandbox/project

Every single time I would try to download something it would default system Downloads directory. This was infuriating, until my stupid brain made the connection that I'm working on a Windows box.

Those slashes are going the wrong way.

If I had paid attention to the sample provided I could have saved a whole lot of time and frustration as it is clear substituting escaped backslashes if running on Windows.

_Misery, madness, and worms..._

The next problem I ran up against came right out of the example as well.

{% highlight ruby %}
profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.folderList'] = 2 # custom location
profile['browser.download.dir'] = download_directory
profile['browser.helperApps.neverAsk.saveToDisk'] = "text/csv,application/pdf"
{% endhighlight %}

It's that last line that gave endless misery.

See, it should work. And it used to work. And if I substitute that _application/pdf_ with any text, image, or video type, it does work. If only I'd figured out earlier that the pdf association was the problem and not assumed that the entire profile setting was the problem.

I suspect that there's a change in how Firefox works with certain files in newer versions (v46, for sure). The association for how to deal with PDF files is maintained in  _about:preferences#applications_. I don't know how to set this or if it's even possible via watir.

Once I figured those two things out I essentially had all the problems resolved in my download functionality. I still need to put it together in my project, but I'm not concerned about whether it's going to work or not. We'll just need to be selective about the types of files we can download in Firefox. I'll also need to put it together with the idea that the code will need to easily support Chrome in the future and that Chrome may perform a bit better with PDF files.

I'll need to remember to clean up after testing as well. If download tests are successful, I'll want to remove any of those downloads on test completion. They're really only worth keeping around locally if they have a related failure.
