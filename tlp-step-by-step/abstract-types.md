---
title: Abstract Types
author: Luigi
date: 2015-11-01
---

In the previous example we have seen Dependent Types, 
what they are and what we have in Scala, now we are going to
see another Scala feature that together with Dependent Types and Implicits
gives us a lot of power.

An Abstract Type is a type that is not known yet and we can define
later, it is defined with the keyword `type`, 
it basically  works for types like the `def` keyword works for values:

```
trait Foo {
  def foo: String
}

trait Bar {
  type T
}

```

For instance here `def foo: String`  tells us that we have an abstract 
member in the trait `Foo` that has to be defined later, 
in the same way `T` defines a type that we can define later.

Now let's put this together this with Dependent Types and see what we get:

```
trait Foo {
  type T
  def value: T
}

object FooString extends Foo {
  type T = String
  def value: T = "ciao"
}

object FooInt extends Foo {
  type T = Int
  def value: T = 1
}

def getValue(f: Foo): f.T = f.value

val fs: String = getValue(FooString)
val fi: Int = getValue(FooInt)
```

I think this is the first very interesting example that we meet,
the trait `Foo` has an abstract type `T` that we define only inside his 
implementations with different types, and then the function `getValue` 
is able to change his return type depending on the input that we 
pass, we are very far from our goal but this our first step 
toward TLP!

### `type` is not an alias!

For some reason the `type` keyword is often referred as _type alias_ ,
this name is a bit confusing, `type` is not only an alias,
for instance when before we declared  

`type T = String` we could say that `T` is an alias

but looking a this one

`type Result[T] = Either[Sring, T]` 

this is not just an alias anymore, it is actually a function,
that takes `T` as parameter and returns `Either[String, T]` 
as a result.

### Connecting the dots 

In this post we have seen how we can use 
Dependent Types and Abstract Types to change the return type 
of a function and also that the Abstract Types allow us 
to define functions at type level, and this two things together 
give us the basics of TLP.

