---
title: Heterogeneous Lists 
author: Luigi
date: 2016-1-29 
---

Heterogeneous Lists, from now on HList, are a particular type of `List` 
that, instead of containing elements of the same type, 
can contain elements of different types preserving the type of every element.

The reason why we are talking about them is that to implement them in Scala
you need TLP, they are extremely useful in the real world and they will
help me to explain some important concept later.

An HList is conceptually similar to Tuple, it is a product type, the difference is that it doesn't have a specific size, 
in Scala we can have Tuples of N size up to 22, but they are implemented with 22 different types `Tuple2`-`Tuple22`, 
and then we have a special syntax to construct them `(1,"", false)`.

<!--This works well enough in many cases but it's a bit of problem when we -->
<!--want to define generic operations for tuples. -->

The other way to represent products in Scala are case classes, they are extremely 
useful to represent our data, however both tuples and case classes lack
of a way to deconstruct them at compile time, we can instead do that
with HList, we'll see in a future post how and why that's extremely useful,
for this post we are going to see how to create them.

The way an HList is defined is very similar to a `List`, it is a recursive data structure, 
where every element contains his value and the continuation, 
the main difference with List is that in this case we are going to construct 
the type of the HList along with the values. 

```
object foo extends App {                                                                                           
                                                                                                                   
  trait HList                                                                                                      
  trait HNil extends HList                                                                                         
  case object HNil extends HNil {                                                                                  
    def ::[H](h: H): H :: HNil = foo.::(h, HNil)                                                                   
  }                                                                                                                
  case class ::[H, T <: HList](h: H, t: T) extends HList { self =>                                                 
    def ::[H](h: H) = foo.::(h, self)                                                                              
  }                                                                                                                
                                                                                                                   
                                                                                                                   
  trait Print[L <: HList] {                                                                                        
    def apply(l: L): String                                                                                        
  }                                                                                                                
                                                                                                                   
  object Print {                                                                                                   
                                                                                                                   
    def apply[L <: HList](implicit p: Print[L]) = p                                                                
                                                                                                                   
    implicit val pnil: Print[HNil] = new Print[HNil] {                                                             
      def apply(l: HNil) = "HNil"                                                                                  
    }                                                                                                              
    implicit def pl[H, T <: HList](implicit pt: Print[T]): Print[H :: T] = new Print[H :: T] {                     
      def apply(l: H :: T) = s"(${l.h}:${l.h.getClass.getSimpleName}) :: " + pt(l.t)                               
    }                                                                                                              
  }                                                                                                                
                                                                                                                   
  implicit class HListOps[L <: HList](l: L) {                                                                      
    def print(implicit p: Print[L]) = p(l)                                                                         
  }                                                                                                                
                                                                                                                   
  /*                                                                                                               
    scala> import foo._                                                                                            
    import foo._                                                                                                   
                                                                                                                   
    scala> 1 :: 2 :: false :: HNil                                                                                 
    res0: foo.::[Int,foo.::[Int,foo.::[Boolean,foo.HNil]]] = ::(1,::(2,::(false,HNil)))                            
                                                                                                                 
    scala> res0.print                                                                                              
    res1: String = (1:Integer) :: (2:Integer) :: (false:Boolean) :: HNil                                           
  */                                                                                                               
}        
``` 


