---
layout: post
title:  "FreePlane, the Cornerstone of My Learning Stack"
date:   2021-02-14 18:00:00 -0500
categories: learning freeplane
tags: learning freeplane
permalink: "Freeplane-Mindmap-Tutorial"
todo: "Write This"
---

When I found Freemind, a piece of Open Source Software developed by Christian Foltin, it was a game changer. My researching and notetaking capabilities went through the roof as I simultaneously discovered mind-mapping and one of the most powerful tools ever created for that purpose. Before that, I'd clumsily take notes in word documents, or just force memorize with flash cards. Now, Mind-maps are the number 1 tool I can credit with my high performance. 

I have since switched to [FreePlane](https://www.freeplane.org/wiki/index.php/Home), a fork of [FreeMind](https://sourceforge.net/projects/freemind/), which is very similar but performs a little better, with a few more features, and is still being regularly updated.

# Why Mindmapping is Great

Digital Mindmaps compact vast quantities of learned material into a tree data structure. They are human-traversible and expansile. 

Moreover, because mindmaps organize information in a spatial way, I believe they take advantage of a fundamental principle of memory, first described by the Romans. 

The Method of Loci, also called a [Memory Palace](https://learnerfix.com/memory-palace-technique/), was explicated in _[Rhetorica ad Herennium](https://en.wikipedia.org/wiki/Rhetorica_ad_Herennium)_, circa 80 B.C. This ancient book treated rhetoric, oration, and memoria, the memorization of speeches, and also happened to give us the five part essay.

Roman orators gave [lengthy speeches](http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0021%3Aspeech%3D1%3Asection%3D1) entirely from memory. They did this by creating a palace in their mind's eye. As they memorized, they mentally strolled through this palace, attaching subjects of their speech to mental objects placed about. A bust of their favorite emperor reminded them of an anecdote portion of their speech. In the subsequent room, a charioted javalineer was constructed to represent the invasion of Britannia, the next subject of their speech. When they later delivered the speech, they mentally walked through these same rooms and remembered those same subjects. 


- traversing it like the Method of Loci, like a Memory Palace
 - 
 - mnemomic device
 - first described in Rhetorica ad Herennium, authored in the 80s B.C.
 - ancient book of oration and rhetoric that first gave us the five-part-essay
 - This book treated memoria, the memorization of speeches
- compartmentalizes your own thoughts effectively

- a fundamental principle of mneumonics is that harnessing more senses form better memory links
- when making flashcards, such as with Anki, attaching sound to a card, or an image, makes already deadly efficient cards even more effective.
- an overlooked sense is sense of direction
- we can can catch balls behind our backs or kick stop our phone before it shatters after dropping it. 
- a blind man can clean his apartment

- but this sense of direction and geographic location should be counted higher than sight. It's a more important sense.
- it's our most used and perhaps most powerful sense.

- The method of loci takes full advantage of this; practitioners place memory anchors within a well known location they construct in their mind. To retrieve the memories, they mentally walk through this space.

- Mindmapping can capture some of this. The location is the directed graph of the mindmap, traversed not by a minmax function, but by a student.

- Mindmaps solve a serious question. How do we mentally organize large amounts of knowledge? How do we not forget that whole branches of our trees even exist? 

# Why Freeplane is Great

The speed at which a digital mindmap can be created as learning material is processed is equal to or greater than the speed at which one can take notes in Microsoft Word, a notebook, or some other notetaking data structure. 

The principal advantage appears when you wish to reference back to what you have written before. The way a mindmap tree is structured makes it possible to nest concepts rapidly while still allowing you to make them as extremely quality and detailed as you need.

![A screenshot of a Freeplane mindmap with many nested nodes representing Java classes]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/read-write-display-triangles-nesting-depth.png "A screenshot of a Freeplane mindmap with many nested nodes representing Java classes")

Nodes can have links to your filesystem or external sites. They could have a list of subtopics from notes about that site. They could have code samples from the site. And you can tell instantly by the formatting what each one is.

![A screenshot of a Freeplane node about SQL joins]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/sql-joins-section-6.png "A screenshot of a Freeplane node about SQL joins")


Mindmaps are very visual. They are very spatial. 

And they are incredible to reference for difficult problems.

![A screenshot of a Freeplane node about the Fundamental Theorem of Calculus]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/calculus-fundamental-theorem.png "A screenshot of a Freeplane node about the Fundamental Theorem of Calculus")

![A screenshot of a Freeplane mindmap of notes about Friction forces]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/physics-friction-node.png "A screenshot of a Freeplane mindmap of notes about Friction forces")

The nested nature means as much involvement as you want.

![A screenshot of a Freeplane mindmap of notes about Jekyll and Ruby]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/jekyll-ruby-notes.png "A screenshot of a Freeplane mindmap of notes about Jekyll and Ruby")



Other software involves more scrolling and scanning, or, at best, hashtags and searches.


 - Another exists in the nested nature. The depth of involvement in any topical reference is so minutely controlled.



- mindmaps have long existed, originally in paper and pencil format
- this doesn't mean there isn't still a ton of value in creating physical, real-world mindmaps. Besides mixing the pleasure of art with the pleasure of self-improvement, you are _physically_ traversing paper in a way that involves other parts of your body in the memory formation.
- Solving the problems of placement on a limited area forces the mapper into greater contemplation of each node, etching the idea more deeply in memory.

