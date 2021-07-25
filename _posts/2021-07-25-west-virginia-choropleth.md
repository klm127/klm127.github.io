---
layout: post
title:  "West Virginia Home Price Changes, February 2020 through May 2021"
date:   2021-07-24 11:30:00 -0500
categories: javascript data chloropleths visualization census
tags: javascript data choropleth visualization census zillow maps
permalink: "west-virginia-home-price-changes"
local-js-dependencies:
    - "libs/d3.js"
    - "visualizations/KeyModeler.js"
    - "visualizations/WVCensusMap-v1.js"
    - "visualizations/data/other/2021-05-15-Zillow-West-Virginia.js"
    - "visualizations/data/geo/West-Virginia-Features.js"
custom-css-list:
    - "USCensusMap/style-gray.css"
---

<h4 style='text-align:center;'><em>West Virginia Home Values and Changes, Spring 2020- Spring 2021, Zillow Data</em></h4>

<div id="KeyModeler-Selects">
</div>
<div id="us-map"></div>
<script>
    const keymodeler = new KeyModeler(wv_data_1["1"]["Data"],'KeyModeler-Selects');
    const map = new WVCensusMap(keymodeler,wv_features,wv_data_1,"us-map","mousemove touchstart","mouseleave touchend",d3.interpolateYlOrRd,true,false);
</script>
<br />

## What the data tells us

Some of the most expensive areas of the state, such as Jefferson County and Monongalia County, also saw the highest percentage increases in home values. Jefferson jumped by a whopping 25%. Across the state, most counties went up quite a bit in home value, but some counties, such as the large Randolph County, apparently lost value. Overall, the gap between the highest-priced counties and the rest of the state has widened. 

The pricier counties tend to congregate on the eastern side of the state, probably because housing demand includes Maryland commuters. Generally, the more west and south one travels, the cheaper the homes, with the exception of Putnam County, adjacent to Kanawha county, with an average home value more than 100% higher than its neighbors. Kanawha county is home to the state's capital, Charleston, and I speculate that Putnam is home to some more hoity toity suburbs for top government workers and/or higher quality schools.

There was a very large surge in home values in the central part of the state, with Calhoun, Gilmer, and Braxton Counties all rising over 10% in the year. This may be because these homes were already much more inexpensive on average, having more space to grow, and a rising appeal of rural living.

This visualization will be more useful when I other metrics, such as employment, industry, and education data, are incorporated. Look out for the next version.


## About

Data was acquired from [Zillow Research](https://www.zillow.com/research/data/). Choropleth generation was accomplished with [d3 7.0.0](https://d3js.org/). I re-used the tools I created for my last Choropleth, [KeyModeler]({% post_url 2021-02-03-d3-map-census-data %}#building-keymodelerjs) and a modified version of [USCensusMap]({% post_url 2021-02-03-d3-map-census-data %}#building-uscensusmapjs). There was actually quite a bit of tweaking to turn USCensusMap into WVMap. It would be a worthy project to abstract the choropleth out further in order to speed up the process of generating these maps. During the data cleaning portion of this project, I found a couple bugs with [census-csv-parser](https://www.quaffingcode.com/census-csv-parser/doc/index.html) and noticed that it needed new features. I incremented the sub-version a couple times and re-released it on Node Package Manager.

[census-csv-parser currently has 312 downloads.](https://npm-stat.com/charts.html?package=census-csv-parser&from=2021-01-01&to=2021-07-25) I don't know who is using the package or why. There are more comprehensive csv packages out there. I suspect one reason may be because it is lightweight, having no external dependencies, which are security risks, and the documentation isn't completely terrible. I also decided on the highly permissive MIT license. 