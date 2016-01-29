---
layout: post
title:  "Non-Linear Soundtrack Music"
date:   2016-01-29 14:59:23
categories: gamedev  
---

  So, I think I have a basic handle on what I'm looking for in music "generation" for games. Non-linear music. It's nice to have a word to describe what you're looking for. Assuming, of course, this is the right one.

  One of the functional problems of some of the games I'd eventually like to make is the lack of a fixed length in any space. It's entirely possible for players to linger in a lot of spaces for a very long time. While I'm not entirely concerned about the song being cut short, I am worried about a song repeating too long and getting boring.

  I know how to build a seamless track using a collection of clips. [That's pretty straight forward](http://www.davidshute.ca/gamedev/2016/01/21/unity-audio.html). The non-linear part is where I'm trying to figure it out. I'm sure I could manually build lists and feed these into a method and let it sort it out. I think the basic structure for the data is to have an AudioClip with an int array of possible destinations. It's not a super clean solution, but the music should be fairly static and well defined prior to being imported.

  I think Lists / Dictionaries might be the best way for me to handle this, since I don't know how many elements I'll need to handle ahead of time. Took a peek at [this tutorial here](https://unity3d.com/learn/tutorials/modules/intermediate/scripting/lists-and-dictionaries) and then [this documentation](https://msdn.microsoft.com/en-us/library/xfhwa508.aspx).

  As C# is really not a strong area for me (nor is programming in general), I threw together a quick console application as a proof that I might actually be able to make this work.

  <pre>
  Dictionary<String, String[]> clips = new Dictionary<string, String[]>();

  clips["clip1"] = new String[2] { "clip2", "clip4" };
  clips["clip2"] = new String[3] { "clip1", "clip5", "clip6" };

  foreach ( KeyValuePair<string, String[]> kvp in clips)
  {
      Console.WriteLine("Key = {0}, Length = {1}", kvp.Key, kvp.Value.Length);
      for (int i = 0; i < kvp.Value.Length; i++)
      {
          Console.WriteLine("\t Value = {0}", kvp.Value[i]);
      }
  }
  </pre>

  This seems to work. It gives me what I'm looking for and allows for varied length. Even in a worse case that an audio clip, likely an intro clip, only has a single target destination it's just an array with a single entry.

  <pre>
  Key = clip1, Length = 2
         Value = clip2
         Value = clip4
  Key = clip2, Length = 3
         Value = clip1
         Value = clip5
         Value = clip6
  </pre>

  There's an obvious problem in that I'm not clear if the AudioClip / AudioSource content will easily map in a dictionary and whether I can reference it using a string.

  Took the script, as it exists, and dropped it into Unity with a few minor changes. However, a dictionary doesn't expose as something you can modify through the Unity interface.

  This totally works...

  <pre>
  public Dictionary<string, string[]> clips = new Dictionary<string, string[]>();

  void Start () {
      clips["clip1"] = new string[2] { "clip2", "clip4" };
      clips["clip2"] = new string[3] { "clip1", "clip5", "clip6" };

      foreach (KeyValuePair<string, string[]> kvp in clips)
      {
          Debug.Log("Key = " + kvp.Key + " | Length = " + kvp.Value.Length);
          for (int i = 0; i < kvp.Value.Length; i++)
          {
              Debug.Log("\t Value = " + kvp.Value[i]);
          }
      }
  }
  </pre>

  It just doesn't expose it in an immediately obvious / helpful way for me to add generic clips to it.

  Taking a step back from this. I don't think it's a huge step to take my existing seamless playback code and modify to grab a random clip from the list of available clips.

  Modified out the previous code to support pulling a random index to be queued for next track. Also modified it to run in the background. This was mostly done to let it run to ensure I'm not hitting any out of index issues. I shouldn't, as the Mathf.FloorToInt should round down.

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

      void Start()
      {
          for (int i = 0; i &lt; 2; i++)
          {
              GameObject child = new GameObject("Player");
              child.transform.parent = gameObject.transform;
              audioSources[i] = child.AddComponent&lt;AudioSource&gt;();
          }
          nextEventTime = AudioSettings.dspTime + 2.0F;
          running = true;
          Application.runInBackground = true;

      }

      void FixedUpdate()
      {
          if (!running)
              return;

          double time = AudioSettings.dspTime;
          if (time + 1.0F &gt; nextEventTime)
          {
              audioSources[flip].clip = clips[currentClip];
              audioSources[flip].PlayScheduled(nextEventTime);
              nextEventTime += audioSources[flip].clip.length;
              flip = 1 - flip;
              currentClip = Mathf.FloorToInt(Random.Range(0f, (float)clips.Length));       
          }
      }
  }
  </pre>

  I let it run while I was looking up some other stuff. I also had it logging what it was queued up next as it was going. It hit the upper and lower bounds without ever going outside. It also showed good variation within the selections. That's good enough for me for now, in that respect.

  The next trick is giving it some sort of decision tree and having it use that tree instead of strictly random selection.
