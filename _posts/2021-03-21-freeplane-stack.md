---
layout: post
title:  "FreePlane, the Cornerstone of My Learning Stack"
date:   2021-03-21 18:00:00 -0500
categories: learning freeplane
tags: learning freeplane
permalink: "Freeplane-Mindmap-Tutorial"
todo: "Write This"
---

When I found Freemind, a piece of Open Source Software developed by Christian Foltin, it was a game changer. My researching and notetaking capabilities went through the roof as I simultaneously discovered mind-mapping and one of the most powerful tools ever created for that purpose. Before that, I'd clumsily take notes in word documents, or just force memorize with flash cards. Now, Mind-maps are the number 1 tool I can credit with my efficient learning.

I have since switched to [FreePlane](https://www.freeplane.org/wiki/index.php/Home), a fork of [FreeMind](https://sourceforge.net/projects/freemind/), which is very similar but performs a little better, with a few more features, and is still being regularly updated.

# Why Mindmapping is Great

Digital Mindmaps compact vast quantities of learned material into a tree data structure. They are human-traversible and expansile. 

Moreover, because mindmaps organize information in a spatial way, I believe they take advantage of a fundamental principle of memory, first described by the Romans. 

![A picture of a statue of cicero]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/cicero.jpg "A picture of a statue of cicero")

The Method of Loci, also called a [Memory Palace](https://learnerfix.com/memory-palace-technique/), was explicated in _[Rhetorica ad Herennium](https://en.wikipedia.org/wiki/Rhetorica_ad_Herennium)_, circa 80 B.C. This ancient book treated rhetoric, oration, and memoria, the memorization of speeches, and also happened to give us the five part essay.

Roman orators gave [lengthy speeches](http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.02.0021%3Aspeech%3D1%3Asection%3D1) entirely from memory. They did this by creating a palace in their mind's eye. As they memorized, they mentally strolled through this palace, attaching subjects of their speech to mental objects placed about. A bust of their favorite emperor reminded them of an anecdote portion of their speech. In the subsequent room, a charioted javalineer was constructed to represent the invasion of Britannia, the next subject of their speech. When they later delivered the speech, they mentally walked through these same rooms and remembered those same subjects. 

A fundamental principle of mneumonics, known by all memory masters, is that harnessing the senses form better memory links. [Incorporating images](https://artofmemory.com/wiki/Mnemonic_Association_System_for_Numbers), music, and tactile sensation sticks an idea better. But there is an extra sense that is often overlooked. The sense of direction.

We can catch balls behind our backs or kick-stop our dropped phones before they shatter, and a blind man can clean his apartment. Our spatial awareness is one of our most powerful senses. Perhaps the most important one.

The method of loci takes full advantage of the spatial sense; pratitioners place memory anchors within a well known location they construct in their mind. To retrieve the memories, they mentally navigate this imagined space.

Mindmapping also taps into spatial awareness. Though they can be quickly expanded, Nodes have distinct positions on the tree, and can be reached by traversing a particular path. There is a dimensional sense to the information, even if every node contains infinite space. I suggest that the act of creating a mindmap alone secures ideas better in memory than linear notes, even before those notes must be referenced.

All together, mindmaps solve a big question most students must have. How do we mentally organize large amounts of knowledge? How do we not forget that whole branches of our trees even exist?

# Why Freeplane is Great

The speed at which a digital mindmap can be created as learning material is processed is equal to or greater than the speed at which one can take notes linearly, such as in Microsoft Word.

The principal advantage appears when you wish to reference back to what you have written before. The way a mindmap tree is structured makes it possible to nest concepts rapidly while still allowing you to make them as extremely quality and detailed as you need.

![A screenshot of a Freeplane mindmap with many nested nodes representing Java classes]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/read-write-display-triangles-nesting-depth.png "A screenshot of a Freeplane mindmap with many nested nodes representing Java classes")

Nodes can have links to your filesystem or external sites. They could have a list of subtopics from notes about that site. They could have code samples. And you can tell instantly by the formatting what each one is.

![A screenshot of a Freeplane node about SQL joins]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/sql-joins-section-6.png "A screenshot of a Freeplane node about SQL joins")


Mindmaps are very visual. They are very spatial. 

They are straightforward and organized when referencing difficult problems, and Freeplane support Latex math notation.

![A screenshot of a Freeplane node about the Fundamental Theorem of Calculus]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/calculus-fundamental-theorem.png "A screenshot of a Freeplane node about the Fundamental Theorem of Calculus")

![A screenshot of a Freeplane mindmap of notes about Friction forces]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/physics-friction-node.png "A screenshot of a Freeplane mindmap of notes about Friction forces")

The nested nature means as much involvement as you want.

![A screenshot of a Freeplane mindmap of notes about Jekyll and Ruby]({{site.baseurl}}/assets/images/2021-03-19-FreeplaneScreenshots/jekyll-ruby-notes.png "A screenshot of a Freeplane mindmap of notes about Jekyll and Ruby")

With a digital mind map, huge swaths of the tree can be chopped and regrafted as needed. Muddy root stones can morph into cherry blossoms. Custom portals (`Alt+Shift+L`) can be inserted to move you from one end of the tree to the other. Touch another portal, and you'll vanish to another realm altogether. Brilliant red squirrels and thrushes can abound or not abound. It's a rapidly evolving arboreal freak, a cyber-genecists dream. Or it's a carefully pruned Bonzai, presenting information as beauty from every angle.

Physical mindmaps have their place, and there is value in also creating pencil-and-paper, real-world mindmaps. Besides mixing the pleasure of art with the pleasure of knowledge acquisition and self improvement, you are _physically_ traversing paper in a way that involves other parts of your body in memory formation. Solving the problems of placement on a limited area also forces the mapper into greater contemplation of each node, etching ideas more deeply into memory.

