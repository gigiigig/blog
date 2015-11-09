---
title: Introduction
author: Luigi
date: 1015-10-19 
---

##Introduction 

Let's start this series of blog posts describing what we are
going to talk about and also why, I mean why should we bother with 
this stuff? 

I think the definition `Type Level Programming (TPL)`is quite self explanatory,
simply means doing computations at type level, but probably for people like me, coming from Java, that might sound a bit crazy at the beginning.

First thing, I'd suggest to Java developers to try to forget what
you know about types, and accept the idea that in Scala you can do much more than you used to in Java. 

##Why

Simple, because it's fun!

Well that too, but the important part to me here is to understand 
that   
_**stronger is your type system more flexibility you get**_    
it could sound a bit a counterintuitive, but stay with me for a minute.
One of the reasons why many *dynamic* developers criticize Java 
is that adding types you lose a lot of flexibility, this is partially true,
but the great thing is, if add more power to your type system, 
you get back this flexibility, but with a big advantage!

The advantage is that you can do *dynamic* like things at compile time!
This is where you need type level computation, if you can
compute types, you get an incredible flexibility, without losing
the correctness that you get with a static language.

Let's stop the ranting now and see an example to understand what 
I mean with that, just try to focus on the advantages more than
the implementation for now, we'll go into the details soon ;)
I chose this example mainly because that was the one that amazed 
me first, and made me start looking into TPL.

This code is taken from the framework *Spray*, part of the 
routing DSL that it offers.

```
parameters('color, 'count.as[Int]) { 
  (color, count) => ... 
}
parameters('color, 'bgColor.?, 'count.as[Int]) { 
  (color, bgColor, count) => ... 
}
```

The code shows the `parameters` directive, it's an http directive that we use
to get the parameter from the request in Spray. 
What we do is pass a list of parameters in the first parameters block,
and then we pass a function that uses this parameters in the second.

Now maybe this doesn't seem special at a first look, 
but let's make the types explicit: 

```
parameters('color, 'count.as[Int]) { 
  (color: String, count: Int) => ... 
}
parameters('color, 'bgColor.?, 'count.as[Int]) { 
  (color: String, bgColor: Option[String], count: Int) => ... 
}
```

Looking at this example we can see that 

- we get a function that takes 
  the same number of parameters that we ask, and we are not using pattern
  matching on partial function, this is a total function  

- the parameters in the function have the type that we asked for  
  `'color => String`  
  `'bgColor.?' => Option[String]`  
  `'cound.as[Int] => Int`  

We can see now that we are computing 2 things here, the number 
of parameters that we take, and their types.
If you look at the code you'll see that `paramters` is not defined
with some crazy method overload, there is a type level computation
that is able to compute the right type for the function `f`.

I think this has an incredible value, things like this before 
were common only for dynamic languages, or we had to use reflection 
to do something similar in Java, but in Scala we can do this 
at compile time, and don't have to give up on correctness,
and this is a very good reason to do TLP in my opinion.

##Shapeless

When talking about TLP in Scala it is mandatory to mention Shapeless,
Shapeless is the library, created from Miles Sabin, 
that pushed the boundaries of what is possible to do in Scala with types,
many of the example that we are going to see at the end are based on Shapeless,
and basically every library that is relying on TLP depends on Shapeless.

##How to read

The idea I have for this series is to cover before all the techniques 
the you need to know to do type level programming in Scala,
and then show some complete examples about how to apply them 
for real world use cases, so there isn't a particular order to
read the articles, feel free to jump directly to the ones
you feel useful for you.

##Help Me!

I'm not a TLP expert, writing this series is a way for me to 
revise all this concepts and to help other people to learn them,
however there might be errors, things that I misunderstood, 
or even English errors as it is not my native language, 
feel free to add comments here or open a pull request in GitHub,
the code of this website is open source!

Ok then, let's start!

