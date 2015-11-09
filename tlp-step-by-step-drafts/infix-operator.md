---
title: Infix Operator
author: Luigi
date: 1015-11-02 
---

This is going to be a very quick one, it's a small syntax detail that 
might be confusing if you don't know it.

In Scala we can use the infix notation for methods:


In the same way we can use the infix operator for types,
basically what we can do is:

```
  trait Foo[A, B]

  type Test1 = Foo[Int, String]
  type Test2 = Int Foo String
```

The declarations in `Type1` and `Type2` are equivalent and valid,
there is another thing that is possible to do is to use symbols in 
type names, the same way we can use them in method names, 
so if you ever tried to take a look at shapeless code,
this is going to be more familiar now:

```
  trait ::[A, B]

  type Test3 = ::[Int, String]
  type Test4 = Int :: String
```

That's it, nothing really interesting in this post but this is a small
detail that can create big confusion, at least it did for me,
if you are not aware of it.
