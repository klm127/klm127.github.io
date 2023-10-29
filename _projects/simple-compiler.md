---
name: Tompiler
brief: A simple compiler, featuring a scanner, parser, type checker, and code generator.
technologies: c
year: 2023
updated: 2023-04-18
started: 2023-01-18
commits: 135
github: https://github.com/thomasterhune/Compiler
layout: school
output: true
completed: complete
---

Tompiler was a group project for Language Translations. We had a 3 member group and the project was cumulative; the four assignments required that you built on the code you had started already.

We were able to identify some problems with the Context Free Grammer that had gone unnoticed for many years, causing the professor to change the language slightly for future classes.

This was quite enjoyable and we had a team committed to mastering the material. We went far beyond what was required, even generating [documentation](https://github.com/thomasterhune/Compiler/blob/main/docs/Reference%20Manual.pdf) with Doxygen for our code base.

One fun thing I added was handling all the Token scanner logic with a [wild DFA array](https://github.com/thomasterhune/Compiler/blob/f65656aa7ab2fa77e65b9ba83dfd90e971f57460/src/dfa.c#L340) that I generated [with Excel](https://github.com/thomasterhune/Compiler/raw/main/docs/fullDFA.xlsx). This doesn't make for the most readable code, but it used no branching in the driver.

