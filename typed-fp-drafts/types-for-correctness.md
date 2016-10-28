---
title: Use types for correctness
author: Luigi
date: 2016-10-27
---

Ok, so what I've been saying so far is basically to not use classes/trait/objects in the way wee are use to,
which is basically inheritance, we use just classes as data containers and `objects` as namespaces,
but then, what do we do with all the stuff we have? What do we do with our type system??

Well maybe you will surprised to know that one of the languages with the most powerful type system, Haskell,
doesn't have inheritance, you can't extend anything or create hierarchies .. wait what??

I'm a big fan of the type system and indeed I don't like dynamic languages, but I think we
should use to make our life easier not harder, so instead of using it for reuse and compose stuff,
which leads to disaster, the real reason to use it for me is to improve *correctness*.

This what is good for, I'm gonna show some examples now but the possibilities here are infinite and
the Scala type system us extremely powerful, so I'll just try to give some idea,
I wrote an entire blog series about the type system, you might want to check that later
[Type Level Programming in Scala step by step](../tlp-step-by-step/introduction.html)

## Wrapping Primitive Types
This is the simplest way to use types to increase your correctness, wrapping primitive types in
specific containers is simple but extremely useful technique.

```
  case class Car(model: String, year: Int, kms: Int)

  object Car {
    def print(car: Car) = "${car.model} year: ${car.year} kilometers: ${car.kms}"
  }

  Car.print(Car("Fiesta", 12000, 2010))
```

Do you see anything wrong in the example? Maybe no, and maybe you didn't see it in production
either, I doubt that a car was created in year 12000, this mistake is so common,
I know we have code reviews, tests and all the fancy stuff to avoid this, but it does happen,
however we are lucky and the type system is here and happy to help, lets rewrite this in a better way:

```
  import Car._
  case class Car(model: String, year: Year, kms: Kms)

  object Car {
    case class Year(value: Int) extends AnyVal
    case class Kms(value: Int) extends AnyVal
    def print(car: Car) = "${car.model} year: ${car.year.value} kilometers: ${car.kms.value}"
  }

  // Car.print(Car("Fiesta", 12000, 2010))
  Car.print(Car("Fiesta", Year(2010), Kms(12000)))
```

This simple change makes things much safer, if by mistake we swap the parameters the compiler will tell us,
and when we start to pass those params around, we will always use the right type.
Is important to notice that I'm always extending `anyval`, in Scala these are called *value classes*,
this type of classes don't have any runtime overhead, basically the compiler will replace them
with the primitive type, so they only exists at compile time, and then there won't be any performance loss
with this technique, if you want to know more
there is an article here [Value Classes](http://docs.scala-lang.org/overviews/core/value-classes.html)

There are more techniques to create wrappers, if you want to know more Iain Hull gave a great talk at Scala Days
[Improving Correctness With Types](http://www.youtube.com/watch?v=uxofKKIAY3Q)

## Using proper types to represent common behaviours

Let's a different example about how to use the type system to help us with correctness,
I'm sure everybody have seen this code at least once, probably much more often:

```
  case class Person(name: String)

  def fromName(name: String): Person =
    if (!name.isEmpty) Person(name)
    else null

  def printPerson(p: Person): String =
    if (p != null) p.toString
    else "null"

  val p = fromName("")
  println(printPerson(p)) // null
```

I'm pretty sure that everyone have seen at least once something like this, probably
way more often, this is clearly very error prone, we are never sure when a method returns
null, they standard way of doing it is to put the result type in the documentation,
this however is not a great idea, the documentation often is not updated and let's
be honest, we don't always read it :)

It would be much better if we can describe with our types all possible outcomes of our functions,
so let's rewrite this in a safe way.

```
   case class Person(name: String)

   def fromName(name: String): Option[Person] =
     if (!name.isEmpty) Some(Person(name))
     else None

   def printPerson(p: Person): String = p.toString

   val p = fromName("")
   println(p.map(printPerson).getOrElse("None")
```

What we did here is to replace `null` with an apposite type,
`Option`, that can have two different values, `None` and `Some(),`
that represent the two different possibilities, a value exists or not,
but now the code is much safer, when our user will call the function
`formName` he will, just looking at the return type that the value might not exist
and is forced to deal with that case, without going around and reading documents to make sure
that all the cases are handled.

## Conclusion

There are way more ways to use types to enforce correctness, these two are however
two great examples to show how with small changes we can improve a lot our codebase,
we'll come back to the `Option` later and we'll see a more generic way to use types
to encapsulate common behaviour, the main point here is to understand
that stopping using types in the classic OO way, code reuse and composition via inheritance,
*doesn't mean at all giving up on the type system*, but it means that we are using it
to help us to write correct programs, instead of complicating our code with
crazy class hierarchies that create more problems than they solve.

