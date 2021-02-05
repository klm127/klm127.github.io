---
layout: post
title:  "Quick Tags for Jekyll on Github"
date:   2021-01-25 21:00:00 -0500
categories: jekyll webdev javascript
tags: jekyll webdev javascript
permalink: "Quick-Jekyll-Tags"
---

# What's in this post

Quickly add tags functionality to a Jekyll site. Do it once and never have to mess with it again.

 - [Intro](#intro)
 - [Create the Tag Index Page](#create-the-tag-index-page)
 - [Create the Tag List Page](#create-the-tag-list-page)
 - [Put Tags on the bottom of Posts](#put-tags-on-the-bottom-of-posts)
 - [Include the Javascript](#include-javascript)
 - [The Javascript](#the-javascript)
 - [Conclusion](#conclusion)

## Intro

I wanted to implement "tags" functionality on this blog. Every post on this blog now has a "tags" value in the YML header in the markdown file. The header on this page, for example looks like this.

{% highlight yml %}
---
layout: post
title:  "Quick Tags for Jekyll on Github"
date:   2021-01-25 21:00:00 -0500
categories: jekyll webdev javascript
tags: jekyll webdev javascript
permalink: "Quick-Jekyll-Tags"
---
{% endhighlight %}

Those tags - `jekyll webdev javascript` correspond to topics the post covers. I wanted readers to be able to see the tags of a post on the bottom of the post as links. They should be able to click those tags to go to another page which lists links to all other posts that have the same tag. I didn't want to have to create a new page for each tag, because I wanted to be able to put whatever I felt like in my markdown. I wanted my tags to auto-generate. I wanted it to work on github, because that's where I host this page.

A lot of people have done this in different ways, but none of the tutorials I saw met my requirements.

[Jekyll Tags the 'easy' way](https://www.assertnotmagic.com/2017/04/25/jekyll-tags-the-easy-way/) by Assert_Not Magic?,
[Creating Category Pages in Jekyll Without Plugins](https://kylewbanks.com/blog/creating-category-pages-in-jekyll-without-plugins) on Kyle Banks' blog and [Jekyll Tags on Github Pages](http://longqian.me/2017/02/09/github-jekyll-tag/) by Long Qian all do _not_ meet my requirements **because they require you to create a new page for each new tag!** That's _way_ too much work.

Additionally [Tags In Jekyll](https://charliepark.org/tags-in-jekyll) by Charlie Park won't work because Github disables Jekyll plugins.

But there is a solution.

**JAVASCRIPT!**

## Create the Tag Index Page

Here's my tag index. It's the page you see when you click the "tags" link in the top right of this page.

#### ./tag_index.html

{%highlight liquid%}
{%raw%}
---
layout: page
title: tags
permalink: tags
---
<ul>
    {% assign sorted_tags = site.tags | sort %}
    {% for tag in sorted_tags %}
    <li><a href="/tag-page.html?tag={{tag[0]}}">{{ tag[0] }}</a></li>
    {% endfor %}
</ul>
{%endraw%}
{%endhighlight%}

The Liquid code sorts all tags in `site.tags`, then [iterates](https://shopify.github.io/liquid/tags/iteration/) through them. Site.tags is a list of every unique tag I have added to every post. For each tag that exists on my site, an HTML list item and link is created. 

But did you notice something interesting about the `href` attribute of the link? It has a query string at the end of the url.

`?tag={%raw%}{{tag[0]}}{%endraw%}`

But Jekyll can't do anything with query strings! Jekyll generates static sites. There's no way to communicate to Liquid or Jekyll what query strings are in the URL. And that is exactly why we will be using [Javascript](https://developer.mozilla.org/en-US/docs/Web/API/URL/search), which _can_ read what query strings are in the URL.

## Create the Tag List Page

Next, we need a page that will display a list of posts for the tag the user has selected.

#### ./tag_page.md

{%highlight liquid%}
{%raw%}
---
layout: page
permalink: tag-page.html
---
<div id="tag-container">
{% for site-tag in site.tags %}
<div id="-{{site-tag[0]}}"> 
<h3> <em>Tag</em>: {{site-tag[0]}} </h3>
    <ul id="ul-{{site-tag[0]}}">
    {% for post in site.posts %}
        {% for tag in post.tags %}
            {% if site-tag[0] == tag %}
            <li><a href="{{ post.url | relative_url }}">{{post.title}}</a></li>
            {% endif %}
        {% endfor %}
    {% endfor %}
    </ul>
</div>
{% endfor %}
</div>
{% include snippet-in-page.html content="delete-posts-not-in-query-string.js" %}
{%endraw%}
{%endhighlight%}

On `tag_page.md`, Liquid once again iterates through every tag on the site. For each tag, it creates a list, then iterates through every post on the site. For each post, it iterates through each tag on the post. If the post has a tag which matches the site tag, a list item and link is created.

The result is a page which has _every_ tag followed by a list to _every_ post which matches that tag. This result is not a good look raw, as it links to the same pages many times. Once, in fact, for every tag that page has. However, that's not the final product. It's only the result until the section at the bottom, `{%raw%}{% include snippet-in-page.html content="delete-posts-not-in-query-string.js" %}{%endraw%}` executes. You can probably guess by the text what that [include](https://jekyllrb.com/docs/includes/) does, but I'm going to explain it shortly.

Take note of two IDs we gave some elements. `tag-container` and `-{%raw%}{{site-tag[0]}}{%endraw%}`.


## Put Tags on the Bottom of Posts

Every post should end with a list of tags for that post. This is accomplished by changing the post layout. I just added the following towards the bottom of the layout.

#### _layouts/post.html

{%highlight Liquid%}
{%raw%}
  <div class="tag-links">
  {% assign sorted_tags = page.tags | sort %}
  |{% for tag in sorted_tags %}
    <a href="/tag-page.html?tag={{tag}}">{{tag}}</a> | 
  {% endfor %}
  </div>
{%endraw%}
{%endhighlight%}

This just iterates through the tags on a post and creates a link for each one, separated by the `|` symbol. You can see those links at the bottom of this page. When creating the links to `.tag_page.md` (in this case, we reference by its permalink `tag-page.html` - its the former in the source and the latter in production), we once again append a URL query string. `?tag={%raw%}{{tag}}{%endraw%}`. That's what our Javascript will be using.

## Include Javascript

I re-used an include I described in my [last post](/freeCodeCamp-Front-End-Snippets#adding-snippets) to insert the Javascript, but you could just add raw `<script>` tags at the bottom of `tag_page.md` containing the code I will momentarily provide.

#### ./_includes/snippet-in-page.html

{%highlight liquid %}
{%raw%}
<script type="text/javascript" src="{{site.baseurl}}/assets/js/snippets/{{ include.content }}"></script>
{%endraw%}
{%endhighlight%}

This include just points Jekyll to where I like to keep my short scripts, in assets/js/snippets, and creates the `<script>` element.

## The Javascript

#### ./assets/js/snippets/delete-posts-not-in-query-string.js

{%highlight javascript%}
{%raw%}
document.addEventListener('DOMContentLoaded', (event) => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    let container = document.getElementById("tag-container");
    for(let tag of container.children ) {
        if( tag.id != "-"+urlParams.get('tag')) {
            tag.innerHTML = '';
        }
    };
});
{%endraw%}
{%endhighlight%}

First, a `DOMContentLoaded` event listener is added which waits until the page is all loaded up to execute the rest of the code. Then it grabs the parameters in the URL, the **same parameters we passed in the links we made**. It finds all of the elements in our tag-container with ids that _don't_ match the parameter in the query string and clears them, leaving us with only one remaining list - the list of pages corresponding to the tag we specified, in our query string.

## Conclusion

I hope someone finds this post useful. With a little javascript, you can add fully functioning tags to your Github Jekyll page in less than an hour. Hope you enjoyed reading!



