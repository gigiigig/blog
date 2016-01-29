---
title: Heterogeneous Lists 
author: Luigi
date: 2016-1-29 
---

Heterogeneous Lists, from now on HList, are a particular type of List 
that instead of containing elements of the same type, 
can contain elements of different types preserving the type of every element.

The reason why we are talking about them is that to implement them in Scala
you need TLP, they are extremely useful in the real world and they will
help me to explain some important concept later.

An HList is conceptually similar to Tuple, it is a product type, the difference is that it doesn't have a specific size, in Scala we can Tuple of N size up to 22, but they are implemented with 22 different types `Tuple2`-`Tuple22`, 
and then we have a special syntax to construct them `(1,"", false)`.

This works well enough in many cases but it's a bit of problem when we 
want to define generic operations for tuples.  




