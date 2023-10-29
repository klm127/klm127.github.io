---
name: Dräger Filter Finder
brief: A mobile app for finding the right filter for your toxin.
technologies: javascript react-native azure
year: 2023
updated: 2023-10-16
started: 2023-05-18
commits: 169
link: https://iphone.apkpure.com/app/dr%C3%A4ger-air-filter-finder/com.draeger.airfilterfinderapp
layout: project
output: true
completed: complete
---

I completed this project for my summer internship at [eProcess Development](https://eprocessdevelopment.com/). I chose React Native, because much of what ePD does is with React, and I could realize a cross-platform ios/android app with it. I interfaced with a client representative and designer who approved my progress as I iterated. I was able to complete the project ahead of schedule.

The essence of the app is that the user searches a [flashlist](https://shopify.github.io/flash-list/) of toxic substances. When they select one, they can see the Dräger mask filters that are rated for that substance. The client also wanted some custom animations that were challenging to get exactly right.

The biggest challenge was that the client's policies required that we build with Microsoft Azure. I had to learn how to write an `azure-pipelines.yml` file. This got tedious, because there was a lot of waiting for build results. 

I might make a post about this. I ran into some specific challenges ejecting Expo, which was a development tool I used. These aren't well answered in the Expo community, probably because Expo would prefer you to use their "EAS" service to build and deploy but, for those who are required to use Azure, a post about how to best approach it would be helpful.