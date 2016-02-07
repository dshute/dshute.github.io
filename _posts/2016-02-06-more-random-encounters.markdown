---
layout: post
title:  "More Random Encounters"
date:   2016-02-06 19:53:23
categories: gamedev  
---
Took a minute to go back to [this in the Unity documentation](http://docs.unity3d.com/Manual/RandomNumbers.html). It is essentially attacking the problem in a similar way to [my solution](../03/random-encounters.html). Instead of multiplying the total values to a larger number and then selecting a random value within, it uses floats to represent a value within the range of values. Since Random.Range pulls a float between a min and max float, this makes sense.

As I was thinking about this I started to move a little bit sideways to all the all the bits of random logic required. Off the top there are four things that need to be determined during game play.

1. Triggering Random Encounters
2. Populating Random Encounters (what I've been looking at recently)
3. Random Encounter drops
4. Time Out Between Random Encounters

#### Triggering Random Encounters

This seems like a basic enough problem, create a Box Collider 2D around an area (or create a compound collider) and attach a script to it. Within the OnTriggerStay2D method, pick a reasonable value to be a "hit" for a random encounter. I tested out with the following and it seems to hitting about once a second. It'd certainly needed to be ramped down a bit, but that's a matter of changing the value.
<pre>
void OnTriggerStay2D(Collider2D other)
{
		float check = Random.Range(0f, 1f);
		if (check > 0.99)
		{
				Debug.Log("Random Encounter Hit");
				// call encounter function here
		}
}
</pre>
This should really be something surfaced as a public variable anyway, to allow different areas to have different encounter frequencies.

#### Populating Random Encounters

Aside from selecting which enemies to populate an encounter with there needs to be a check done for how many as well. What constitutes an appropriate encounter? Six very strong enemies would present a painful battle, while one common one would be an annoyance. There's some thought that would need to be put into balancing the enemies to ensure encounters are neither tedious nor (unnecessarily) punishing.

#### Random Encounter drops

I think most of these would be pretty straight forward. It's a similar selection to populating the encounter with enemies in the first place. Specific enemies have specific weighted drop lists and you pull randomly. Gold / [insert currency here] could be done using a weighted curve, as noted in [the Unity documentation](http://docs.unity3d.com/Manual/RandomNumbers.html).

Now that I think of it, the weighted curve could be used for triggering random encounters as well.

#### Cool Down Time

This seems like a necessary evil for me. While the random encounter likelihood should be spread out enough, in a random environment it would be possible to have multiple encounters back to back. Putting in a configurable cool down time would alleviate that problem. It'd really just need to be an exposed value for tweaking between areas.

This might be tied to the encounter frequency. Or not. Requires more thought.

*Do you make that a movement based cool down or a time based one?*

I am inclined away from time based cool down. Just because you waited more than three seconds doesn't mean you're ready to go right back into battle. You could have gotten up to the get a drink or go to the washroom or check your phone. There are lots of reasons to allow time to elapse.

It probably shouldn't be a delta from previous encounter location. That just means you could walk within a radius with impunity. It doesn't really do you much go and someone grinding might do so within a tight radius. [The Jurassic Park area in Final Fantasy 6 World of Ruin](http://finalfantasy.wikia.com/wiki/Dinosaur_forest) map comes to mind.

I think the best would be a combination of the two; length of time the player is moving. Create the cool down time and only subtract from it while the player is in motion. This would actually be pretty easy since the OnTriggerStay2D function only runs will the player is moving.

Cool down time > 0, subtract some time from it.<br />
Cool down time <= 0, check for random encounters.

*Is it modified by whether you won the fight or ran from it?*

I think this is a relevant point. Fighters on the run should attract more fights, shouldn't they? I think my problem here is that I don't know if it should be a fraction of the default cool down time or its own exposed value, configurable per area. It's something I'll need to think on.
