---
title: Separate data and functions
author: Luigi
date: 2016-09-02
---

It is a very common practice in OO to put together data and functionalities in the same
class, for instance:

```
case class Person(name: String, surname: String, age: Int) {
  def print: String = s"$name $surname, age: $age"
}
```

This seems to be the obvious thing to do, when we write functions that access the class fields,
we just put them inside the class itself, this looks fine and is the standard practice in OO,
this however is a very bad practice for a good number of reason.

It is very common when we work in a big project to have different modules and often we want to
share our model definitions between our modules, the entities that represent our business model
are indeed often the same for every part of the project, what changes between the different modules is the logic,
so what we do is that we start to share our models, for instance in Scala if we have an sbt multi-project,
we can create a `models` project that we share, this is good because we want a consistent representation
of our data between different modules without copying that same classes everywhere,
the problem start when we put logic inside this models, every module has different requirements
and the models become monsters, full of functions that do similar things in different ways often reusing each other,
and at this point we can't move things around anymore, functions have dependencies on each other and on the model fields,
so trying to move something means moving a lot of code.

A much better approach is to totally *separate the model definition and the functions that use that data,
using classes only as data contianers and objects to contain functions that never access class fields,
the objects are for us basically just namespaces.*
Let's start with a simple refactoring of our `Person`:

```
  case class Person(name: String, surname: String, age: Int)

  object Person {
    def print(person: Person): String = s"${person.name} ${person.surname}, age: ${person.age}"
  }
```

This probably seems more verbose but has the big advantage the data and behaviours are not relate anymore,
and moving the print function around it's much simpler now, especially when you have some dependency to that function.

Maybe you are thinking that now however you have to repeat `person` every time you access a field and that is
verbose especially when you have many of them, well remember that in Scala you can import instances,
so we can rewrite this code like this:

```
  object Person {
    def print(person: Person): String = {
      import person._
      s"${name} ${surname}, age: ${age}"
    }
  }
```

Now we have a concise syntax again with all the advantages of splitting data from functions.

The example is still a bit too easy so let's develop it a little bit in order to make clear why this is really a better
approach, imagine we have to projects `p1` and `p2` that are using the class `Person` but that need to print
it with some more extra informations:

```
  case class Person(name: String, surname: String, age: Int) {

    // needed from "common" project
    def print: String = {
      s"$name $surname, age: $age"
    }

    // needed from "p1" project
    def printWithPhone(phone: String) = {
      print + ", phone: $phone"
    }

    // needed from "p2" project
    def printWithAddress(address: String) = {
      print + ", address: $address"
    }
  }
```

So this is what happens usually, all the functions needed for class person end up in the class itself,
and we start to create dependencies between them, after a while the class becomes a monster and
we want to move something that becomes very hard, even with these three methods if we want to move the method
`print` we'll have to move also the other, imagine when we have 100 methods.

Let's change this code to make it maintainable:

```
  // common
  case class Person(name: String, surname: String, age: Int)
  object Person {
    def print(person: Person): String = s"${person.name} ${person.surname}, age: ${person.age}"
  }

  // p1
  object PersonHelper {
    import Person._
    def printWithPhone(person: Person, phone: String) = {
      print(person) + ", phone: $phone"
    }
  }

  // p2
  object PersonHelper {
    import Person._
    def printWithAddress(person: Person, address: String) = {
      print(person) + ", address: $address"
    }
  }

```

Now things look much better, we a class Person that define the data, we have the companion object
with a standard print method that is not project specific,
and then every project defines his own helper (or Service, Rich, or whatever you like ..),
with all the specific method that you need, imagine now you want
to move the method print, all you have to do is just to change the imports and you are ready to go,
nothing else has to change, and that for me is awesome.

