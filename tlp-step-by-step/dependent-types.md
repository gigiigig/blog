---
title: Dependent Types
author: Luigi
date: 2015-10-20
---

Before start talking about TLP, there are a few concepts 
that we need to explore, and the most important is Dependent Types, 
this is the base of TLP.

This is the definition of Dependent Types according to Wikipedia:

**_In computer science and logic, a dependent type is a type that depends on a value._**

Usually in languages like Java, the type and the value worlds are totally separated, we use the types to give us information about the values and add constraints, but this is arbitrary, because we define them upfront.

With Dependent Types we remove this separation between the two worlds,
and we get two powerful features: 

- we have types that depend on values, which means that we can compute them in a similar way to values, this gives us more flexibility
- we can define stronger constraints for the values

### Idris

Now, before starting to talk about Scala, let's see an example of dependent types using a full dependently typed language, and we will go back to see what we have in Scala later. The language I'm going to show is Idris.

(These examples are copied from the [official documentation](http://docs.idris-lang.org/en/latest/tutorial/typesfuns.html))

First thing  
`"In Idris, types are a first class language construct, meaning that they can be computed and manipulated (and passed to functions) just like any other language construct."` 

That should be more clear looking at this example:

```
isSingleton : Bool -> Type
isSingleton True = Nat
isSingleton False = List Nat
```

No worries if you are not familiar with this syntax, just focus on the 
concept, basically the first line is the type declaration of the function,
and every input parameter is separated by `->`, the last type in the expression is the result type. 

What we can see is that this function takes a `Bool` and returns 
a `Type`, so this is a function that computes a type as result and 
not a value, we will be able then to use this in a *"normal"* function (from
value to value), to compute the **type** of one value **depending** on another value.

In this case the function is using pattern matching on the boolean, 
so if the input is `True`, the result type will be a `Nat` (which stands for natural number), otherwise we will have a `List Nat` or in Scala we would say`List[Nat]`.
The following example shows how to use it:

```
mkSingle : (x : Bool) -> isSingleton x
mkSingle True = 0
mkSingle False = []
```

As we see, in the type declaration we are using `isSingleton` to do a computation  
`(x : Bool) -> isSingleton x`, we take a `Bool` x, and then we pass it to `isSingleton` 
to compute the result type.
We can see indeed that we return two results with different types, `0` is a `Nat` and `[]` stands for empty `List Nat`.

We have seen how to use functions that compute types, 
let's see now how to use Dependent Types to define stronger constrains: 

```
(++) : Vect n a -> Vect m a -> Vect (n + m) a
(++) Nil       ys = ys
(++) (x :: xs) ys = x :: xs ++ ys
```

Here we are defining a function `++` that sums two vectors, 
the first line again define the type of the function, 
I'll rewrite this in a *scalish* way to make it easier for people not familiar with the Haskell syntax (Idris syntax is based on the Haskell one)

```
trait Vect[Size, A] 

def ++[n, m, a](v1: Vect[n, a], v2: Vect[m, a]): Vect[(n + m), a] 
```

We are taking as parameters two Vectors with elements of type `a`,
and we are returning a new Vector which still has elements of type `a`,
the interesting part are the first type parameters, `n` and `m`,
they represent the size of the vector, we are saying that the resulting 
Vector has to have a size of `n + m` 
(the syntax is not valid in Scala of course), Idris compiler is basically
able to inspect the implementation and verify that this extra constrain 
is respected. 

This is cool right!

That's only a small example of what is possible with Idris and Dependent
Types, I suggest you to go to the [Idris website](http://www.idris-lang.org/) to get more information.

### Scala

Scala is not a fully dependently typed language and we have to forget some
of the amazing things we can do with Idris, however Scala supports some
form of Dependent Types and there is still a lot that we can do.

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

In this example I just nested 2 classes Foo and Bar, I chose classes just
for syntactic reasons, they could be also traits or case classes
and that would be the same, as we can see there are 2 ways to refer to 
a nested type:

- `#` means that we don't refer to any specific instance,
  in this case `Foo#Bar`, every Bar inside every instance of Foo 
  will be a valid instance 

- `.` means that we can only refer the Bar instances that belong to 
  a specif instance of Foo

Looking at the previous example the difference is quite clear,
the values `a` and `b` of type `Foo#Bar` can accept every Bar,
instead as you can see `d` won't work because `foo1.Bar` is different from
`foo2.Bar`.

We'll see later how we can use this different approaches in practice.

### Parameter Dependent Types

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

### Conclusion 

Dependent Types are the base of TLP, we have seen what they can do and what we have in Scala, we'll see later how to use them in practice and how powerful they are, but before we need to explore some more techniques.  


