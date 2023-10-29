---
name: C-Server
brief: A TCP server written in C.
technologies: c
year: 2023
updated: 2023-10-21
started: 2023-09-29
commits: 28
github: https://github.com/Chremmer/ecet4640-lab5
layout: school
output: true
output: true
completed: complete
---

This was a project for my computer networking class. We were the 'server' team and client teams were tasked with connecting to the server we wrote. It was interesting learning the lower-level C server protocols specified in [<sys/socket.h>](https://www.man7.org/linux/man-pages/man2/socket.2.html) and I am curious about exploring other protocols sockets can be used for besides IPv4 internet. For example, there's amateur radio, CAN bus, and bluetooth.  

I'd already wrangled with `pthread.h` in an Operating System's class and I was able to realize the multithreading needed pretty quickly, so this didn't wind up being a very difficult project.
