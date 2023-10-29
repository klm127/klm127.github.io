---
name: Minimum Dominating Set
brief: An analysis of brute force and greedy algorithms to find the min dom set.
technologies: c++
year: 2023
updated: 2023-10-28
started: 2023-10-14
commits: 36
github: https://github.com/mwilliams52000/Analysis-Of-Algorithms-Program-1
layout: school
output: true
completed: ongoing
---

The minimum dominating set problem asks, "given a graph, you can color some vertices. If you color vertices such that every vertice is colored or is connected to a colored vertice, then the colored nodes are a dominating set. Find the smallest set that can dominate a graph."

The brute force algorithm is `O(2^n)` to test every possible set. The assignment was to find a graph that took our algorithm over 24 hours to run, compare that result to a heuristic greedy algorithm, and analyze the results.

I became fascinated with optimizing the brute force algorithm by testing all possible sets of size 1 before 2, all 2s before 3s, etc, allowing it to finish early. I am still patting my own back for the clever function I wrote to do this, and I'll make a post about it soon. If you additionally split off all disjoint subsets in the graph and run the algorithm independently on them, the worst-case is reduced to `O(2^(1/2)n)`.

