---
layout: post
title: Firefox Fighting Back
date:   2016-06-13 18:38:34
categories: automation
---
There is literally nothing I love more than fighting with browsers.

Starting up a new automation project (with next to no experience or clue as to what I'm doing), I knew there were going to be hiccups. Early last week the thought crossed my mind that I should 'probably lock down browser versions so an update doesn't break all my shit.'

Guess what?

Firefox 47 came out and broke all of my shit.

Since I'm not dialed in to the automation blogs it took me a little bit to actually figure out what happened.

Apparently, [Mozilla is in the process of moving to Marionette](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette). Whatever was in place prior appears to have been dropped in Firefox 47. All of my scripts were timing out trying to connect to the browser.

It took me a little bit to figure out what the actual problem was, at which point I rolled back my browser and turned off updates. But this doesn't really strike me as the ideal solution. My team would like to be able to contribute to a UI automation project and also leverage it locally when they want to run some checks against dev branches. That aside, I can't have my entire team with their browsers out of date.

So, I started to look for a resolution.

My inclination is that I'd need an update to watir-webdriver. That doesn't seem to be accurate. It looked like I should be able to work with what I already had (perhaps with an update to selenium-webdriver). All I'd need to do is grab [Geckodriver](https://github.com/mozilla/geckodriver) and [update my path](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette/WebDriver#Adding_the_executable_to_the_PATH).

If only...

It looks like there's a Windows specific bug, because we all love those. [The method to find the Geckodriver binary fails](https://github.com/SeleniumHQ/selenium/issues/2271). I tested and verified the fix listed in that ticket, but I'm not about to require manual updates to external libraries for my projects to work.

For the time being, my browser is rolled back, Geckodriver is install, and I'm subscribed that issue. Ideally, a fix will be released for it soon. Until then, I'm going to keep going with what I've got.
