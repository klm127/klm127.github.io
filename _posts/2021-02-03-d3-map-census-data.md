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

I had a week before Spring classes started and was chugging through [FreeCodeCamp's](https://www.freecodecamp.org/learn) Data Visualization certification. FCC teaches the basics of [d3](https://d3js.org/), and I was instantly impressed with the flexibility of this data visualization library. As always with FCC, I learned a ton, and was ready to get my certification. But when I hit project 4, [Visualize Data with a Choropleth Map](https://www.freecodecamp.org/learn/data-visualization/data-visualization-projects/visualize-data-with-a-choropleth-map). I fell in love. I've always liked the texture and color of a good map, especially one that gives you some real information, and I was instantly hooked on the idea of tying data to a map with colors and a tooltip. So I put my certification on pause and embarked on what turned out two be two projects - a [data cleaner](https://www.quaffingcode.com/census-csv-parser/doc/index.html) for Node and [a pair of visualizer and selector classes](https://github.com/klm127/us-census-chloropleth-viewer-data-selector) for use with d3.

# Table of Contents
 - [The Visualization](#the-visualization)
 - [Intro](#intro)
 - [Getting the Data](#getting-the-data)
 - [Cleaning the Data - building census-csv-parser](#cleaning-the-data-building-census-csv-parser)
 - [Building KeyModeler.js](#building-keymodelerjs)
 - [Building USCensusMap.js](#building-uscensusmapjs)
 - [What I Learned](#what-i-learned)
 - [What's Next](#whats-next)

# Getting the Data

Census Data is available for free at [census.gov](www.census.gov). For the map, I found [this blog post](https://eric.clst.org/tech/usgeojson/) by Eric Tech offering U.S. "feature" data in GeoJson format.

GeoJson is a standardized format. The wrapper object consists of sub-objects representing "features", which may be states, counties, countries, or some other geographic enclosure. Each of those features has a name property and a series of numbers representing instructions for how to draw the borders of that feature using arcs which can be processed by a library like d3. These paths are relative to the Earth overall, using the actual latitudinal/longitutudinal coordinates of Earth's Geographic coordinate system. So if you mapped a GeoJson of Canada and a GeoJson of the United States, even if you aquired them from disparate sources, they would appear correctly right next to each other on your final projection. Unless you used some bizarre projection. But [they're pretty straightforward](https://www.sohamkamani.com/blog/javascript/2019-02-18-d3-geo-projections-explained/).

Census data, on the other hand, not so much.
# Cleaning the Data, Building census-csv-parser

Census data is ugly. Like, [really ugly](https://github.com/klm127/census-csv-parser/blob/master/test_data/maritaldataLarge.csv). Downloaded raw, it has 57 rows and **364** columns. And column headers have names like
>Estimate!!Never married!!LABOR FORCE PARTICIPATION!!Males 16 years and over

Oof. 
It makes sense though. That header represents a roadmap of where the data belongs when compared to the states in the first column.
 - Alabama
    - Estimate
        - Never Married
            - Labor Force Participation
                - Males 15 years and older

There are definitely good tools out there for cleaning data, but this was a learning project. I decided to create all the tools I would use to clean the data myself, document my code, extensively unit test it, publish it to NPM, and [publish the documentation](https://www.quaffingcode.com/census-csv-parser/doc/index.html). 

I created two namespaces for `census-csv-parser`. The first, named `util`, provides functions for parsing the data. It turns a .csv string into a 2D array. It chops of rows and columns based on [regexes](https://regex101.com/) or other parameters. It clears or replaces unwanted characters. It converts string data to number data when possible. It transposes the array. Finally, it splits selected elements into arrays and ultimately uses those arrays to generate a .json style object.

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

I needed an object that would generate DOM Elements a user could interact it with which would describe what data metric was sought. For that purpose, I built [KeyModeler](https://github.com/klm127/us-census-chloropleth-viewer-data-selector/blob/master/KeyModeler.js) to enable user interaction with data selection. KeyModeler is given a model object on construction. For example, "Alabama". KeyMapper traverses the keys of the model object and generates an [HTMLSelect Element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select) for each key, with the options being the next keys/paths. When it hits a final value, it stops. When an earlier select box is changed, it deletes the subsequent boxes and generates appropriate select boxes and options for that traversal path. It contains and updates an array representing the currently selected values. If it is passed an object with the same structure as its' model object, it traverses the keys of that object, based on the keys that have been selected by the user, until it finds the value at those coordinates.

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

I intend to reuse this class a lot for future data visualizations. Or, at least, for deciding on interesting data visualizations. 

# Building USCensusMap.js

FreeCodeCamp's [Chloropleth Project](https://www.freecodecamp.org/learn/data-visualization/data-visualization-projects/visualize-data-with-a-choropleth-map) has you use a provided TopoJson file, which requires an external dependency. I wanted to use the raw GeoJson files, because that is how map data is publicly available. Plus, d3 has a ton of [useful functions](https://github.com/d3/d3/blob/master/API.md#projections) for working with GeoJson files, like projections. I used the most obvious and familiar projection, [d3.geoAlbersUSA](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#geoAlbersUsa) for this.

There's a lot I could say about USCensusMap, but rather than wax poetical, I'm just going to provide a list of facts:
- A class
- Takes GeoJson data to be mapped and Census data to be rendered in color.
- Uses [d3 sequential multi-hue interpolators](https://github.com/d3/d3/blob/master/API.md#user-content-sequential-multi-hue), though I might be changing that in the near future; a simpler two color range mapping might be easier for the viewer to understand.
- Takes an instance of KeyMapper.js as a parameter, and needs it to figure out what property to map!
- Has two separate render functions for performance - one for rendering the map, one for rendering the data.
    - The map rendering only happens once, unless it's set to auto-resize mode. Then it happens whenever the window size changes.
    - The data mapping happens whenever the user-selected property in KeyMapper.js changes. USCensusMap.js attaches a listener to KeyMapper.
- Re-scales the color scheme each time a data render happens, and displays the extrema of the data.
- Uses no styling but can be styled with CSS Hooks.

The biggest frustration building the map portion happened near the end. I had everything working almost perfectly, but when displaying total population, most states were showing nearly black. It wasn't until I checked through all the [projections](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#geoAlbers), [color interpolator](https://github.com/d3/d3/blob/master/API.md#user-content-sequential-multi-hue), [scales]("https://github.com/d3/d3-scale/blob/v3.2.2/README.md#scaleSequential"), [path rendering](https://github.com/d3/d3-geo/blob/v2.0.0/README.md#paths), and [joins](https://github.com/d3/d3-selection/blob/v2.0.0/README.md#selection_enter) - and broke the code a few times - that I realized `USCensusMap.js` was working perfectly... but _I was including the U.S. totals in the dataset_. That wasn't as obvious for percentage-style metrics, but was glaringly apparent for totals. 

Basically, the maximum for my [domains](https://github.com/d3/d3-scale/blob/v3.2.2/README.md#continuous_domain), used by my [scales](https://github.com/d3/d3-scale/tree/v3.2.2) were being set to the sum total of the entire country, making every single state appear to be near the minimum value by comparison!

I'm a little embarrassed at how long it took me to figure out what was going on. I was actually halfway through writing the div that shows the minimum and maximum points of data when I figured it out.

There's no particular part of this code that I feel the need to show off, though I really like some of its functionality. For example, it can be given multiple event names to trigger the tooltip appearance and hiding, which by default are "[mouseenter](https://developer.mozilla.org/en-US/docs/Web/API/Element/mouseenter_event) [touchstart](https://developer.mozilla.org/en-us/docs/Web/Events/touchstart)", so it works decently well on mobile. All USCensusMap.js does is pass those event types to d3 when it calls [_selection_.on](https://github.com/d3/d3-selection/blob/v2.0.0/README.md#selection_on) as it renders.

This was designed with just the United States in mind and, for now, has the geoAlbers projection built in. But that is really the only part strictly dependent on U.S. Data. When it's time to create some worldwide visualizations, I'll just make a few changes and re-use this class.

You can find the code [here](https://github.com/klm127/us-census-chloropleth-viewer-data-selector/blob/master/USCensusMap.js). It's somewhat documented in the code, but I'll generate the jsdoc website for it too soon.

# What I Learned

- [jsdoc](https://jsdoc.app/)

Very much like Javadoc! Glad there seems to be a general conventions for documentation markup. Quickly generate html pages from your code, like [I did for census-csv-parser.](https://www.quaffingcode.com/census-csv-parser/doc/index.html) There's a number of templates out there. I wound up using [minami](https://github.com/Nijikokun/minami)
- [npm](https://www.npmjs.com/)

If you read this far, you probably already know what npm is. census-csv-parser was the first npm module I've [published](https://www.npmjs.com/package/census-csv-parser), And  - **holy cow** I just noticed I have 74 downloads! Who the heck has found my package? That's awesome! Now I feel obligated to get started on version 2.

- [d3](https://github.com/d3/d3/blob/master/API.md)

I definitely upped my skills with d3 more than I would have just doing the FCC certifications. It's an incredible library, though sometimes the documentation is a bit tricky to parse. I wish they had different examples. I did find a couple of other good posts that helped me, like [this one](https://www.d3indepth.com/geographic/) from d3indepeth and 
[this one](https://bl.ocks.org/mbostock/5562380) from Mike Bostock, the creator of d3. 

- [mapshaper](https://mapshaper.org/)

Ok, I haven't fully _learned_ this one yet, but I did use this to reduce the size of my GeoJson a little bit. It's a useful tool, so I'm including it here for reference. It has an in-browser command line with _all_ kinds of options.

- unit tests are a godsend

I wrote unit tests as I wrote `census-csv-parser`. I had never written unit tests before, mostly because it was a little intimidating and I was getting away with logging stuff on the console. This was a more complex library, and I was determined to get over my fear of testing. In many cases, I wrote the tests before I wrote the function. This was absolutely critical to getting the project done in a reasonable time frame. I found tons of problems that I would not have discovered otherwise. It was especially key for catching me when I would break parts of my code long after originally writing it.

# What's Next

- Improve styling of USCensusMap.js for mobile.
- Cleaning up and publishing documentation for `KeyMapper.js` and `USCensusMap.js`
- Publishing more data visualizations of interesting census data with this same code. (I can just pump them out now!)
- More functionality for `census-csv-parser` - more utility functions and more Parser functions. Especially more statistical-oriented ones. For instance, it should be able to generate variance and standard deviation columns. Also, it needs a **Command Line Interface** and **Method Chaining**.
- Visualizations of county level data. County level data is more granular and thus more interesting.
- Complete Free Code Camp's Data Visualization Certification

That's it, thanks for reading!

