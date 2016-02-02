---
layout: post
title:  "Sloppy Camera Follow"
date:   2016-02-01 22:09:23
categories: gamedev  
---
Quick changes made on [Get Thee To The Bunker](https://github.com/dshute/GetTheeTTB). I had already implemented a follow camera, but this was a static follow that moved 1:1 with the player. This is fine, and gets the job done, but feels pretty stiff. What I wanted was a bit of delay, kind of a sloppy follow that let's the player get a bit of lead.

What I ended up with was [a very easy change](https://github.com/dshute/GetTheeTTB/commit/cb380f4c7d263325ae0270fc57f7ecde31bf9817). I surfaced a public float to control the amount of delay and modified the camera's position transform to use the [Vector3.Lerp](http://docs.unity3d.com/ScriptReference/Vector3.Lerp.html) method. This was a two line change and feels much more smooth.

I remembered hearing about this in a [gamesplusjames Unity tutorial video](https://www.youtube.com/watch?v=J6BQ4Fcy4cc). My solution is slightly different, but not by anything terribly significant.
