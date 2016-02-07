---
layout: post
title: Unity and OUYA
date:   2016-02-07 18:28:52
categories: gamedev
---
I'm adding OUYA support to Get Thee to the Bunker.

I know, Unity and OUYA, I can hear the indie game hipster eyerolls from here. Don't care. Doing this to have a full develop, build, and deploy pipeline running. If I'm actually teaching myself how to do this I should have a target. I'm a console gamer. Yeah, it's not my preferred console, but it's what I can do today without spending more money.

I had this working before, on my old laptop prior to migrating to the new desktop. I had built an APK and had it running on my OUYA. It was missing control support, but it built and ran. That was the first step then and the first step now. I basically used the following to cobble together what I needed and I'm not going to go in depth into the steps I took here.

* [Publishing to Ouya (2016)](http://unitycoder.com/blog/2016/01/21/publishing-to-ouya-from-unity-5-3/)
* [Unity Game Engine](https://devs.ouya.tv/developers/docs/unity)
* [Setup Instructions for the OUYA ODK](https://devs.ouya.tv/developers/docs/setup)

I'd already walked through this process before so there were only a few minor hiccups.

* forgot that Android SDK required Java SE Development Kit
* forgot that I needed Android 4.1.2 (API 16) SDK to build
* forgot that I needed to drop the OuyaGameObject prefab into my load scene
* forgot to update the Bundle Identifier

After that it built just fine. I copied over the APK with Explorer and used the FilePwn app to install the APK. Gloriously, this worked just fine. Still missing input control, but I'll get there.

As an aside, I walked through the OUYA dev agreement. Looks like they take a flat 30% of the list price of a game. It's less cut and dry for selling on other platforms, which they reserve the right to do whenever they want and without permission. They note that it's a bit uncomfortable, but leave it at that...
