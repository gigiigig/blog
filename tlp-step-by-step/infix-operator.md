---
title: Infix Operator
author: Luigi
date: 2015-11-02 
updated: 2016-01-22
---

This is going to be a very quick one, it's a small syntax detail that 
might be confusing if you don't know it.

In Scala we can use the infix notation for methods:

```
object Foo {
  def bar(s: String) = println(s)
}

Foo.bar("hello") // standard
Foo bar "hello"  // infix 
```

In the same way we can use the infix operator for types,
basically what we can do is:

```
trait Foo[A, B]

type Test1 = Foo[Int, String] // standard
type Test2 = Int Foo String   // infix
```

The declarations in `Test1` and `Test2` are equivalent and valid,
there is another thing that is possible to do which is to use symbols in 
type names the same way we can use them in method names, 
so if you ever tried to take a look at shapeless code,
this is going to be more familiar now:

```
trait ::[A, B]

type Test3 = ::[Int, String]
type Test4 = Int :: String
```

That's it, nothing really hard in this post but this is a small
detail that can create big confusion, at least it did for me,
if you are not aware of it.

