---
title: Use Typeclasses for polymorphism
author: Luigi
date: 2016-10-29
---

Really, another article about typeclasses?
I know there are so many of them around that probably I could have avoided this one,
however writing a series about FP in Scala and skipping type classes would be weird,
and I'll try to keep it short.

I said in a previous post that one of the thing we should not inherit from OO is indeed *inheritance*
right? 
But we still need polymorphism right? Polymorphism means being able to call a function 
with different types, this is very useful, otherwise we'll have to copy and paste the same function over and over,
so these are few ways to do polymorphism: 

```
trait Printable {
  def printMe: String
}

class Foo extends Printable {
  override def printMe = "FOO"
}

class Bar extends Printable {
  override def printMe = "BAR"
}

def printObject(p: Printable): String = {
  s"The pbject is: ${o.printMe}"
}
```



