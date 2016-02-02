---
layout: post
title:  "Non-Linear Soundtrack Sequencing"
date:   2016-01-29 18:59:23
categories: gamedev  
---

  So, the [biggest stumbling block I've had thus far is trying to pass information](http://www.davidshute.ca/gamedev/2016/01/29/non-linear-audio.html) in a way is easy and maintainable. The problem being that I've been trying to pass arbitrary, loosely structured information... and I'm not terribly smart.

  What I can say about the clips that would be introduced is that there are likely only a limited type of clips.

  * intro pattern
  * core patterns
  * extension patterns
  * limited exit patterns

  There may be more, but off the top, this seems like a reasonable list of things that we can control about the incoming data. Given that, we should be able to extrapolate a list of appropriate targets.

  -- Intro Pattern ➝ Core Patterns

  -- Core Patterns ➝ Core Patterns<br />
  -- Core Patterns ➝ Extension Patterns<br />
  -- Core Patterns ➝ Limited Exit Patterns

  -- Extension Patterns ➝ Core Patterns<br />
  -- Extension Patterns ➝ Limited Exit Patterns

  -- Limited Exit Patterns ➝ Core Patterns

  This is now at least structured and we can wrap rules around the incoming data to ensure that it conforms to our expected structure. Realistically this can be done by ensuring the incoming audio naming conforms to an expectation. There are some other options booping around my head right now, but this is the first one I want to explore.

  * intro patterns ➝ a{xxxx}.{xxx}
  * core patterns ➝ b{xxxx}.{xxx}
  * extension patterns ➝ c{xxxx}.{xxx}
  * limited exit patterns ➝ d{xxxx}.{xxx}

  The code is still a bit ugly to look at, but I think I've got it figured out. I tested it by logging each track as it plays. The logic I've outlined above seems to be consistent with logged output.  It is very far from perfect, but solves the initial problem I was concerned about.

  <pre>
  using UnityEngine;
  using System.Collections;
  using System.Collections.Generic;

  [RequireComponent(typeof(AudioSource))]
  public class MusicSequencer : MonoBehaviour
  {

      public AudioClip[] clips;

      private double nextEventTime;
      private int flip = 0;
      private AudioClip currentClip;

      private AudioSource[] audioSources = new AudioSource[2];
      private bool running = false;

      void Start()
      {
          for (int i = 0; i < 2; i++)
          {
              GameObject child = new GameObject("Player");
              child.transform.parent = gameObject.transform;
              audioSources[i] = child.AddComponent<AudioSource>();
          }
          nextEventTime = AudioSettings.dspTime + 2.0F;

          // set the first clip in as the intro clip
          currentClip = clips[0];

          running = true;
          Application.runInBackground = true;

      }

      void FixedUpdate()
      {
          if (!running)
              return;

          double time = AudioSettings.dspTime;
          if (time + 1.0F > nextEventTime)
          {
              audioSources[flip].clip = currentClip;
              audioSources[flip].PlayScheduled(nextEventTime);
              nextEventTime += audioSources[flip].clip.length;
              flip = 1 - flip;
              ClipSequencer();
          }
      }

      void ClipSequencer()
      {
          List<AudioClip> destinationClips = new List<AudioClip>();

          char activeClip = currentClip.name[0];

          switch (activeClip)
          {
              case 'b':
                  for (int i = 0; i < clips.Length; i++)
                      if (clips[i].name[0] == 'c')
                          destinationClips.Add(clips[i]);
                  goto case 'c';
              case 'c':
                  for (int i = 0; i < clips.Length; i++)
                      if (clips[i].name[0] == 'd')
                          destinationClips.Add(clips[i]);
                  goto case 'a';
              case 'a':
              case 'd':
                  for (int i = 0; i < clips.Length; i++)
                      if (clips[i].name[0] == 'b')
                          destinationClips.Add(clips[i]);
                  break;
          }
          
          currentClip = destinationClips[Mathf.FloorToInt(Random.Range(0f, destinationClips.Count))];        
      }

  }
  </pre>
