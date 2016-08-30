---
title: Introduction
author: Luigi
date: 2016-08-30
---

In this series I'm going to talk about Typed Functional Programming in Scala,
I will not talk in deep about some specific monads like Free, Reader, State etc ...
or a specific library like Cats or Scalaz, instead my goal is to talk about generic principles
of Typed Functional Programming (TFP from now on) the are in my opinion what really make TFP valuable in the real world.

This series is really opinionated, this is the way I think Scala should be used and I'm not really interested in
any OO vs FP flames, so read it at your own risk :)

## List.map is not FP

This seems to be a common misconception, I see often teams and companies claiming to do FP over OO because
they use `List.map` and when they are really cool even `List.flatMap` or even `Option` over `null`,
even if this is certainly a good thing to do, that doesn't mean that you are doing FP.

FP means programming using functions instead of objects and inheritance when you design your code,
avoid mutable states and all those patterns that we learnt when we started coding and the
enterprise community convinced everybody were good.

These are few principles I think are the basics of Typed Functional Programming, and everyone should keep in mind:

 - Use functions for code reuse and compositions
 - Separate data and functions
 - Use types for correctness
 - Understand the Monads and don't be afraid of them
 - Use typeclasses for polymorphism
 - Don't use mutable state
 - Don't throw exceptions, use appropriate data structures
 - Always wrap IO inside a Monad


