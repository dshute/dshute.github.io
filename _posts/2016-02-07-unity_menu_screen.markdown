---
layout: post
title: A Simple Title Screen Menu
date:   2016-02-07 20:20:26
categories: gamedev
---
I was curious about doing a title screen. Before I started working on this Get Thee to the Bunker loaded directly into the hacky overworld scene. I wasn't entirely sure on how to manage and load across scenes so I took a peek at it.

I dropped a canvas into a new scene. Not entirely necessary, but as I will eventually want to utilize some of the functionality in the UI tools I might as well start there. Gave it some text in the middle of the screen.

Now, ideally, there would be a menu that could be navigated through, but as a first step I just wanted to load or exit depending on controller input. This turned out to be super simple.

{% highlight csharp %}
using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;

public class TitleMenu : MonoBehaviour {

	void Update () {

        if (Input.GetAxis("Fire1") != 0f)
        {
            SceneManager.LoadScene(1);
        }

        if (Input.GetAxis("Fire2") != 0f)
        {
            // Add logic to verify quit request
            Application.Quit();
        }
	}
}
{% endhighlight %}

You can see in here I'm not even touching the UI functionality. As Application.LoadLevel is deprecated I'm using the SceneManage.LoadScene() method which requires the using statement at the top. At a very superficial level, this works. On the XBox 360 controller I'm using for testing, A button loads the overworld scene and B exits the application.

Since you can't really test exiting the application within Unity I did a Windows build and tested it there. I also added the X button as an app quit within the PlayerController.cs file. Mostly so that I can easily get out of the game when testing local builds.

That's cool. That works, but it's pretty simple. The next step was to add some UI elements and toggle between them.

Dropped in two new text objects and assigned them as buttons. Playing around with the intellisense, I noticed that there is a button.Select() method. Giving it a shot it did exactly what I expected it to, selecting the button or doing the same as a mouseover would. This toggled the highlight. Super.

What I really wanted to know was how to get it to check if a button was "selected". Taking a glance through the button methods there didn't seem to be a quick way to do this. So, as I'm using a two selection option, I'm just cramming state into a private bool. It will get the job done.

The next step then was to capture control input and select a button appropriately.

{% highlight csharp %}
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
{% endhighlight %}

This actually works pretty well and is moderately readable. It's pretty straightforward from there.

On the play button when the user presses the "Fire1" button? Load the appropriate scene.

If not, quit the application.

There was one last thing I cleaned up.

Initially, I was doing the load and quit within the game script. I didn't need to do this as the Button component will run any public method it has access to when clicked/triggered. It seems to do this automatically against the "Fire1" button.

This is way cleaner than having nested or compound if statments to check if Fire1 has been pressed, what the state of the onPlay bool is, and then perform an action from there.

Here's the full menu script.

{% highlight csharp %}
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.Collections;

public class TitleMenu : MonoBehaviour {

    public Canvas titleScreen;
    public Button playButton;
    public Button exitButton;

    private bool onPlay;

    void Start ()
    {
        playButton.Select();
        onPlay = true;
    }

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

    public void GameLoad()
    {
        SceneManager.LoadScene(1);
    }

    public void GameQuit()
    {
        Application.Quit();
    }

}
{% endhighlight %}

Got a bit of assistance on this from [Creating a Start Menu in Unity 5](https://www.youtube.com/watch?v=pT4uca2bSgc) YouTube tutorial.
