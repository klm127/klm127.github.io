---
layout: page
permalink: tag-page.html
description: page for individual tags
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