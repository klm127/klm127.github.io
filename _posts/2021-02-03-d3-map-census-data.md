---
layout: post
title:  "Experiments in Data Visualization - Choropleth"
date:   2021-02-03 18:00:00 -0500
categories: javascript data chloropleths visualization census
tags: javascript data choropleth visualization census
permalink: "USCensus-Marital-Visualized"
todo: "Replace links to github with links to documentation for keymodeler/map"
external-js-dependencies:
    - "https://d3js.org/d3.v4.min.js"
local-js-dependencies:
    - "visualizations/KeyModeler.js"
    - "visualizations/USCensusMap-v1.js"
    - "visualizations/data/census/2020-02-03-State-Marital.js"
    - "visualizations/data/geo/US-Features-States.js"
custom-css-list:
    - "USCensusMap/style-gray.css"

---

# The Visualization

<h4 style='text-align:center;'><em>US Census Marital Data, by State</em></h4>

<div id="KeyModeler-Selects">
</div>
<div id="us-map"></div>
<script>
    const keymodeler = new KeyModeler(CENSUS_DATA["Alabama"],'KeyModeler-Selects');
    const map = new USCensusMap(keymodeler,US_FEATURES,CENSUS_DATA,"us-map","mousemove touchstart","mouseleave touchend",d3.interpolatePlasma,true,false);
</script>
<br />

# Intro

