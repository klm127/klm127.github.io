---
name: comment-anywhere
brief: Add comments to any webpage on the internet.
technologies: go typescript postgres docker sqlc vite
year: 2023
updated: 2023-02-24
started: 2022-09-01
commits: 150
link: https://comment-anything.github.io/
github: https://github.com/comment-anything/
layout: project
category: personal
output: true
completed: ongoing
---

This is my senior project. Over the last decade, many sites have closed their comments sections, causing comments to scatter among the disparate social media locations where those sites are shared. It has become harder to find comments - and the useful information therein - for a particular site or story. I believe there is a market need for comment sections permanently attached to webpages, which follow the content wherever it is shared, so I proposed this project, Comment Anywhere. 

The front end is a browser extension written in Typescript and packed with Vite. The back end is a web server written in Go connected to a Postgres database. I designed the project last semester and am implementing it this semester. I am working with two other students. I am implementing the back end portion and assisting them with the front end. 

The basic functionality is that a user can view comments through the browser extension drop down view. There they see comments associated with the webpage they are viewing. The association is based only on the url and can be added for any webpage on the internet, including those that would not normally have comment sections, such as government and business sites.


