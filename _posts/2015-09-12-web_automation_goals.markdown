---
layout: post
title:  "Web Automation Goals"
date:   2015-09-12 22:17:00
categories: automation  
---

*Web UI Automation*

I've been thinking a lot about automation lately. The main reason for this being that the current state of testing at my organization simply isn't sustainable. Finding bright and effective manual testers with solid skill in exploratory and black box testing is difficult. Doubly so when the interesting companies to work at in the area are looking for the exact same people. Even if we could always find the exact people with the exact skills we were looking for it's just not sustainable. We can't open up enough seats to fill in all the work that we need to accomplish. Given the head first, full on agile approach we're taking it is essentially a requirement to begin injecting more automation.

In my entire experience, I've yet to see a broad automation effort truly succeed. I've seen some simple examples work to basic degree. I've built some of my own tools that have definitely assisted in my work. I've never seen a big, broad automation product succeed. Those of my colleagues who have seem success invariably note the teams of people behind those automation projects that keep them afloat. Automation products are just another product, after all. Someone has to write them and maintain them. 

I've spent a lot of time in discussions and meetings around automation simply shaking my head. I don't think that's a reasonable response, given the scalability of testing in my organization. So, I've been wondering how I'm going to fix that. 

I've started with a simple list of ideals I think I need to hit. I don't pretend that any of these of novel in anyway. I'm merely documenting it for my  own benefit.

*High Abstraction*

Ideally, I'd like for nearly all of the code interaction to be abstracted away. Anyone should be able to write a new automated check provided functions exists to support their actions. A nominally code aware support tech should be able to cobble together a check given a few basic examples and the function documentation.

*High Risk*

Anything in a high traffic area that can throw obnoxious error messaging; especially messaging that is visible to the end user. 

*Low Complexity*

The more steps in the chain, the more likely it is to fail for reasons external to the automated check criteria. For this reason, checks should target a single or very small group of validations / confirmations.

*Low Specialization*

This targets items that can easily be abstracted away. The more complex and uniquely specified the abstraction is, the higher the likelihood it will fail for reasons external to the automated check criteria.

*Automated Test Environment*

As automated checks are of high value to developers, an environment needs to be in place to allow simple submission for checks to be run automatically. It can not require high configuration and can not tie up developer resources.

*Day One Functionality*

This should be usable, even at a basic and low value level, from day one. A brilliant automation framework nine months from now (maybe, assuming constant progress and no changing requirements) does nothing to help today. It does nothing to move us forward. Useful functionality from as close to day one as possible.

*So, What's Next?*

I really like the 'day one functionality' principle. I'm quite infatuated with learning to speak different languages, despite not being terribly good with any outside of English, and I've spent as much time learning other languages as learning about learning other languages. A fundamental principle a lot of polyglots espouse is to talk your target language from day one if your goal is to speak fluently. Practice the attribute you wish to strengthen.

Writing a framework and automated checks is not the goal. The information returned by automated checks and its impact of the development, testing, and release workflows are the goal. Target to do these from day one.