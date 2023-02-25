---
name: outerdocs
brief: Link external documentation in jsdoc.
technologies: js jsdoc
year: 2021
updated: 2022-03-06
started: 2021-11-22
commits: 17
github: https://github.com/klm127/outerdocs
layout: project
category: personal
output: true
completed: complete
---

I used sphinx to create some documentation from python code after using jsdoc on javascript stuff for a while. Sphinx had a feature I really liked that was missing from jsdoc; it allowed you to link external documentation through [sphinx.intersphinx](https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html). I saw that jsdoc would be improved if it had the same functionality, so I created a plugin for jsdoc to add the feature. The plugin utilizes the `@outerdocs` tag and a small bit of configuration to allow easy linking to specific members of externally documented modules. I felt it worked well and I opened a PR to add it to jsdoc. Unfortunately, the [Pull Request](https://github.com/jsdoc/jsdoc/pull/1956) never got merged, nor was feedback from the maintainer forthcoming. If any readers would like to comment on that PR and encourage the maintainer to merge it, be my guest! 