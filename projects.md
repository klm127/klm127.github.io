---
layout: page
title: Projects
permalink: /projects
description: Projects
---
<style>

h2.comyear {
    text-align: center;
}

</style>
{% assign proj_array = site.projects | sort : "year" | reverse %}
{% assign proj_2023 = proj_array | where: "year", "2023" | sort : "updated" | reverse %}
{% assign proj_2022 = proj_array | where: "year", "2022" | sort : "updated" | reverse%}
{% assign proj_2021 = proj_array | where: "year", "2021" | sort : "updated" | reverse%}
{% assign proj_2020 = proj_array | where: "year", "2020" | sort : "updated" | reverse%}

<h2 class="comyear">2023</h2>
{% for project in proj_2023 %}

{% include projectcard.html data=project %}

{% endfor %}
{% for project in proj_2022 %}

{% include projectcard.html data=project %}

{% endfor %}
<h2 class="comyear">2021</h2>
{% for project in proj_2021 %}

{% include projectcard.html data=project %}

{% endfor %}
<h2 class="comyear">2020</h2>
{% for project in proj_2020 %}

{% include projectcard.html data=project %}

{% endfor %}
