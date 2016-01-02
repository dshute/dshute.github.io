---
layout: post
title:  "MonoGame Install Notes"
date:   2016-01-01 22:17:00
categories: gamedev  
---

*A Startling Lack of Focus*

I've been off work for the last two weeks. I had many, many plans of what I was going to do with the time. I have, after all, been backlogging a number of projects knowing that I was going to have time off. This Monday puts me back at work and I've achieved exactly zero progress on any project.

Given the length of my backlog that clearly means it is time to add something to the pile. Why not playing around with game development? Something I've never done and requires skills I don't have. Hurray!

*Stumbling Necessary Steps*

So, I already had Visual Studio Community 2013 installed. I downloaded and installed MonoGame. If I had any foresight I would have just used NuGet. It'd be great and all if I'd thought of that beforehand, but I'm not about to go back and uninstall it for now.

I created an OUYA project as the first thing. It blew up wonderfully from the get go. Threw an error on creation. I'm sure there's stuff here to follow up on, but OUYA isn't anywhere near my list of priorities. I'm sure it's just a dependency thing.

Created a default Windows application. This was a bit smoother. It created and built appropriately, followed by an error.

> An unhandled exception of type 'System.DllNotFoundException' occurred in SharpDX.XInput.dll
>
> Additional information: Unable to load DLL 'xinput1_3.dll': The specified module could not be found. (Exception from HRESULT: 0x8007007E)

It looked like I was missing the DirectX runtime, which didn't make sense as dxdiag was showing DX11, as I expected. Turns out, requires an old version of DirectX. Amazeballs. Installed DX 9.0c and things seems to be working fine.

The long, uphill battle to figure out what I'm doing and then abandon it before I get any real usage or value out of it awaits.
