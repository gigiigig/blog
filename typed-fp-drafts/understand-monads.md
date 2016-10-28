---
title: Understand the Monads and don't be afraid of them
author: Luigi
date: 2016-10-28
---

We can't really talk about FP and don't say the word: *__Monad__*

Now for some reason this seems to be one the biggest argument that OO developer have against FP,
everything the flame war starts we end up talking about Monads and how they are crazy and complicated.

So wait, what? Seriously? So people is confident to use meta-programming, macros, monkey patching,
runtime DI, and all sort of crazy techniques that can introduce ant sort of bugs, **but**
they are *so* scared from an interface that defines **two**, yes let me repeat **two** methods.

Funny right? Ok I admit that the name is not the most friendly, and yes the FP community often doesn't
help to make things easy for new comers, and we end up with jokes like the (in)famous:

*__A monad is just a monoid in the category of endofunctors, what's the issue?__*

But I still think that often people is simply scared from what they don't know, and
find any excuse to not even try it.

Now I'll stop the ranting and start talking about Monads, but before trying to describe them,
let's see in practice why they are useful.

## Monads in the real world

Another word Monads are often referred to is _effect_, I even prefer to use the word _behaviour_,
let's get back to the `Option` example we have seen in [Use types for correctness](../types-for-correctness.html)
what we did there was replacing a very common behaviour:

```
def fromName(name: String): Person =
  if (!name.isEmpty) Person(name)
  else null

def printPerson(p: Person): String =
  if (p != null) p.toString
  else "null"
```

With a type that basically encodes that behaviour, and allows us to reuse it everywhere
without repeating the same code over and over (for the full example look at the other article):

```
def fromName(name: String): Option[Person] =
  if (!name.isEmpty) Some(Person(name))
  else None

def printPerson(p: Person): String = p.toString
```

`Option` is certainly not a special case, just looking at the Scala standard library
we can find other similar types:

 - `Option[T]` represent an possibly null value
 - `Future[T]` represent an value available after an asynchronous computation
 - `List[T]`   represent a multiple value
 - `Try[T]`    represent a value that could be a failure

So this are few common Scala types, we can clearly see that they have some common characteristics:

 - they are all container for values
 - they have all the same "shape", F[_], they are container and take an input type T,
   which is the type of the value that they contain
 - they all represent a behaviour

As we see, this types are all very similar each other, and usuaually what happens in the
real word is that we have more than one value that have the same behaviuour,
for instance ofte we have more asynchornous computation together or optiona values together,
and we need to ba able to use combine those values, this bring us the two functions
that we were talking about before

 - flatMap (also known as `bind`)
 - pure (also known as `point` or `return`)

let's explain them with an exmaple:

```
case class User(id: Int)
case class Event(userId: Int, content: String)

def getUser(): Future[User] = { .. asyncronous read from a database .. }
def userEvents(userId: Int): Future[List[Event]] = { .. asyncronous read from a database .. }

val events: Future[List[String]] = getUser().flatMap { user =>
  userEvents(user.id)
}
```

This is a common use case, we read a user from the database asyncronously (beacuse we are Cool and Reactive!)
and then using the result of the first call, we read some more data still asyncronously, and a the end we want
to have the result in a single `Future`, we don't want to have `Future[Future[...]]`

This is why we need `flatMap`, to combine or `flatten` together different container of the same
type and have only one at the end with the final result.

The second function `pure` is more obvius, it allows us to wrap a value inside the container,
every container will have a different way to do that, often in Scala is just apply,
for instance we have `Future(value)`, `List(value1, value2, ...)` , but some container has
differnt cases like `Option` with `None` and `Some(value)`.

If you are wondering what happened to the `map` method, remember that you can reproduce it
with `flatMap` and `pure`, for instance with Future

```
// we can rewrite
future.map(v => v.toString)
// with
future.flatMap(v => Future(v.toString))
```

## Yes, that's it

I'm sure that what I described so far is pretty familiar to everyone that has
worked a little bit with Scala, and looks very simple to anybody,
the thing is, this is what the scary Monads are, to summarize:

 - a Monad is a container that represents a behaviour 
 - a Monad is an interface that implements two functions, `flatMap` and `pure`

and that's it.

So don't be scared of using Monads, they are awasome, they allow you
to represent some common behaviour with a type, this give us some great properties: 

 - it works as documetation, everithime you see a specific type, you'll 
   know which behaviour to expect, for instance an asyncronous computation
 - the compiler will enforce the user of that value to handle that behaviour, 
   no more readin documents to know  what is going on, no more obscure Threads 
   runnin or null values to catch
 

