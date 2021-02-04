---
layout: post
title:  "FreeCodeCamp.org Front End Libraries Certification and Snippets"
date:   2021-01-24 18:35:31 -0500
categories: jekyll webdev react javascript snippets free-code-camp
tags: jekyll webdev react javascript snippets free-code-camp
external-js-dependencies: 
    - "https://unpkg.com/react/umd/react.development.js" 
    - "https://unpkg.com/react-dom/umd/react-dom.development.js"
    - "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js"
    - "https://cdnjs.cloudflare.com/ajax/libs/marked/1.2.7/marked.js"
custom-css-list: 
    - "2021-01-24-fcc-front-end.css"
permalink: "freeCodeCamp-Front-End-Cert-Snippets"
description: Review of FreeCodeCamp.org Front End Libaries Certification and my 5 final projects, embedded.
---
## What's in this post

- [A review of FreeCodeCamp.org's Front End Libaries Certification](#review)
- [A screenshot of my notes](#screen)
- [How I added those projects to this page](#adding-snippets)
- [Calculator](#calc-link)
- [Drum Machine](#drum-link)
- [25-5 timer](#twenty-five)
- [Random Quote Machine](#quote-gen)
- [Markdown Previewer](#md-link)
- [Summary](#the-summary)

### Review <span id="review"></span>

I've completed the [Front End Libaries Certification on FreeCodeCamp.org](https://www.freecodecamp.org/learn). FCC claims that it takes 300 hours to complete. I estimate it took about 50 hours to work my way through it. The course goes through [Bootstrap](https://getbootstrap.com/), [jQuery](https://jquery.com/), [Sass](https://sass-lang.com/), [React](https://reactjs.org/), [Redux](https://redux.js.org/), and [React-Redux](https://react-redux.js.org/). It's easy until the end. Concepts are introduced one at a time alongside a simple coding task which must be completed to progress. As long as you are reading carefully and taking notes, the problems are a breeze. The final section is considerably more challenging, however. You are tasked with creating 5 responsive front end apps in React on [codepen.io](https://codepen.io). Those apps must past unit tests conducted by the FCC script.

I take notes in [Freeplane](https://www.freeplane.org/wiki/index.php/Home), a mind-mapping software. I'll eventually make a post about how I maximize my usage of this powerful tool. It's easily my most-used application. Here's a screenshot from my FreeCodeCamp.org notes. I cannot stress enough how incredibly useful it is to efficiently reference back to what I've learned. 

### My notes: .png export from Freeplane <span id="screen"></span>

![freeplane screenshot]({{site.url}}/assets/images/2021-01-24-FreePlane-PNG-export.png "screenshot of a freeplane mindmap")

### Adding those projects to this website <span id="adding-snippets"></span>

I wanted to include those projects on this blog, and not just with a link to [my codepen](https://codepen.io/klm127). I used [this tutorial](https://dmitryrogozhny.com/blog/how-to-add-custom-script-to-single-post-in-jekyll) from Dmitry Rogozhny's blog to get started. Basically, I added yaml front matter to this post which describes external javascript resources that need to be loaded. In this case, React and JQuery. As my header is built, it inserts a `<link>` element for those resources based on my front matter.

The CSS styling was done in SCSS. Jekyll doesn't load that up by default. There's probably a Gem I could install, but instead I used a [scss to css converter](https://jsonformatter.org/scss-to-css). 

My script used Babel preprocessing for the React syntax, because writing React without JSX seems like a total drag. That meant I had to convert it to regular javascript in order to be able to include it as a `<script>` tag in this page. I followed [these instructions](https://babeljs.io/docs/en/babel-cli/) on the babel.js site and used npx and the command line to generate regular javascript.

The cli in a directory with each of my files was:
```
npm init
npm install @babel/core @babel/cli @babel/plugin-transform-react-jsk
npx babel drum-machine.js --out-file dist/drum-machine.js --plugins=@babel/plugin-transform-react-jsx
```

To insert the script in the page, I created a very small include, called `snippet-in-page.html`. <span id="snippet-in-page-html"></span>

{% highlight html %} {% raw %}
<script type="text/javascript" src="{{site.baseurl}}/assets/js/snippets/{{ include.content }}"></script>
{% endraw %} {% endhighlight %}


In this markdown file, I added a simple include and passed the name of the file as the content parameter.
{% highlight html %} {% raw %}
<!-- calculator-root is just the DOM entry point for the script-->
<div id = "calculator-root"></div>
{% include snippet-in-page.html content="calculator.js" %}
{% endraw %} {% endhighlight %}

Then I just threw my code in assets/js/snippets and included them as needed in this page!

### A Calculator <span id="calc-link"></span>

This was the hardest project. Input validation is accomplished by regexes, as is the tokenization process by which the calculator "processor" object parses the string to perform its calculation.

Here's a snippet:

{%highlight javascript%}
{%raw%}
let tokens = []; 
let token_finder = /(\-?\d+(\.\d+)?)|([\+*\/])/g;
let results = [...str.matchAll(token_finder)];
for(let i = 0; i < results.length; i++ ) {
    let r = convert(results[i][0]);
    if(r<0) {
        if(i<1) {
            tokens.push(0);
            tokens.push('+');
        }
        else {
            let last = tokens[tokens.length - 1];
            if(typeof last != typeof 'string') {
                tokens.push('+');
            }
        }
    }   
    tokens.push(r);       
}
{%endraw%}
{%endhighlight%}
#### Explanation:
1. An empty array for final tokens is initialized.
1. The regex token_finder finds two groups, either numbers which may or may not have a leading negative sign and may or may not have decimal values or one of the operator signs (+,-,/,*) and the matches are put into an array called results.
1. A for loop iterates over the results.
    1. A "convert" function is called on a result to turn it into a number or float if it's a number or float.
    1. If it's a number and negative:
        - If it's the first iteration, 0 and "+" are pushed to the tokens array.
        - If it's not the first iteration, and the token preceding this one is not an operator, a "+" is pushed to the tokens array.
    1. The result is pushed to the tokens array.

That's how this calculator can accurately deal with inputs like `"5*-3"`, `"5-3"`, and `"-5+3"`.

<div id="calculator-root"></div>

{% include snippet-in-page.html content="calculator.js" %}


The calculator has one _major_ bug that I just noticed. It displays "NaN" if the equation ends in a number. That's something to fix another time!

### A Drum Machine <span id="drum-link"></span>

Credit to Marcus Connor for the [CSS toggle buttons](https://codepen.io/marcusconnor/pen/QJNvMa) I used for the nifty switches on this drum machine. I originally found those toggles while browsing [freefrontend.com](https://freefrontend.com).

For a future js sound project, I'll to check out a library like [howler.js](https://howlerjs.com/) to see if I can do better with audio than javascript's regular `<audio>` tag. This Drum Machine works, I _guess_, and passed FCC's tests, but the clips cut themselves off and don't play reliably.

This was a decently tricky project, just because there were a lot of moving parts. I think it had the most separate React components out of any of these.

<div id="drum-machine-root"></div>
{% include snippet-in-page.html content="drum-machine.js" %}

### 25-5 Timer <span id="twenty-five"></span>

There are definitely some libraries out there I could have used to make this timer more accurate, as javascripts setInterval seconds aren't _exactly_ seconds. At least it saves me from having to include even more javascript on this page. I tried to make this one look a bit like a stopwatch. I used [Microsoft PowerToys Color Picker](https://docs.microsoft.com/en-us/windows/powertoys/color-picker) to grab various colors from a stopwatch reference photo and [cssgradient.io](https://cssgradient.io/) to make a couple gradients. I don't love the interface on that site though, and I'll be on the lookout for another gradient generator next time.

This was the final project in the series and it took forever to pass the last test. Couldn't figure out what I was doing wrong. Turns out, I wasn't prepending a "0" to my seconds and minutes, which the tester wanted. The timer should, of course, display `01:05` not `1:5`. Sometimes it's the little things that get ya!

<div id="timer-twentyfive-root"></div>
{% include snippet-in-page.html content="twenty-five.js" %}

<br />

### Random Quote Generator <span id="quote-gen"></span>

This was the first project of the bunch. It was fun because it was the first time I called an external api with the ajax feature. I'm looking forward to finding other apis, or even making one of my own. I recently wrote a [scraper](https://github.com/klm127/jeopardyAnkiScraper) that uses puppeteer to gather games on the [jeopardy archive](http://www.j-archive.com/) into .csvs for importing with [Anki](https://apps.ankiweb.net/). It would be pretty cool if I could leverage that into an API that would spit back random jeopardy questions instead of random quotes. Only issue is, figuring out what copyright issues I might run in to with that. Might have to send out some exploratory emails before I try putting something like that into production.

Another stumbling block I ran across here was the twitter icon. Originally, I used bootstrap to quickly grab an icon, and that works great, but as I was bringing that codepen onto this blog post, I decided I didn't want to add another big include, since I only used _one_ class in the entire bootstrap repo. I know there's a way bootstrap can compile you a small version with only what you need, but I didn't want to go through all that for one lousy little twitter icon. Instead, I went and found an SVG of the twitter icon and put that right in my code. React doesn't render SVG elements without additional libraries, however, so I had to insert the SVG as innerHTML into the link after it loaded.

I used a lifecycle function for that.

{%highlight javascript%}
{%raw%}
componentDidMount() {
      //for adding an svg to twitter <a>
      document.getElementById("tweet-quote").innerHTML = `<div id="twitter-image-wrap"><svg>...</svg></div>`;
}
{%endraw%}
{%endhighlight%}
<div id="quote-root"></div>
{% include snippet-in-page.html content="random-quote.js" %}

<br />


### Markdown Previewer <span id="md-link"></span>

I used an external script to help with this one, [marked.js](https://marked.js.org/), which made it really straightforward. Basically, you just call "marked(str)" and it transforms markdown into html elements. Couldn't be simpler.

All it came down to was:
```
$("#preview").html(marked(event.target.value));
```

In the onChanged() callback for the text area.

<div id="markdown-previewer-root"></div>
{% include snippet-in-page.html content="markdown-previewer.js" %}

<br />
Looks like some of the minimus CSS on this page and the stuff I stuffed in for these snippets are interfering with each other. Why did I have to get so fancy with my CSS when I was writing these?! I also thought it would be cool if the textarea expanded its column size depending on the page size, but that's come out _all_ kinds of weird. Yet another thing to fix up in the future!

### Summary <span id="the-summary"></span>

These projects were excellent challenges, perfectly appropriate for my skill level. They were great opportunities to practice javascript, CSS, and use many features of different libraries. I explored regular expressions, React's lifecycle methods, ajax API calls, and more. However, I got the most satisfaction out of the work I did integrating those projects into this page. It is extremely satisfying to envision a page an build it. I really like Jekyll, Liquid, yaml front matter, and this system for creating blogs. I look forward to heavily customizing this site in the future. Ruby is extremely elegant and straightforward, and I hope to be able to devote more time investigating it in the future.

So out of all this code, the most satisfying for me was the very short include I wrote, `snippet-in-page.html`, described [here](#snippet-in-page-html). I'll definitely be re-using that to take full advantage of the Jekyll / Liquid setup and plug all sorts of little utilities around my page. Next up is likely going to be a "top" button, that takes you back to the start of whatever page you're on.

I'm getting a _lot_ out of FreeCodeCamp. I'm going to keep going with it. Next up is the **Data Visualization Certification** which looks to be focused on [D3](https://d3js.org/). That's a lot more exciting to me than any of these front end libraries. 

Plus, FreeCodeCamp.org offers certifications that show up on your linkedin!

![FreeCodeCamp.org certification as it appears on LinkedIn]({{site.url}}/assets/images/fcc-front-end-certification.png "FreeCodeCamp certification on LinkedIn")

That'll look nice with a Bachelor's Degree beside it! I'm looking forward to making a hefty donation to FCC, as soon as I'm employed.

If you made it this far, I hope you enjoyed reading!