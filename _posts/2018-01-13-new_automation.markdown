---
layout: post
title: Integrating Automation into our Process
date:   2018-01-13 22:48:29
categories: automation
---
There's been a (necessary) question on adding automation into our project at work, with the reasonable understanding that it would be something I would tackle (in one form or another). Spilling over into the new year, it's definitely the time to start working away at that.

We've got four obvious targets for automation:
* web client
* API
* iOS client
* Android client

There are some other options, but they don't see as much development and aren't as high risk as those listed above.

The web client is the narrowest target for us to hit. We're using React for the front end and all the things that go with it. We have some automation at the unit test level, but going full out with Selenium UI tests means we're gonna have a bad time. Mostly because...

* we're lacking meaningful identifiers (for humans) to target
* there's a lot of dynamic content
* tons of stuff in the DOM that's hidden most of the time

We could fix some of these issues, remediate the others, but web UI automation is brittle in the best of times. This is not a headache I'm really happy to subject myself to at the moment.

Conversely, the API is a very juicy target. Our API documentation is pretty good and mostly accurate. We've also got a sizeable amount of the API and some automated scenarios documented as part of a Postman suite. I also threw together a lightweight framework using the airborne gem sometime last year.

At a quick glance, this is pretty straight forward to extend. Reporting is easy. We could tie it into our existing GitHub triggers and have it run against dev deployments on merge to master pretty easily. The bulk of the work would be in scripting out the checks. It's a very low hanging target.

However, our API doesn't present the type of risk these checks would be helpful at identifying. It's doesn't account for most of the defects we end up logging. We have a pretty good understanding of how it operates as a unit. We could get a lot of coverage out of it quite easily, but I don't think we get the most immediate benefit from it. It's a "next up" project, for sure.

Given those two options not really making the cut, I've set my sights on iOS. The iOS approval / release cycle is reason enough. Most of the time we do alright, it's usually not more than a day or two before we get approval, but that's every single time we post a build. We've had builds intended for release and we've found a small, but significant issue at the last second.

The codebase on our iOS client is significantly older as well. There's been a number of hands in the code and we've seen a continuing migration from Objective C to Swift. Every time a little piece is migrated we run the risk of missing pieces, misinterpreting non-obvious logic, or unexpected interactions with other code.

We don't have these issues with Android. Approval is usually a fraction of this time frame. The code base is also new and was developed with a knowledge of the pitfalls that cropped up in the iOS application. It comes loaded with less inherited issues.

In an ideal scenario, and I'm aware of the problems that come attached to that phrase, we get more benefits from building up an automation suite against our iOS client than any of our other codebases.

Primarily, we get the run of the mill, superficial checks out of the way quickly and automatically. It doesn't require a testers time, they don't have to keep it in mind for implicit testing while doing other things, and we get relatively rapid feedback. It's a helpful, low level canary.

More importantly, we can reclaim some of that testing time. Appropriately, we don't get more time, we just get to focus our time on more important things. It allows us to be more explicit on the details specific to the build at hand. We can focus on doing deep testing work early in the process, with at least some expectation that the superficial things are chugging along just fine.

Finally, if we do it right, we might be able to get Android "for free". It's never going to be for free, but we could possibly get it without needing to build, develop, and maintain a separate automation codebase for our Android application.

The PoC in progress is using Appium and early tests suggest we'll need to have the occasional exception where we need to be explicit about the platform we're testing in our page object models. More importantly, we'll need to be explicit about the testing hooks we build into the application and finding ways to make those consistent between the two platforms.

From the outset there have been a few criteria our mobile automation PoC has targeted as preferred capabilities:

* must support iOS (simulator & live device)
* should support Android (simulator & live device)
* can run against cloud provider (Sauce Labs or AWS, for example)
* will trigger from our CI service
* provide a qualifying step in our merge process
* can report into a reasonable service (Confluence and/or Slack)
* useful reporting of failures
* can load applications remotely

There have been a couple successes along these already. Still a lot of work to do. Given that I'm not a developer, I suspect it'll be a long(ish) process, but I'm going try to be diligent in documenting how it's going as it goes.

There seems be a lot of training and workshops around Appium. The actual documentation, especially resources helping fairly weak developers, is not great. A lot of the process has been spent simply trying to find information. I need to document here if for no other reason than as a reminder for myself.
