---
title: The Aux Pattern
subtitle: A short introduction to the `Aux` pattern
author: Luigi
---

### Introduction

Let's start saying that the `Aux` pattern is not a pattern,
is a technique used in every library that is doing some type level
programming, you basically need to do it to overcome one of the Scala limitations

### Type Level programming in Scala

Type level programming simply means doing some programming at type level,
Scala is not a fully dependent type language and you can't have fucntions
that compute types, so to do that we have to use two features: 
path dependent types and implicits.
   
Path dependent types are types that depends on their own path, 
let's make this celear with an example:

```
trait Foo {
  type T
}

val f1 = new Foo { type T = String }
val f2 = new Foo { type T = Int }

val t1: f1.T = "foo"
val t2: f2.T = 2

```

The type in `t1` is different from the type in `t2` because they come
from a different instance or path.

Now this is not enought to make a computation,
and we can call implicts to help:

```
trait Foo[A] {
  type B
  def apply(): B
}

implicit val fs = new Foo[Boolean] { 
  type T = String 
  def apply(): String = "foo"
}
implicit val fi = new Foo[Double] { 
  type T = Int 
  def apply(): String = 2
}

def foo[T](t: T)(implicit foo: Foo[T]): foo.B = foo() 

val f1: String = foo(false)                                     
val f2: Int = foo(3d)                                     

```



