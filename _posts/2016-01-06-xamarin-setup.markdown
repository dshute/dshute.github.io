---
layout: post
title:  "Xamarin MonoGame Happiness"
date:   2016-01-06 22:17:00
categories: gamedev  
---

As I've been pretending that I'm going to learn how to program, how to program games, and MonoGame I figured I'd take that delusion a step further. I pulled my OUYA out of storage because, hey, this is just an Android box and MonoGame supports it. Should be easy, right?

Visual Studio only supports the Windows based stuff, so, if I was ever to move past that I'd need Xamarin anyway. Sure. Why not. Started checking out Xamarin and it wasn't immediately clear to me how their platform worked in terms of cost. Especially being spoiled by the Community (see: free) edition of Visual Studio it didn't really make sense to me. Grabbed the installer anyway and gave it a boo.

After it installed 2 GB of dependencies it offered me the chance to actually give it a shot.

Open up Visual Studio, create a new MonoGame OUYA solution, attempt to compile and... requires a Xamarin account. Awesome.

Go to their site, create a new account, go back into VS and login. Attempt to compile. Incorrect Android target.

Sure. I understand what this means, but have no clue on how to fix it. Spend a bit poking around the solution before I give up on stabbing around in the dark, trying to stumble upon it. (Poke, stab, and stumble all in the same sentence for the same reason. Nice.) Google it. Figure out how to change target and update it for what Xamarin supports. Attempt to compile and...

Project exceeds the maximum size for a free account. You must have a business subscription to build projects this big. This is the default MonoGame template I'm trying to build, please keep in mind, and to even see how it pans out I need a $999 a year subscription.

I mean, that doesn't matter anyway, because OUYA counts as Android and Android requires a... You guessed it, business account.

Learning is so much fun when it drags you into expensive dark corners that you'll never have justification to explore.
