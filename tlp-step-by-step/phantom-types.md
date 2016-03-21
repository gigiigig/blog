---
title: Phantom Types
author: Luigi
date: 2015-11-05 
updated: 2016-01-22
---

We have seen before how using Dependent Types we can do some really basic 
computations, however to do something actually useful we need more than 
that, so we are going to see, in this post and the next, two techniques 
that are very useful in Scala in general, and that become even more powerful
along with TLP.

In this post we are talking about Phantom Types, the reason why they are called phantom is that they are used as type constraints but never instantiated.

```
trait Status
trait Open extends Status
trait Closed extends Status

trait Door[S <: Status]
object Door {
  def apply[S <: Status] = new Door[S] {}

  def open[S <: Closed](d: Door[S]) = Door[Open]
  def close[S <: Open](d: Door[S]) = Door[Closed]
}

val closedDoor = Door[Closed]
val openDoor = Door.open(closedDoor)
val closedAgainDoor = Door.close(openDoor)

// val closedClosedDoor = Door.close(closedDoor)
// val openOpenDoor = Door.open(openDoor)
```

In this example we implement a very simple model, a door that can 
be open or close, and we try to use the phantoms to guarantee, at compile
time, that we can only open a close door and close an open door.

We start defining the statuses `Open` and `Closed` both subclasses of `Status`,
after we define the `Door` as trait, the interesting part is that 
we add to the trait a type parameter that represent the door status.

We put then the behaviour in the companion object, now for every action
we add a type constraint, the method `open` has the constraint `Closed` 
and `close` has `Open`.

That is pretty much it, we can see then in the example that the first 3 operations work as expected and after, when we try to open an `Open` door or close 
a `Closed` door, it doesn't compile which is what we wanted. 
It's important to notice that the traits `Open` and `Closed` are never instantiated, we use them as only constraints.

I presented a minimal example just to explain the concept,
there is already a lot of good and complete material about Phantom
Types, these are two great articles, the first shows the builder pattern  

[http://blog.rafaelferreira.net/2008/07/type-safe-builder-pattern-in-scala.html](http://blog.rafaelferreira.net/2008/07/type-safe-builder-pattern-in-scala.html)

and the second how to use them with slick to add safety

[http://danielwestheide.com/blog/2015/06/28/put-your-writes-where-your-master-is-compile-time-restriction-of-slick-effect-types.html](http://danielwestheide.com/blog/2015/06/28/put-your-writes-where-your-master-is-compile-time-restriction-of-slick-effect-types.html)























