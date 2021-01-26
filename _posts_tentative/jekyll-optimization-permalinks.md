
[how to use permalinks in jekyll](https://www.digitalocean.com/community/tutorials/how-to-control-urls-and-links-in-jekyll)

{% post_url 2021-01-24-Free-Code-Camp-React-Snippets %}

[blogging like a hacker](https://kylebebak.github.io/post/tags-categories-jekyll)


[getting various variables](https://jekyllrb.com/docs/variables/)

[Jekyll Tags](https://www.assertnotmagic.com/2017/04/25/jekyll-tags-the-easy-way/) the "easy" way. Involves creating a new page for each tag, but I want my page to be auto-generated. That's too much work!


{%}
    {% for category in site.categories %}
    <li>{{ category[0] }}</li>
    {% endfor %}
{%}