In the week antecedent to the commencement of Spring semester, I was improving my javascript by chugging through another FreeCodeCamp certification, [Data Visualization](https://www.freecodecamp.org/learn){:target="_blank"}. The course explores [d3](https://d3js.org/){:target="_blank"}, the flexible, powerful, and ubiquitous javascript library that is at the center of most in-browser data visualizations. When I reached Project 4, [Visualize Data with a Choropleth Map](https://www.freecodecamp.org/learn/data-visualization/data-visualization-projects/visualize-data-with-a-choropleth-map){:target="_blank"}, I decided I had to put the cert on hold and dive deep into d3 and choropleths. I've always loved the texture and color of a good map, especially one that provides real information. So I embarked on what turned out to be two projects - a [data cleaner](https://www.quaffingcode.com/census-csv-parser/doc/index.html){:target="_blank"} for Node.js and [a pair of visualizer and selector classes](https://github.com/klm127/us-census-chloropleth-viewer-data-selector){:target="_blank"}, demonstrated at the head of this page.

# Table of Contents
 - [The Visualization](#the-visualization)
 - [Intro](#intro)
 - [Getting the Data](#getting-the-data)
 - [Cleaning the Data - building census-csv-parser](#cleaning-the-data-building-census-csv-parser)
 - [Building KeyModeler.js](#building-keymodelerjs)
 - [Building USCensusMap.js](#building-uscensusmapjs)
 - [What I Learned](#what-i-learned)
 - [Insights From the Visualization](#insights-from-the-visualization)
 - [What's Next](#whats-next)

# Getting the Data

Census Data is available for free at [census.gov](www.census.gov){:target="_blank"}. For the map, I found [this blog post](https://eric.clst.org/tech/usgeojson/){:target="_blank"} by Eric Tech offering U.S. "feature" data in GeoJson format.

GeoJson is a standardized format. The wrapper object consists of sub-objects representing "features", which may be states, counties, countries, or some other geographic enclosure. Each of those features has a name property and a series of numbers representing instructions for how to draw the borders of that feature using arcs which can be processed by a library like d3. These paths are relative to the Earth overall, using the actual latitudinal/longitutudinal coordinates of Earth's Geographic coordinate system. So if you mapped a GeoJson of Canada and a GeoJson of the United States, even if you aquired them from disparate sources, they would appear correctly right next to each other on your final projection. Unless you used some bizarre projection. But [they're pretty straightforward](https://www.sohamkamani.com/blog/javascript/2019-02-18-d3-geo-projections-explained/){:target="_blank"}.

Census data, on the other hand, not so much.
# Cleaning the Data, Building census-csv-parser

Census data is ugly. [Really ugly](https://github.com/klm127/census-csv-parser/blob/master/test_data/maritaldataLarge.csv){:target="_blank"}. Downloaded raw, this chunk of marital data has 57 rows and **364** columns. And column headers have names like
>Estimate!!Never married!!LABOR FORCE PARTICIPATION!!Males 16 years and over

Oof. 
It makes sense though. That header represents a roadmap of where the data belongs when compared to the states in the first column.
 - Alabama
    - Estimate
        - Never Married
            - Labor Force Participation
                - Males 15 years and older

There are definitely good tools out there for cleaning data, but this was a learning project. I decided to create all the tools I would use to clean the data myself, document my code, extensively unit test it, publish it to NPM, and [publish the documentation](https://www.quaffingcode.com/census-csv-parser/doc/index.html){:target="_blank"}. 

I created two namespaces for `census-csv-parser`. The first, named `util`, provides functions for parsing the data. It turns a .csv string into a 2D array. It chops of rows and columns based on [regexes](https://regex101.com/){:target="_blank"} or other parameters. It clears or replaces unwanted characters. It converts string data to number data when possible. It transposes the array. Finally, it splits selected elements into arrays and ultimately uses those arrays to generate a .json style object.

The second namespace is a class, `Parser`, which wraps some of those utility functions. You set desired metadata with Parser, tell it which row or column contains the array data to be nested, and it will generate for you a javascript object with properties nested like so: 

{% highlight javascript %}

{
    "Alabama": {
        "Total": {//...
        }
        //other props...
        "Never Married":
            "Labor Force Participation":
                "Males 15 years and older":32.8,
                "Females 15 years and older":27.3
        //other props...
    }
    "Arkansas": {
        //...
    }
    //...
}

{% endhighlight %}

Now _that_, I can work with! Now we have an object that can be saved as a javascript object, where the keys are the names of states and the keys of the states are the names of various metrics and so forth. Only the metrics I want though; for example, I removed all the "Margin of Error" columns. Each state has an identical structure and can be referenced in an identical way. Now I just had to decide _what_ data I wanted to render. 

I decided, **all of it!**

# Building KeyModeler.js

What's better than one data-colorized chloropleth? A chloropleth that can visualize a wide range of data on the same map! 

I needed an object that would generate DOM Elements a user could interact it with which would describe what data metric was sought. For that purpose, I built [KeyModeler](https://github.com/klm127/us-census-chloropleth-viewer-data-selector/blob/master/KeyModeler.js){:target="_blank"} to enable user interaction with data selection. KeyModeler is given a model object on construction. For example, "Alabama". KeyMapper traverses the keys of the model object and generates an [HTMLSelect Element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select){:target="_blank"} for each key, with the options being the next keys/paths. When it hits a final value, it stops. When an earlier select box is changed, it deletes the subsequent boxes and generates appropriate select boxes and options for that traversal path. It contains and updates an array representing the currently selected values. If it is passed an object with the same structure as its' model object, it traverses the keys of that object, based on the keys that have been selected by the user, until it finds the value at those coordinates.

Here's that method for retrieving the selected value from an object of the same schema as KeyModeler's model object. Simple, but I enjoyed writing it.
{% highlight javascript %}
getPropVal(parallelObject) {
    this.selectedValues.forEach( (val) => {
        if(parallelObject.hasOwnProperty(val)) {
            parallelObject = parallelObject[val];
        }
    })
    if(!(parallelObject instanceof Object)) {
            return parallelObject;
    }
    else {
            return 0;
    }
}
{% endhighlight %}

KeyModeler is totally flexible.
- Zero dependencies
- Takes any object as a model
- No built in styling of any kind but sets the class names for CSS hooks.

I intend to reuse this class for future data visualizations, unless I find something that already does this better in [observable](https://github.com/observablehq){:target="_blank"}.

# Building USCensusMap.js

FreeCodeCamp's [Chloropleth Project](https://www.freecodecamp.org/learn/data-visualization/data-visualization-projects/visualize-data-with-a-choropleth-map){:target="_blank"} has you use a provided TopoJson file, which requires an external dependency. I wanted to use the raw GeoJson files, because that is how map data is publicly available. Plus, d3 has a ton of [useful functions](https://github.com/d3/d3/blob/master/API.md#projections){:target="_blank"} for working with GeoJson files, like projections. I used the most obvious and familiar projection, [d3.geoAlbersUSA](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#geoAlbersUsa){:target="_blank"} for this.

There's a lot I could say about USCensusMap, but rather than wax poetical, I'm just going to provide a list of facts:
- Takes GeoJson data to be mapped and Census data to be rendered in color.
- Uses [d3 sequential multi-hue interpolators](https://github.com/d3/d3/blob/master/API.md#user-content-sequential-multi-hue), though I might be changing that in the near future; a simpler two color range mapping may be easier for the viewer to instantly understand.
- Takes an instance of KeyMapper.js as a parameter, and uses it to figure out what property it should map.
- Has two separate render functions for performance - one for rendering the map, one for rendering the data.
    - The map rendering only happens once, unless it's set to auto-resize mode. Then it happens whenever the window size changes.
    - The data mapping happens whenever the user-selected property in KeyMapper.js changes. USCensusMap.js attaches a listener to KeyMapper.
- Re-scales the color scheme each time a data render happens, and displays the extrema of the data.
- Uses no styling but can be styled with CSS Hooks.

The biggest frustration building the map portion happened near the end. I had everything working almost perfectly, but when displaying total population, most states were showing nearly black. It wasn't until I checked through all the [projections](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#geoAlbers){:target="_blank"}, [color interpolator](https://github.com/d3/d3/blob/master/API.md#user-content-sequential-multi-hue){:target="_blank"}, [scales](https://github.com/d3/d3-scale/blob/v3.2.2/README.md#scaleSequential){:target="_blank"}, [path rendering](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#paths){:target="_blank"}, and [joins](https://github.com/d3/d3-selection/blob/v2.0.0/README.md#selection_enter){:target="_blank"} - and broke the code a few times - that I realized `USCensusMap.js` was working perfectly... but _I was including the U.S. totals in the dataset_. That wasn't obvious for percentage-style metrics, but was glaringly apparent for totals. 

Basically, the maximums for my [domains](https://github.com/d3/d3-scale/blob/v3.2.2/README.md#continuous_domain){:target="_blank"}, used by my [scales](https://github.com/d3/d3-scale/tree/v3.2.2){:target="_blank"} were being set to the sum total of the entire country, making every single state appear to be near the minimum value by comparison.

I'm a little embarrassed at how long it took me to figure out what was going on. I was halfway through writing the div that shows the minimum and maximum points of data when I finally figured it out.

You can find the code [here](https://github.com/klm127/us-census-chloropleth-viewer-data-selector/blob/master/USCensusMap.js){:target="_blank"}. I intend to generate jsdoc from the code when it has been improved somewhat.

# What I Learned

- [jsdoc](https://jsdoc.app/){:target="_blank"}

Very much like Javadoc. I'm glad there are general conventions for all documentation markup. Quickly generate html pages from your code, like [I did for census-csv-parser.](https://www.quaffingcode.com/census-csv-parser/doc/index.html){:target="_blank"} There's a number of templates out there. I wound up using [minami](https://github.com/Nijikokun/minami){:target="_blank"}. 

- [npm](https://www.npmjs.com/){:target="_blank"}

If you read this far, you probably already know what npm is. `census-csv-parser` was the first npm module I've [published](https://www.npmjs.com/package/census-csv-parser){:target="_blank"}. Somehow it already has over 80 downloads, which means I need to get going on version 2 ASAP.

- [d3](https://github.com/d3/d3/blob/master/API.md){:target="_blank"}

I definitely improved my familiarity with d3 more than I would have just doing the FCC certifications. It's an incredible library, though sometimes the documentation can be tricky to parse. Fortunately, a lot has been written about d3. A couple of good posts helped me, like [this one](https://www.d3indepth.com/geographic/){:target="_blank"} from d3indepeth and 
[this one](https://bl.ocks.org/mbostock/5562380){:target="_blank"} from Mike Bostock, the creator of d3. 

- [mapshaper](https://mapshaper.org/){:target="_blank"}

I haven't fully _learned_ mapshaper yet, but I did use it to reduce the file size of my GeoJson. It's a required stop for any serious choroplether. It has a powerful command line interface which I only brushed the surface of. At the very least, it will considerably shrink the size of your complex GeoJson file by calculating more efficient arcs. You can set the compression level with a slider at the top of the browser after drag-dropping your GeoJson right into the window.

- unit tests are a godsend

I wrote unit tests as I wrote `census-csv-parser`. I had never written unit tests before, mostly because it was intimidating and I was getting away with logging stuff on the console. This was a more complex library, and I was determined to get over my fear of testing. In many cases, I wrote the tests before I wrote the function. This was critical to getting the project done in a reasonable time frame. I found many problems that I would not have discovered otherwise. On several occasions, my thorough unit tests caught be breaking earlier code when implementing new functionalities. 

# Insights from the Visualization

While the purpose of this project was to practice coding, no data visualization is complete without at least _some_ observations about the data.

- The most married state is Utah, at 56%.
- The least married area is Washington D.C., at 33%.
- Washington D.C.s low marriage rates are not accounted for by a younger profesisonal population, as I initially speculated. Puerto Rico actually has the lowest marriage rate until age 34, when D.C. takes the lead. This trend is true for both males and females.
- The most widowed state is New Mexico, by a long shot, recording a rate of 0.8%. This is driven by a high rate of female widows - 0.5%. It's not entirely an elderly population that accounts for this either; widows from age 20-34 account for a whopping 4.3% of New Mexican widows.
- The most divorced state is Arkansas, at 5.1%, while the least divorced region is D.C., probably because nobody gets married there in the first place.
- The most divorced state for whites is Montana, at 12.1%, while the least divorced for whites is its neighbor North Dakota, at only 1.3%. American Indians also have a right rate of divorce in Montana, at 19.1%. The most married state for whites is Hawaii, at 50.5%.
- For blacks, the most divorced state is Illinois, at 16.7%. The most married state is Alabama, at 49%, followed closely by Louisiana, at 48.5%. 
- The most separated state is Oklahoma at 3.6%. Most of the south and lower midwest has higher relatively higher separation rates and relatively lower divorce rates, possibly indicating an aversion to divorce. New York, however, has a separation rate nearly twice its (low) divorce rate.
- The most never married region was the District of Columbia, at a whopping 39.3%. Nothing comes close. Mirroring the marriage rates, the least never-married state was Utah, at only 9.9%. The lowest never-married states for whites was Mississippi, at 28.9% while for blacks it was North Dakota, at 33.3%. Surprisingly, North Dakota is adjacent to one of the most least-married states for blacks - Minnesota, at nearly 60%.

# What's Next

- Improve styling of USCensusMap.js for mobile and tweaking the projection to show P.R. and D.C.
- Cleaning up and publishing documentation for `KeyMapper.js` and `USCensusMap.js`
- Publishing more data visualizations of interesting census data using these projects as boilerplate.
- More functionality for `census-csv-parser` - more utility functions and more Parser functions. Especially more statistical-oriented ones. For instance, it should be able to generate variance and standard deviation columns. Also, it needs a **Command Line Interface** and **Method Chaining**.
- Visualizations of county level data. County level data is more granular and thus more interesting.
- Complete Free Code Camp's Data Visualization Certification

Thanks for reading!

