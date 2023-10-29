---
name: betacus.com
brief: A website for visualizing horse racing results and simulating bets.
technologies: php react mysql go vite chakra
year: 2023
updated: 2023-08-16
started: 2023-05-16
commits: 189
link: https://betacus.com
layout: project
output: true
completed: complete
note: 38 other commits
---

The owner of the company I interned at had a passion side project called Betacus. He had been collecting data on horse racing results for many years. He had a website and a few subscribers for his predictions. The website was broken, and he asked me to take a look.

The code base was very messed up. Among other things, all the front-end business logic was performed in one giant React class component's render function in about 10,000 lines. He had outsourced the development to India, and the code was just not maintainable. I proposed that I remake it from scratch and presented him with a design document, which he approved.

I found PHP quite fun to work with - I don't know why it gets so much hate! The front end, especially the bet simulation system, was very intricate. Horse betting is complicated and has many edge cases. I used Chakra UI to get a nice looking UI with minimal effort.

I solved a lot of my bet-state management problems by coming up with a pattern I called "CPR" - Context, Provider, Reducer. 

I also built Kurt a scraper in Go to reduce his data entry time. As of this writing, Kurt isn't requiring subscription to access Betacus, so [check it out](betacus.com) while it's free. 