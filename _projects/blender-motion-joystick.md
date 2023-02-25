---
name: blender-motion-joystick
brief: Rotate and move objects in Blender using a two-button joystick with an internal accelerometer.
technologies: python i2c
year: 2021
updated: 2021-05-13
started: 2021-01-03
commits: 18
github: https://github.com/klm127/blender-motion-joystick
link: https://www.quaffingcode.com/blender-motion-joystick/
layout: project
output: true
completed: complete
---

This was my final project for Systems Fundamentals at University of New Hampshire, Manchester. It consists of a vintage flight joystick handle I found on eBay, an accelerometer hot-glued to the inside, 6 wires soldered to an ethernet cable, and a Raspberry Pi and breadboard.

By pitching, yawing, and rolling the joystick, one can pitch, yaw, and roll a selected 3D object in Blender 2.7.9 running on a Raspberry Pi.

Originally, I planned for the project to include two more 3d-printed housings, to be strapped on the wrist and elbow area, which would capture complex arm motion for animation or game purposes, but I scaled the project down as deadlines approached.

I’m proud of the project, as I gained proficiency in areas I was new in, namely, low-level communications (like i2C), reading spec sheets, soldering, writing addons for Blender, matrices, and 3D generally.