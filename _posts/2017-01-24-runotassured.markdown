---
layout: post
title: Are You Not Assured?
date:   2017-01-24 22:34:52
categories: testing
---
#### Quality assurance in software is not a thing.

Sure, there is an entire software quality assurance industry out there. My own pay cheque has and will (most likely) continue to come in the name of software quality assurance.

Neither of those make quality assurance in software an actual thing.

As a practice, quality assurance requires a declarative statement about a subjective assessment making it awkwardly misnamed at best and entirely unrepresentative at worst.

#### The legacy of quality assurance

The idea of quality assurance is a hold-over from manufacturing; from a field that is focused on ensuring that quality requirements are being fulfilled. Requirements that are structured and well defined. It is divorced from quality control and instead focuses on how well quality control was implemented.

This is a very narrow subsection of what most people working in software as 'quality assurance analysts', or similarly titled roles, actually perform. Moving aside from requirements never being exhaustive, most are fulfilling roles across assurance, control, and management.

The historical borrowing from manufacturing falls apart in the analogy. In software, it is absolutely not about assuring the state of a product, but about assessing, mitigating, and communicating risk. It is a learning practice much more than it is a corrective one. Software testers are no more quality assurance than developers are assembly linesmen.

In this absence of well defined and static metrics to measure quality against things start to get more interesting.

#### The inherent problem of qualitative metrics

It's super convenient to fall back on Jerry Weinberg's definition with James Bach's addition here:

    Quality is value to some person who matters.

Not only is it constrained to the perspective of an individual or individuals, a qualitative measure is inherently subjective and therefore subject to the time, space, and emotional state the assessor is in.

_At what point do you think it's time get more gas?_

Pretend we get a reasonable sample group and the majority consensus is that at 25% of a tank they feel it's necessary to fill up. That's a pretty specific number. Something that we can reference.

As a general rule, perhaps that's fine, but it misses a lot. It misses the context that caused those initial assessments of "when".

* how often you drive
* what kind of car you drive / gas tank size
* the weather outside
* the price of gas
* whether you've ever run out of gas before
* whether you've been nearly out of gas and also out of money before
* if you're the person responsible for putting gas in the car

Any of those factors may be relevant or extremely important to our customers. If we fall back on that general rule we can apply a metric that is generically fine, but misses supporting the "some person who matters". Qualitative metrics are not only subjective, but directly related to the consequences of environment.

Given that we can't give the same type of assessments as those found in manufacturing we then end up relying on...

#### The joys of reification

Even if we're not comfortable with accepting the lineage, people still identify with the legacy of what quality assurance means. This leads to stakeholders / leaders / customers to value explicit statements of assurance. This is how we end up with companies fetishising scripted regression suites because they provide hard numbers. There is very little I find more distressing than when [reification](https://www.logicallyfallacious.com/tools/lp/Bo/LogicalFallacies/154/Reification) and [Goodhart's Law](http://www.atm.damtp.cam.ac.uk/mcintyre/papers/LHCE/goodhart.html) get drunk together.

Qualitative measures can not be quantitative. And quantitative measures probably should not be a substitute for quantitative measures.

#### Yeah? So what?

We need to prove that the system works.

Do we? I'm not so sure about that. Even if we did, that's not a thing anymore than software quality assurance is a thing.

* We can assert that aspects of a system are working (as we understand them to be intended).
* We can assert that our understanding of system does not include any significant problems (that we've found).
* We can assert that are definitely bugs still in the system (that we believe are likely to be minimal hindrances or obscure corner cases)

The foundational statement of proving the system works is not objectively possible. We can not assure the quality of the system, not in the manner

If we're not quality assurance, if we can't reasonable assure the quality of the system, then what are we?

#### Contextual Communicators

Calling software testers proxies for the customer is unfortunately nearsighted. We operate effectively as such, but it's an extremely narrow band. When I'm collecting information about a system I care about many things and try to act as an advocate for each.

* user experience and accessibility
* functional "correctness"
* security
* performance
* scalability
* reliability
* consistency (internally, with standards, and with equivalent systems)
* supportability
* automation capacity
* and more I'm just not smart enough to pull front of mind right now

I try to approach each of these to best of my ability with the intent of performing my job as a software tester ethically. Each of those lenses exists explicitly to gather as much information as I can. My effective role is then to contextualized that information and present it to the people that matter in an effective manner.

Maybe software tester doesn't imply the role of contextual communicator, but it at least operates without the albatross of industrial quality assurance.
