---
layout: post
title:  "Random Encounters"
date:   2016-02-03 21:09:23
categories: gamedev  
---
I've been thinking about how to do random encounters as part of Get Thee To The Bunker. Ideally, and in the grand tradition, different areas have different monsters and some will happen more often than others. I was trying to figure out how to do this and I think I came up with a half assed solution.

I prefer Ruby for quickly testing out ideas. So that's what I did.

<pre>
def monstercheck(enemy_hash, choice)
	check = 0
	enemy_hash.each { |enemy, value|
		check += value
		return enemy if choice <= check
	}
end

enemies = { "regular1" => 20,
	"regular2" => 20,
	"regular3" => 20,
	"regular4" => 20,
	"regular5" => 20,
	"exceptional" => 10,
	"elite" => 5,
	"boss" => 1
	}

cumulative = 0

enemies.each { |enemy, value|
	cumulative += value
}

cumulative = cumulative * 10
monster = (rand(cumulative))  / 10
puts monstercheck(enemies, monster + 1)
</pre>

I'm sure this is sloppy as hell, but it certainly gets the job done. There are some other considerations, but this solves the primary problem of weighted random selection.

After doing this I found [this in the Unity documentation](http://docs.unity3d.com/Manual/RandomNumbers.html). I guess I'll look into that as I go forward.
