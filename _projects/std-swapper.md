---
name: std-swapper
brief: Easily point stdin and stdout to files.
technologies: C
year: 2023
updated: 2023-01-23
started: 2023-01-23
commits: 7
github: https://github.com/klm127/std-swapper
layout: project
output: true
completed: complete
---

I wrote this small utility to assist with unit testing in C. I wanted to be able to test functions that depended on user input, such as those than call `scanf` or `getchar`. I also wanted to be able to test functions that produce output on stdout without cluttering my terminal during tests. I needed code that could simply swap out stdio and stdin with files and remove them afterwards. I wanted it also to be able to populate stdin with input I wanted to test.

There may be full-featured testing suites for C that offer this already, but I like using the lightweight [CuTest](https://cutest.sourceforge.net/) for small academic projects.

Despite its small size, it has proven quite handy and I've re-used it a number of times. 