But the velocity at which digital mind maps can be generated and referenced put them in a class of their own as a learning and reference device. As with any powerful tool, there is a slight learning curve, but it pays _massive_ dividends.

# 6 Steps to Maximize Freeplane

I've been using Freeplane for about a year. I used Freemind for about a year before that, which Freeplane was forked from. I've figured out enough as an intermediate that I can flatten your learning curve somewhat. I'm going to do that by listing some steps and some hotkeys that I hope will make you a more efficient user right out of the gate.

Additionally, here's a [handy reference](https://freeplane.sourceforge.io/doc/FP_Key_Mappings_Quick_Guide.pdf) of Freeplane shortcuts.

I'll assume you've downloaded Freeplane for free at [freeplane.org](https://www.freeplane.org/wiki/index.php/Main_Page) and have a new mindmap open.

1. **Preferences**  :     These changes will make it easier to navigate Freeplane with both keys and clicks.
 - `Ctrl+Coma` will bring up the Preferences menu.
 - Under `behavior`, uncheck "fold on click inside"
 - Under `behavior > selection method` select `center selected node automatically`
 - Under `appearance`, check `Display selected nodes in bubbles`

2. **Dark Theme background** : Easy on your eyes
 - Right click the background of your mind map
 - Click `select background color`
 - Set it to something decently dark so you don't strain your eyes. 

3. **Navigate**: Don't click to get around. Use your arrow keys. Most work how you would expect. 
 - `Insert` and `Delete` insert and delete nodes.
 - `Ctrl+Arrow Key` moves the currently selected nodes to a different branch.
 - `Spacebar` folds and unfolds nodes.
 - `Alt+Page Up` and `Alt+Page Down` fold and open the lowest level open nodes.
 - `Ctrl+F11` Brings up the style menu.
 - `Ctrl+H` sets a hotkey

4. **Set up your styles.**
 - `Alt+Shift+B` changes background color of a node
 - `Alt+Shift+F` changes font color of a node
 - `Control+Shift+Plus` makes node font larger, `Control+Shift+Minus` makes it smaller
 - press `Alt+Shift+C` to copy the style of the topic node
 - press `Ctrl+F11` to bring up the Styles menu
 - select the style node there and press `Alt+Shift+V` to paste the style onto it

5. **Hotkey** your styles.
 - Press `Ctrl+H` to start a hotkey assignment
 - On the top menu, Click `Format>Apply Style>Topic` to select the menu command the hotkey will be assigned to
 - The hotkey menu will pop up. Press `F5`.
 - Now whenever you press `F5`, it will be styled just like the topic node in the Styles menu. If you change the Styles menu node, every topic node in your map will change. If you press ctrl+shift+o to copy/open the styles from another map, your topic nodes will change to that map's style of topic nodes.
 - Repeat for your subtopic node.

5. **Add links** to your mindmap.
 - `Ctrl+K` adds a hyperlink.
 - `Ctrl+Shift+K` creates a file system link. 

# Limitations of Freeplane

Freeplane has a few limitations. Some of these could well be improved in future iterations as the open source sofware develops.

1. **Exporting as HTML is all right**: Exporting as HTML gives you a webpage with drop down divs for each node. It's not completely awful, but it really doesn't capture the intricacy of a mind map. It would be great if Freeplane could export a map as an HTML page that emulates the entire map in all its tree-ness, but it just doesn't do that yet.
1. **Exporting as an Image doesn't exit**: As far as I can tell, you can't just export a map as a super high resolution png. You could take screenshots and chop them together, but that's not efficient.
1. **Searching isn't totally intuitive**: Unfortunately, there's no `Ctrl+F` to find. `Ctrl+F` will instead Filter to your currently selected node. (`Ctrl+T` clears the Filtering). You _can_ find nodes by applying a filter, but the filter menu is not very intuitive and needs improvement.

# Other Programs

There are some other programs out there that do what Freeplane does. I've found Freeplane so full-featured and powerful that I have no desire to switch to something that seemed more paired down. But I'll list them here:

- [Xmind](https://www.xmind.net/) is popular.
- [markmap](https://markmap.js.org/repl/) turns markdown into little mind maps, kind of fun.
- [mindmup](https://www.mindmup.com/) is in browser, not really free. 
- [mindmaster.io](https://www.mindmaster.io) is also in browser, also not free.

There are others, but so far, I've found every alternative less visually pleasing than Freeplane, missing important features, or distracting with less useful features. However, someone else might feel differently and if you like one of these programs, more power to you!  

# Conclusion

Freeplane has improved my learning experience dramatically, which is why I felt compelled to write this blog post. I hope some readers will decide to try this excellent software, and reap many rewards from it. Perhaps you will even contribute to its development.

If you're a student, try mind mapping!

# Further Reading

- [tree data structure](https://en.wikipedia.org/wiki/Tree_(data_structure))
- [memory palaces generally](https://learnerfix.com/memory-palace-technique/)
- [drawn mind maps](https://mindmapsunleashed.com/10-really-cool-mind-mapping-examples-you-will-learn-from)
- [memory wiki](https://artofmemory.com)
- [hashtags in freeplane script](https://sourceforge.net/p/freeplane/discussion/758437/thread/95dd1f3d41/) with full installation instructions
- [Freeplane hotkey Cheat Sheet](https://freeplane.sourceforge.io/doc/FP_Key_Mappings_Quick_Guide.pdf)

# Credits

Cicero Image by <a href="https://pixabay.com/users/dezalb-1045091/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2510287">DEZALB</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2510287">Pixabay</a>

- Other images my screenshots

- A screenshot cropped from a pearson textbook in one of my notes