- But digital mind maps, do not have this problem. 


Huge swaths of the tree can be chopped and regrafted as needed. Muddy root stones can morph into cherry blossoms. Custom Portals can be inserted to move you from one end of the polytree to the other. Touch another portal, and you'll vanish to another realm altogether. Brilliant red squirrels and thrushes can abound or not abound. It's a rapidly evolving arboreal freak, a cyber-genecists dream.

All this and more is possible with Freeplane. As with any powerful tool, there is a slight learning curve, but it pays _massive_ dividends.

- it is extensible, and open source
- it has potential


# Setting a noob up for success

I've been using Freeplane for about a year. I used Freemind for about a year before that, which Freeplane was forked from. I've figured out enough as an intermediate that I can flatten your learning curve somewhat. I'm going to do that by listing X steps and some hotkeys that will make you an efficient user right out of the gate.

Additionally, here's a [handy reference](https://freeplane.sourceforge.io/doc/FP_Key_Mappings_Quick_Guide.pdf) of Freeplane shortcuts.

I'll assume you've downloaded Freeplane for free at [freeplane.org](https://www.freeplane.org/wiki/index.php/Main_Page)

1. Preferences
 - Ctrl+Coma will bring up the Preferences menu.
  - Under `behavior`, uncheck "fold on click inside"
  - Under `behavior > selection method` select "center selected node automatically"
  - Under appearance, check Display selected nodes in bubbles


2. Right click the background of your mind map, and click select background color. Set the background to something decently dark so you don't strain your eyes.

3. Don't click to get around. Use your arrow keys. Most work how you would expect. 
 - Insert and Delete insert and delete nodes.
 - Ctrl+Arrow Key moves the currently selected nodes to a different branch.
 - Spacebar folds and unfolds nodes.
 - Alt Page Up and Alt Page Down fold the lowest level open nodes.
 - Ctrl - F11 Brings up the style menu.
 - Ctrl - H sets a hotkey

4. Set up your styles and hotkey them.
 - Start by styling a topic and subtopic node the way you want. 
  - Alt Shift B changes background color
  - Alt Shift F changes font color
  - Control Shift Plus makes node font larger
 - press Alt+Shift+C to copy the style of the topic node
 - press Ctrl+F11 to bring up the Styles menu
 - select the Topic node there and press Alt+Shift+V to paste the style onto it
 - Exit the style menu
 - Press Ctrl+H to start a hotkey setup
 - Click Format+Apply Style+Topic
 - The hotkey menu will pop up. Press F5.
Now whenever you press F5, it will be styled just like the topic node in the Styles menu. If you change the Styles menu node, every topic node in your map will change. If you press ctrl+shift+o to copy/open the styles from another map, your topic nodes will change to that map's style of topic nodes.
 - Repeat for your subtopic node.

5. Add links to your mindmap.

Ctrl+K adds a hyperlink. Ctrl+Shift+K creates a file system link. Most of my hyperlinks are documentation, blog articles, and video tutorials, but they can be anything, and can have children nodes themselves for notes specific to that resource. When I make a mindmap for a new project, I create nodes that are filesystem links to the project's home directory, so my first stop when resuming work is to open the mind map.

# design principles and habits - intermediate

- use filters with attributes or hashtags to quickly filter nodes
- clean up your mind map
- change up the styles
- try scripting

6. Structure your mindmap folder.

Create a dedicated folder for your mindmaps in your Documents folder and back it up regularly, as it may become one of your most valuable digital assets. Use subfolders for different eras and topics of mind map. 

Use a "mother map" to map other mind maps. I have a master Computer Science mind map to links to programming language mind maps, math mind maps, mind maps created for digital tools, resume stuff, mind maps for coding projects, etc. 

Many of my mind maps also link to each other in a non-directed fashion. Doing this is made easier when maps are made in a more rigid directory structure, so links aren't accidentally broken.

7. 

# limitations


# other programs

- the js one, but costs money
- another js one, has the bones there, judging from the example, but not fully implemented
- freeplane is largely fully implemented but it keeps versioning with new releases. Small but dedicated community on sourceforge.
- freemind, haven't checked it since i transitioned. Still active on sourceforge but no releases since 2016. Seems as though everything done in FM can be done in FP.


# further reading

- [polytree](https://en.wikipedia.org/wiki/Polytree)
- [memory palaces generally](https://learnerfix.com/memory-palace-technique/)
- [drawn mind maps](https://mindmapsunleashed.com/10-really-cool-mind-mapping-examples-you-will-learn-from)

- [hashtags in freeplane](https://sourceforge.net/p/freeplane/discussion/758437/thread/95dd1f3d41/) with full isntallation instructions
- [Freeplane hotkey Cheat Sheet](https://freeplane.sourceforge.io/doc/FP_Key_Mappings_Quick_Guide.pdf)

# conclusion

- great example of OSS doing it better



# creds

Cicero Image by <a href="https://pixabay.com/users/dezalb-1045091/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2510287">DEZALB</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2510287">Pixabay</a>

Other images my screenshots

A screenshot cropped from a pearson textbook in one of my notes