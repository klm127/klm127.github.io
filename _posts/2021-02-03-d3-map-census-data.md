---
layout: post
title:  "Experiments in Data Visualization - Choropleth"
date:   2021-02-03 18:00:00 -0500
categories: javascript data chloropleths visualization census maps
tags: javascript data choropleth visualization census maps
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

- The most married state is Utah, at 55%. The nuptial practices of Utah's large mormon population reasonably explain this. 

- Washington D.C. has an incredibly low marriage rate. Double digits away from anywhere else. Only 30% married and almost 60% never married. This isn't just due to a young population. In the 35-44 age bracket, 50% of D.C. males have never married. Most states are in the 20% range, with New Mexico at 33%. In D.C., 46.2% of females in that age range have never married, where not a single state breaks 30%. The gap only widens past 54. The marriage rate in D.C. is an extreme outlier. It's shocking, really. Apparently those who work for the federal government aren't too keen on raising families. Maybe their careers are too demanding, there is anti-family culture in D.C., or that city and work just attracts a certain kind of person, perhaps one who loves nothing so much as power.

- The D.C. gap isn't racial either. D.C. leads the pack in whites and blacks, and in almost all age ranges. 

- The runners up for the highest never-married rates are Massachusetts, New York, with around 40% never-married, which is still a far cry from D.C.s 56.8%.

- The map is a little different when looking at the African American population. D.C. still leads by a wide margin, except for Wisconsin, which shows up out of nowhere with almost as high a rate - 62.8% to D.C's 63.2%.

- The most widowed state is West Virginia, at 7.9%. Much of this is certainly due to the historically brutal conditions of coal mining, but West Virginia also shares first place with Oklahoma and Indiana as highest widower rate amongst males ages 20 to 34. I hypothesize that the wave of opiate use that swept the Mountain State from the early 2000s on contributes to this statistic.

- The most divorced state is Maine, at 14%. The District of Columbia is actually the LEAST divorced region - not enough people get married there in the first place to get divorced! New Jersey, Utah, and New York are close behind. I suggest that for those Northeast states, the high never-married rate explains the low divorce rate, but for Utah, the high religiosity discourages divorce.

- The statistics change a little when looking at only women. The most divorced states for women are Nevada and Florida, whereas for men it's definitely Maine. I wonder if this reflects where people like to start over after a divorce, rather than where they got divorced in the first place. Clearly, there tends to be some migration after a divorce, or the states would align more exactly across the sexes.

- I can't speculate as to why this is, but for Hispanics or Latinos, the most married states are West Virginia and Florida and the least is Vermont with the Northeast not too far behind. Vermont also shows up as the place with the highest rate of divorced African Americans, at 17.5%. Alaska is not far behind, at 16.6%. I hold to my hypothesis regarding relocation after divorce, and these states being "retreat" states. For Asians, the most divorced state is Montana, at 12.1%, which could also be considered a "retreat" state.

- The separation rate tends higher in the Southeast. This may reflect cultural taboos against divorce.



# What's Next

- Improve styling of USCensusMap.js for mobile and tweaking the projection to show P.R. and D.C.
- Cleaning up and publishing documentation for `KeyMapper.js` and `USCensusMap.js`
- Publishing more data visualizations of interesting census data using these projects as boilerplate.
- More functionality for `census-csv-parser` - more utility functions and more Parser functions. Especially more statistical-oriented ones. For instance, it should be able to generate variance and standard deviation columns. Also, it needs a **Command Line Interface** and **Method Chaining**.
- Visualizations of county level data. County level data is more granular and thus more interesting.
- Complete Free Code Camp's Data Visualization Certification

Thanks for reading!

