---
layout: post
title: Implementing OUYA Controls
date:   2016-02-16 22:14:44
categories: gamedev
---
I've gone ahead and merged my [Get Thee to the Bunker](https://github.com/dshute/GetTheeTTB/tree/master) OUYA branch down into master. Mostly because this is never intended to be a properly released game. I don't think it's that tragic to have the OUYA content in there by default. OUYA is currently my only target and it'll save me having to continually pull stuff into the OUYA branch. The next step is getting the OUYA controller to perform input.

At first blush, it didn't go so well. It seemed like there should be a super easy solution. Like this: [https://github.com/rendermat/OuyaInputFramework](https://github.com/rendermat/OuyaInputFramework)

Per the documentation, it should have just been a drag and drop. Given that it's three year old content I wasn't confident it would be so easy. That instinct appears to have been accurate.

I started getting definition errors when it was trying to access the controls. Not enough to break it, but enough to throw a bunch of errors and it wasn't doing anything to allow control on the OUYA. Understandably as there was no link there. I took a peek to see if any of the forks were newer, but no such luck.

I suspect that fixing this wouldn't be that hard and is mostly down to updates in Unity changing some button mapping. I'm just not comfortable and confident enough yet to start chasing that down. I feel like I'd be going down the rabbit hole with no real end in sight.

Given that the shortest distance didn't work, I thought I might as well go to the source. [https://devs.ouya.tv/developers/docs/unity](https://devs.ouya.tv/developers/docs/unity)

I figured I'd start simple. This is required in the header of any file using the OUYA controls.

{% highlight csharp %}
#if UNITY_ANDROID && !UNITY_EDITOR
using tv.ouya.console.api;
#endif
{% endhighlight %}

I've got this little bit of code in my title screen.

{% highlight csharp %}
void Update ()
  {
      float horizontal = Input.GetAxis("Horizontal");

      if (horizontal < 0 && !onPlay)
      {
          playButton.Select();
          onPlay = true;
      }
      else if (horizontal > 0 && onPlay)
      {
          exitButton.Select();
          onPlay = false;       
      }
}
{% endhighlight %}

I popped this underneath the first line

{% highlight csharp %}
#if UNITY_ANDROID && !UNITY_EDITOR
        horizontal = OuyaSDK.OuyaInput.GetAxis(0, OuyaController.AXIS_LS_X);
#endif
{% endhighlight %}

I did a build and pushed it to my OUYA. As a basic proof of concept, it certainly worked and proved that I was at least looking in the right direction.

Getting a button to work was essentially the same process. Though, it seemed like I was bypassing Unity's built in button features to do so. _(There may be [see: likely] a better, more graceful way to do this.)_

{% highlight csharp %}
#if UNITY_ANDROID && !UNITY_EDITOR
        if(OuyaSDK.OuyaInput.GetButton(0, OuyaController.BUTTON_O) && onPlay)
        {
            GameLoad();
        }
        else if (OuyaSDK.OuyaInput.GetButton(0, OuyaController.BUTTON_O) && !onPlay)
        {
            GameQuit();
        }
#endif
{% endhighlight %}

Put all this together, I'm able to get out of the main menu and into the next scene. Awesome.

The next step was to take this and dump it into the overworld scene to allow character movement. It was essential the same process, adding Y axis for vertical movement, save two issues.

The first is that the controller never resets to 0, 0. It always seems to be at some small number greater than zero.

To prove this out I dumped some UI text elements into the overworld view and fed the live left stick X/Y values. What I found was even very subtle, tiny movements could reach as high of a value as 0.3. I solved this by creating my own dead zone.

In this example horizontal and vertical are absolute values of the controller input X and Y values.

{% highlight csharp %}
if (horizontal > vertical && horizontal > 0.4)
 {
     playerDirection = (moveHorizontal > 0) ? direction.east : direction.west;
     anim.SetBool("Moving", true);
 }
 else if (horizontal < vertical && vertical > 0.4)
 {
     playerDirection = (moveVertical > 0) ? direction.north : direction.south;
     anim.SetBool("Moving", true);

 }
 else if (horizontal <= 0.4 && vertical <= 0.4)
 {
     anim.SetBool("Moving", false);
 }
{% endhighlight %}

This seemed a little higher of a threshold than I wanted, so I surface two public floats as deadZoneX and deadZoneY. This was I can set these to whatever I want. In an instance where we can trust that an idle thumb stick will reset to 0, 0 we can use those values. If not, set them as desired.

I also extended the title screen selection controllers to include a basic dead zone. Although I noticed something off when I was originally testing it, I didn't directly identify the problem of it not sitting at 0, 0. In some instances it "started" at Exit and others bounced back really quickly if I wasn't restrictive with my movements on the thumbstick.

The second problem is that the Y axis was inverted compared to the 360 controller. Simple solution though.

When I'm getting the Y axis values to store in the moveVertical float I just multiply it by -1. This then matches my expectations and the existing logic.
