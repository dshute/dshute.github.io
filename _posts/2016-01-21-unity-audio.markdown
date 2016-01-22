---
layout: post
title:  "Unity, Audio, and Building a Soundtrack"
date:   2016-01-21 23:05:59
categories: gamedev  
---

The poking at Unity continues unabated. Surprising even myself, I think I've touched it for at least an hour everyday for a couple weeks now. Shocking.

One of the things that I've been thinking about has been building the soundtrack from components. Lets say that an area should only take about two or three minutes to get through, but it's not enforced. You could be there for a minute or fifteen. The short distance is to just loop the track, and this is a fine answer, but it's not quite what I would like to do.

Audio and music is easily one of my stronger skillsets when it comes to game dev disciplines. For this reason it's probably one that I've thought the most about. Ideally, what I'd like to do with something like this, is build it based off of pieces. Slice up a track into a collection of loops and then stacks those loops one after another.

The Unity documentation has an example of how to do this in the [API AudioSource.PlayScheduled reference](http://docs.unity3d.com/ScriptReference/AudioSource.PlayScheduled.html).

I'll preface the following with the absolute knowledge that there are probably much better ways to do what I'm doing. If I had a clue I wouldn't need to write this shit down.

#### Making Changes

There were a couple problems I had with the example. First, it requires that all the clips be of uniform length, in the form of having the same BPM and bars (numBeatPerSegment). Sure, this allows it to calculate the length to accurately change between clips, but it just seems odd. Unity already knows how long a clip is. Just look at it in the inspector. It will show you the length of any given clip down to the millisecond. That's good enough accuracy. We don't need to calculate a float for the time.

This also doesn't account for not having uniform clips. A time signature change, a BPM change, or the number of measures in a clip all blow this calculation up. It would work well for an EDM track, or even most popular music genres for that matter, but not for a lot of what I do. I chucked that code straight out and kept moving forward.

The next thing I wanted to change was this:

<pre>
public AudioClip[] clips = new AudioClip[2];
</pre>

It's just not enough tracks. Easy enough to solve.

<pre>
public AudioClip[] clips;
</pre>


Now Unity will ask me how many clips to use and give me an element for each one to drop in any clip that I want.

Now, the next step threw me for a seconds. I felt like I needed as many AudioSource components as I had AudioClip components. This becomes a bit stickier, as I'd like to be able to reuse this. I don't know how many clips I'm going to have. How am I supposed to know how many AudioSources I'm going to need.

This was just a flat out misunderstanding of how it was working to begin with. There's a little bit of supposition here, but I believe the initial code was bouncing back and forth between two audio sources to ensure they were appropriately loaded and able to trigger seamlessly between the two. In that case, it doesn't matter how many AudioClip components there are, they just need to be assigned to alternating AudioSource components.

Moving on to the Start() method, I didn't really change much other than to get rid of the while-loop. It just didn't read as cleanly for me as a for-loop does. With that in mind I restructured it.

<pre>
for (int i = 0; i < 2; i++)
{
    GameObject child = new GameObject("Player");
    child.transform.parent = gameObject.transform;
    audioSources[i] = child.AddComponent&lt;AudioSource>();
}
</pre>


It does nothing different, but it makes me feel better about how the code reads.

The last major change I needed to make was allowing it to use the length of the clip to set the next schedule time and allow it to cycle through an arbitrary number of audio clips.

<pre>
if (time + 1.0F > nextEventTime)
{
    audioSources[flip].clip = clips[currentClip];
    audioSources[flip].PlayScheduled(nextEventTime);
    Debug.Log(currentClip + " " + flip);
    nextEventTime += audioSources[flip].clip.length;
    flip = 1 - flip;
    currentClip = (currentClip < clips.Length - 1) ? currentClip + 1 : 0;
}
</pre>

#### The Full Source

I kept a decent amount of the original code, but here's where I ended up.

<pre>
using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class MusicQueue : MonoBehaviour
{
    public AudioClip[] clips;

    private double nextEventTime;
    private int flip = 0;
    private int currentClip = 0;

    private AudioSource[] audioSources = new AudioSource[2];
    private bool running = false;
</pre>

I've pulled out the clip length calculation content, modified clips to be an arbitrary length based on instance configuration, and introduced an integer to keep track of what clip is currently playing.

<pre>
    void Start()
    {
        for (int i = 0; i < 2; i++)
        {
            GameObject child = new GameObject("Player");
            child.transform.parent = gameObject.transform;
            audioSources[i] = child.AddComponent&lt;AudioSource>();
        }
        nextEventTime = AudioSettings.dspTime + 2.0F;
        running = true;
    }
</pre>

I really didn't change anything here other than to modify the while-loop to a for-loop.

<pre>
    void FixedUpdate()
    {
        if (!running)
            return;

        double time = AudioSettings.dspTime;
        if (time + 1.0F > nextEventTime)
        {
            audioSources[flip].clip = clips[currentClip];
            audioSources[flip].PlayScheduled(nextEventTime);
            nextEventTime += audioSources[flip].clip.length;
            flip = 1 - flip;
            currentClip = (currentClip < clips.Length - 1) ? currentClip + 1 : 0;
        }
    }
}
</pre>

Here's one that I'm not sure about. When I was testing this using the Update() method I initially got a bit of odd bleed. I don't know why, but the second track started playing over the first. Given that seamless audio is a time sensitive activity I changed it to FixedUpdate() and it's worked flawlessly ever since. I know this is meant for physics calculations, but it seems to be working fine here.

If this is incorrect, I'd really like to know _why_ it's incorrect.

Aside from that, it's pretty straight forward.

* assign the current clip to the current audio source
* set the play schedule for the current clip
* increment the nextEventTime by the next clip play length
* flip the active audiosource for the next time we run this
* increment the currentClip within the bounds of the clips array for next run

#### What That Shit Do?

Right now, it seems to be working adequately. It's no where near where I'd like it to do, but I could fairly easily drop this into any scene, cram a bunch of clips into, and have it happily play forever.

Where it falls down for me is right in the above statement. There's not logic to help it to do anything more interesting that just taking a single massive track, dropping it into an AudioSource component, and tick play on awake and loop. What I'd like to do is just have it build up on its own. Give a decision tree and let it keep generating the track as it goes.

Since we're never going to "reach the end" we don't have to worry about having a specific ending. Clip 0 is our intro and is only ever played once. Outside of that, any other clip can and should have more than one possible target for next track. If we consider source and target as follows for an eight clip section.

* 0 => 1
* 1 => 2, 4, 7
* 2 => 1, 4
* 3 => 5, 7
* 4 => 5
* 5 => 1, 3, 7
* 6 => 2, 7
* 7 => 1

This is where it's going to get complicated for me. It's easy enough to give it that logic, but I'm going to need to test that it works that I way I want first and then figure out a way to give it that logic on a per instance basis. That, I suspect, is going to be a bit trickier.

Finally, it needs an unload. When, for whatever purpose, the song is supposed to change, I need a clean way to fade out the current track, kill the queuing, and move on. I suspect that will be fairly easy, but still remains to be investigated and solved.
