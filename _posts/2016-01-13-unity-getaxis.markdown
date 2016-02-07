---
layout: post
title:  "Unity GetAxis Testing"
date:   2016-01-13 23:05:59
categories: gamedev  
---

Given that MonoGame and Xamarin are effectively dead to me, I've been inclined to pick up something else. In this case, that something else turns out to be Unity.

One of things that I've been toying with is the idea of making a pretty basic 16bit style JRPG. I know... Original, right?

It's something I've had ideas around for a very long time and, while I don't think I'd ever finish it, I think there's a lot to learn along the way.

One of the first things that interested me was moving only in cardinal directions with an analog controller. I've got a wired XBox 360 controller connected to my computer and it gives all kinds of positional information that isn't terribly helpful when all you want is up, down, left, and right.

I'm sure this is a solved problem somewhere, but I wanted to play with it and see if I could get it to work.

I started with the <a href="http://docs.unity3d.com/ScriptReference/Input.GetAxis.html">Input.GetAxis</a> function, as this is what tutorials provided up. It works well enough, but it gives a range requiring a bit of silliness to figure out what I'm doing.

Admittedly, these are going to be terrible. I am not a programmer.

{% highlight csharp %}
float horizontal = Input.GetAxis("Horizontal");
float vertical = Input.GetAxis("Vertical");
int movement = 0

if (Mathf.Abs(horizontal) > Mathf.Abs(vertical))
{
  // we're moving horizontally
  movement = (horizontal > 0) ? 1 : -1;
  movePlayer(movement, 0);
}
else if (Mathf.Abs(horizontal) < Mathf.Abs(vertical))
{
  // we're moving vertically
  movement = (vertical > 0) ? 1 : -1;
  movePlayer(0, movement);
}  
{% endhighlight %}

This effectively allowed me to move in a single direction, but ignored a couple of other things. Most of all, it bothered me that I needed to get an absolute value from the input values to begin with.

I took a little bit of a further look and found <a href="http://docs.unity3d.com/ScriptReference/Input.GetAxisRaw.html">Input.GetAxisRaw()</a>. This seemed to be exactly what I was looking for. Some of the conversations I found noted that it was an whole value between -1 and 1. Perfect. Biggest absolute number wins and then you just follow the value.

Having been wrong in my assumptions before I wanted to test it.

I created a new project, super simple, with just two text elements. These elements wrote to screen the X and Y values for Input.GetAxis and Input.GetAxisRaw. Started it up and imagine my surprise.

Using the controller analog stick gave me the exact same results in both. Float values with steps all the way along.

So, it's turns out, Input.GetAxisRaw only does absolute values for (I presume) buttons / keys / switches. Pressing the arrows on the keyboard and it gives the expected -1, 0, 1 for both and X and Y. It seems that Input.GetAxis performs smoothing on these and gives intermediate values along the way.

Input.GetAxisRaw is not the solution I'm looking for, it would seem.
