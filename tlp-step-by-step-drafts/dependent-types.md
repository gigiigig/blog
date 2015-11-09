---
title: Dependent Types
author: Luigi
date: 1015-10-20
---

Before start talking about TPL, there are a few concepts 
that we need to explore, and the most important is Dependent Types, 
this is the base of TPL.

This is the definition of Dependent Types according to Wikipedia:

**_In computer science and logic, a dependent type is a type that depends on a value._**

Usually in languages like Java, the type and the value world are totally separated, we use the types to give us more info information about the values and add more constraints, but this is arbitrary, because we define them upfront.

With Dependent Types we remove this separation between the two worlds,
and we have two powerful features: 

- we types that depend on values, which means that we can compute them in a similar way of values
- we can define much more precise constraints for the values.

###Idris

Now, before start talking about Scala, let's see an example of dependent types using a full dependently typed language, and we'll go back to see what 
we have in Scala later. The language I'm going to show is Idris.

###Scala

Scala is not a fully dependently typed language, so we have to forget some
of the amazing things we can do with Idris and see what we have in Scala 
and what we can do with it.

#### Path Dependent Types

That's the main feature we have in Scala, let's see how they work.
In Scala we can define nested components, for instance we can define 
a class inside a trait, a trait inside a class and so on ...

```
  class Foo {                                                                      class Bar
  }

  val foo1 = new Foo
  val foo2 = new Foo

  val a: Foo#Bar = new foo1.Bar
  val b: Foo#Bar = new foo2.Bar

  val c: foo1.Bar = new foo1.Bar
  // val d: foo2.Bar = new foo1.Bar
  // [error]  found   : console.foo1.Bar
  // [error]  required: console.foo2.Bar

```

In this example I just nested to class Foo and Bar, I chose classes just
for syntax reasons, they could be also traits or case classes
and that would be the same, as we can see there are 2 ways to refer to 
a nested type:

- `#` means that we don't refer to any specific instance,
  in this case `Foo#Bar`, every Bar inside every instance of Foo 
  will be a valid instance 

- `.` means that we can only refer the Bar instances that belong to 
  a specif instance of Foo

Looking at the previous code example the difference is quite clear,
the values `a` and `b` of type `Foo#Bar` can accept every Bar,
instead as you can see `d` won't work because `foo1.Bar` is different from
`foo2.Bar`.

We'll see later how we can use this different approaches in practice.

###Parameter Dependent Types

Parameter Dependent Types are a form of Path Dependent Types,
as we have seen before we can refer to a type nested in a specific instance 
with the `.` syntax:

```
  val a: foo1.Bar = new foo1.Bar
```

Now we can use this technique inside a function parameters list

```
  trait Foo {
    trait Bar 
    def bar: Bar  
  }  

  def foo(f: Foo): f.Bar = f.bar
```

That is very powerful, we'll later how much in details.


