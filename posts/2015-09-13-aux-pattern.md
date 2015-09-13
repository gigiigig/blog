---
title: The Aux Pattern
subtitle: A short introduction to the `Aux` pattern
author: Luigi
---

Let's start saying that the `Aux` pattern is not a pattern,
is a technique used in every library that is doing some type level
programming that we need to use to overcome one Scala limitation.

Every time we do a type level computation in Scala we have a type alias defined inside 
another class/trait, let's see an example 

```
trait Foo[A] {
  type B
  def value: B
}
```

In this case for instance the result 
of our type level computation will be stored in `B`.

So let's define some instances:

```
implicit def fi = new Foo[Int] {
  type B = String
  val value = "Foo"
}
implicit def fs = new Foo[String] {
  type B = Boolean
  val value = false
}
```

Well, in this case we are not doing any real computation,
we are just changing the type of `B` depending on the input 
type `A` , that's enough to understand `Aux`.

Now in Scala we can use parameter dependent types to access
the type defined inside a class/trait (path dependent type)
so if we want to use our type `B` in a function, as a return type, we can do that:

```
  def foo[T](t: T)(implicit f: Foo[T]): f.B = f.value
  val res1: String = foo(2)
  val res2: Boolean = foo("")
```

In this example we see that we can change the return 
type of a function using dependent type and the implicit
resolution, now let's suppose that we want to use this 
type as type parameter in the next parameter, 
for instance to get the Monoid instance for that type: 

```
  import scalaz._, Scalaz._

  def foo[T](t: T)
            (implicit f: Foo[T], m: Monoid[f.B]): f.B = m.zero
```

We would like to do that, but unfortunately we get 

```
illegal dependent method type: parameter appears in the type of another parameter in the same section or an earlier one
```

Scala tells us that we can't use the dependent type in the same 
section, we can use it in the next parameters block or as a return type only.

Here is where our friend `Aux` is going to help,
let's define it:

```
  type Aux[A0, B0] = Foo[A0] { type B = B0  }
```

What we are doing here is defining a type
alias where `A0` is mapped to Foo `A` and `B0` is mapped to `type B`,
what I didn't understand at the beginning is that 
the relation `type B = B0` works both ways, 
so if we fix the type for `B` like with `type B = Boolean`,
`B0` will get this type too.

So now we can write this:

```
  def foo[T, R](t: T)(implicit f: Foo.Aux[T, R], m: Monoid[R]): R = m.zero 
  val res1: String = foo(2)
  val res2: Boolean = foo("")
```

The full example is here [Gist](https://gist.github.com/gigiigig/3cd104e8951b4432afd5)

That's it, basically `Aux` is just a way to extract the result of a type 
level computation, now let's have a look at a real world example,
the most common example that comes to my mind is shapeless Generic,

```
def length[T, R <: HList](t: T)
                         (implicit g: Generic.Aux[T, R],
                                   l: Length[R]): l.Out = l()

case class Foo(i: Int, s: String, b: Boolean)
val foo = Foo(1, "", false)

val res = length(foo)
println(s"res: ${Nat.toInt(res)}")

// res: 3
```

In this case `Generic.Aux` will extract the generic representation of
`T` inside `R` and in this way we can use it to resolve 
the `Length` type class that we use to get the length of the `Hlist`.

### Conclusion

`Aux` is a very simple technique that is mandatory 
when you start doing some type level programming,
probably is that simple that nobody needed to write 
a tutorial about it so far, but because it took to me 
some effort to understand it, maybe that can help somebody.

