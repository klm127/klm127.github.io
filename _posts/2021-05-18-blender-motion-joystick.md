---
layout: post
title:  "Blender Motion Joystick Project"
date:   2021-05-18 11:30:00 -0500
categories: projects blender 3d electronics
tags:  projects blender 3d electronics
permalink: "Blender-Joystick"
todo: "Write This"
---

I recently completed a project for school that involved a mixture of programming and electronics.

The project is titled `blender-motion-joystick` and consists of a vintage flight joystick handle I found on eBay, an accelerometer hot-glued to the inside, 6 wires soldered to an ethernet cable, and a Raspberry Pi and breadboard.

By pitching, yawing, and rolling the joystick, one can pitch, yaw, and roll a selected 3D object in Blender 2.7.9 running on a Raspberry Pi.

Originally, I planned for the project to include two more 3d-printed housings, to be strapped on the wrist and elbow area, which would capture complex arm motion for animation or game purposes, but I scaled the project down as deadlines approached.

Interested readers can find the complete lab report, including a wiring diagram and description of the code, here: 

[Link to Documentation, Lab Report, Wiring Diagram]({{site.url}}/blender-motion-joystick).

I'm proud of the project, as I gained proficiency in areas I was new in, namely, low-level communications (like [i2C](https://en.wikipedia.org/wiki/I%C2%B2C)), reading spec sheets, soldering, writing addons for Blender, matrices, and 3D generally. I also think this is one of the first projects I've completed that could be turned in to something commercially viable.

![A picture of a artistic hand holding a vintage plastic flight joystick. An image of a sensor is in the background. In the lower right, there is an image of a computer with a mesh of an arm on it. The words 'blender-motion-joystick' and 'Karl Miller' appear on the lower left of the image.]({{site.baseurl}}/assets/images/blender-motion-image.png "A picture of a artistic hand holding a vintage plastic flight joystick. An image of a sensor is in the background. In the lower right, there is an image of a computer with a mesh of an arm on it. The words 'blender-motion-joystick' and 'Karl Miller' appear on the lower left of the image.")


