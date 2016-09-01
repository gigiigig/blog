---
title: Use functions for code reuse and compositions
author: Luigi
date: 2016-08-31
---

I think this is really the main point of all of this, Functional Programming, typed or not,
simply means programming using functions instead of objects/classes.

There is this popular idea that OO is great for code reuse and composition,
for instance using inheritance we can save a lot of code putting all the common logic in a base class and then we
extend it to define the specific cases, this actually does work but introduce a lot of pitfalls that we don't really need, we can achieve the same things in a much simpler way just using functions.

To explain what that means I'll go straight to an example:

```
  object OO {
    trait Op {

      def op(i1: Int, i2: Int): Int

      def exec(i1: Int, i2: Int): String = {
        s"The result is: ${op(i1, i2)}"
      }
    }

    object Sum extends Op {
      def op(i1: Int, i2: Int): Int = i1 + i2
    }
    object Mult extends Op {
      def op(i1: Int, i2: Int): Int = i1 * i2
    }
  }

  object TFP {

    def exec(op: (Int, Int) => Int)(i1: Int, i2: Int): String = {
      s"The result is: ${op(i1, i2)}"
    }
    val sum: (Int, Int) => String = exec(_ + _)
    val mult: (Int, Int) => String = exec(_ * _)
    def mult2(i1: Int, i2: Int): String = exec(_ * _)(i1, i2)

  }

  val r1 = OO.Sum.exec(3, 4)
  val r2 = OO.Mult.exec(3, 4)
  val r3 = TFP.sum(3, 4)
  val r4 = TFP.mult(3, 4)

  assert {
    r1 == r3 && r2 == r4
  }
```

So this is a very typical example, I see that everywhere, in order to abstract over some logic,
people create base traits/classes with some abstract method and then implement this method in some subclass,
this is extremely error prone, this example is trivial but when you start to have layers of classes and methods,
becomes very easy to break the code, something in the hierarchy could override something that wasn't supposed to,
and you have bugs.

We can see how the same goal can be easily achieved taking a function as parameter,
we can define our generic functionality, `exec` in this case,
and then define specific cases like `mult` or `add` without the need to create any class hierarchy.

As you see in the example there is something in Scala and many other languages called currying,
the `exec` function takes two parameters block, if we pass only the parameters of the first block, this
will return a new function that takes only the parameters of the second block,
this is great to create more generic functions and then some specialised versions of them.

In this second example we are going to see something even worse than the first,
the first one indeed is a pattern very popular in Java, but there was a good reason to do that,
Java didn't have lambdas until version 8,
so we couldn't take a function as parameter and that means we couldn't do what we have seen before,
however I see people using traits to "reuse" code even when there is not reason at all,
this is unfortunately very common:

```
  object OO {
    trait Fooable {
      def foo[T](t: T): String = {
        s"foo: $t;"
      }
    }

    trait Barable {
      def bar[T](t: T): String = {
        s"bar: $t;"
      }
    }

    trait FooBarable extends Fooable with Barable {
      def fooBar[T](t: T): String = {
        val f = foo(t)
        bar(f)
      }
    }

    object Model1 extends FooBarable
    object Model2 extends FooBarable

  }

  object FP {
    def foo[T](t: T): String = {
      s"foo: $t;"
    }
    def bar[T](t: T): String = {
      s"bar: $t;"
    }
    def fooBar[T]: T => String = foo _ andThen bar
    def fooBar1[T]: T => String = bar _ compose foo
  }

  assert {
    OO.Model1.fooBar(4L) == OO.Model2.fooBar(4L) &&
    FP.fooBar(4L) == FP.fooBar1(4L) &&
    OO.Model1.fooBar(4L) == FP.fooBar(4L) &&
    FP.fooBar(4L) == "bar: foo: 4;;"
  }

```

The traits `Fooable` and `Barable` contain two functions, now we want to use them in our `Model` objects, it seems
very common to put functions inside traits and then mix them together to reuse those functions,
this is bad in many ways, mixing trait has a compile time and runtime cost,
and also is semantically wrong because we are implying that our class is an instance of Foo and Bar,
when we just want to use those methods, it is much simpler to define the functions inside an project and just
import it, without the need to extend anything.

The functions we have seen in the previous example are pure functions,
meaning that they don't access anything in the current instance,
but what if want to do that? It has to be a trait otherwise we won't have the current instance `this` available.

Well there is a way to avoid that:

```
  trait Logger {
    def log: Unit = println(s"log: ${this.getClass.getSimpleName}")
  }

  object Foo extends Logger {
    log
  }

  implicit class Logger2(a: AnyRef) {
    def log2: Unit = println(s"log: ${a}")
  }

  object Foo2 {
    this.log2
  }

  Foo2.log2
```

I think I've seen this class Logger pretty much in every project I've worked with,
you need to access the current instance to get some context, the name in this case,
so `Logger` actually make sense to be a `trait` and this is one of the cases when I understand people doing that,
however there is a way to avoid it as we see in the second part of the code, Scala supports implicit classes,
this allow us to add methods to some type without actually changing it, as we see we can then call
`Foo.log2` , what we can't do is to call `log2` inside the instance directly probably because the implicit conversion
won't kick in otherwise, we can however call `this.log2` and everything works fine.

So we have seen in this post how to avoid to use trait/classes for code reuse and composition and use just functions
instead, the advantage is quite clear I think, code is simpler and we avoid all the inheritance pitfalls,
this bring us to the next subject which is [Separate data and functions](./separate-data-functions.html)

