

Any thing that you give a name in haskell,
e.g. using let where,gets evaluated at most once(on demand)
and memoized for future usages.

Numerical types in haskell :
Integral : whole numbers only, two instances -> Integer and Int
Fractional or RealFrac - tional types
  Rational : values always specifed as ratio of two Integers e.g. n = n % 1
  Double   : double precision floating point numbers

Real : Integral + RealFrac

Num encompasses Real + Complex (respects Eq)
Real ecnompasses Real (respects Eq, Ord)


Haskell patternmatching(case expressions) and guards:
Pattern matching is useful for structural induction,
Case of would mostly be used when you want to branch depending
on structure/types(matching on structures)
etc. instead of boolean conditions.
e.g.

```
case mapping of
  Constant v -> const v
  Function f -> map f
```

When you are branching based on boolean conditions, e.g. by if, else, elseif
guards are useful,(mostly matching on values giving booleans etc.) e.g.

```
abs n
  | n < 0 = -n
  | otherwise = n
```

Both can used also in conjunction and complement each other,
for e.g. you can first make decisions depending on structure,
then depending on values or vice versa

Using where :
When you have repeated calculations in guard, it is good idea to
give them a name before doing guards.

e.g.
```
    bmiTell :: (RealFloat a) => a -> a -> String
    bmiTell weight height
    	    | bmi <= 18.5 = "You're underweight, you emo, you!"
	    | bmi <= 25.0 = "You're supposedly normal"
	    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
	    | otherwise   = "You're a whale, congratulations!"
	    where bmi = weight / height ^ 2
```

What would you call something takes types and makes new types ?
A type constructor
Maybe is a type constructor, Maybe Int is a type

What is referential transperency ?
whenever you have an equality of expression,
you can memoize lhs for its result in a table instead of doing actual computation,
in other words, same input always give same output/pure functions


What is a discrete category ?
A category with objects only containing identity arrows, no other arrows.
Such a category is structureless like a set.

Any other category with some arrows will have some sort of structure.
Structure intuition is object, arrow direction and arrow composition(This is what laws take care of)
You can squeeze or squish during transformation, but can't break structure(like group homomorphisms)

A faithful functor is injective on hom-sets
A fully faithful functor is isomorphism on hom-sets
A constant functor is ...
An endofunctor is functor mapping structure into same category
The Category Cat is where categories are objects and functors are morphisms

Haskell types declared using Data should be in capital case.
Haskell types declared using type are just type aliases

Type constructors(return) map types(objects) to different category (a -> Maybe a)
but we also have to map hom-set to different category ( (a->b) -> (Maybe a -> Maybe b) )
which is where we make instance Functors of various types

Some things act as both type and value constructors,
most common examples are :
Think of them as defined like :
```
data [a] = [] | a : [a]  -- note this will not work on repl etc.
```
[Int] is a case where [] is a type constructor
```
-- haskell style
Prelude> type Mylist = [Int]

-- Ocaml style (different style of type constructor)
# type mylist = int list
```
but [2] is the case where [] is a value constructor (Same in Ocaml)

Similarly (,) the tuple builder is also a both type and value constructor
```
--haskell style
Prelude> type Mytuple = (String, String)

-- Ocaml style (different type constructor)
# type mytuple = string * string
```
and ("hi", "jay") is an example of value construction by (,)

Product types are not symmetric :
* (a,b) is not same as (b,a), type of earlier is a * b and that of latter is b * a

Only values have types,
types have kinds,
etc. etc.

Sum types are not symmetric :
* Either a b is not same Either b a

Both above are symmetric upto isomorphism.
(Meaning you can define functions, which can convert to other)

Enum type (e.g. Nothing) are equivalent to (), coz they can be created out of thin air,
kind of unit in algebra of types

Here is a nice example in algebra of types:
l(a) = 1 + a * l(a)
is equivalent to (Cons is product constructur, Nil is unit, | is sum constructor)
data List a = Nil | Cons a (List a)

Solving for l(a) is
l(a) = 1/(1-a)
which is geometric sequence :
l(a) = 1 + a + a*a + a*a*a + ... Inf

In haskell, data keyword is used for defining new types(unlike type in Ocaml)
In haskell, type keyword is used for type aliases
In haskell, newType keyword is like data with:
   only have single constructor taking single argument, strict value constructor


(Unnamed)product types with haskell
```haskell
data Config = Config String String Bool -- where first string is username,
     	      	     	    	   	-- second string is localhost
					-- third bool is isSuperUser
```

Constructor Config on rhs of "=" is promoted as a function with following
signature :
Config :: String -> String -> Bool -> Config

Named product types (records)
```haskell
data Config = Config {
     userName :: String,
     localHost :: String,
     isSuperUser :: Bool
}
```


Same Constructor Config on rhs of "=" is promoted as a function with following
signature :
Config :: String -> String -> Bool -> Config

```haskell
data Person {
     firstName :: String,
     lastName :: String,
     age :: Int,
     height :: Float,
     phoneNumber :: String
} deriving (Show)
```


Sum types :
* Enums (constructors only)
```haskell
data Bool = False | True
```

* Variants (Constructors with type arguments)
```haskell
-- sum of products
data Shape = Circle Float Float Float
     	   | Rectangle Float Float Float Float
```

* TypeClasses 101
A typeclass is sort of interface that defines some behaviour
If a type is part of a typeclass, that means that it
supports and implements the behaviour the typeclass describes.

Some examples of typeclasses are :
EQ : support equality checking
SHOW : supports string representation
ORD : supports ordering
READ : supports readability of given type from string
ENUM : supports enumerability or can be listed e.g. Bool, Char, Int
Bounded : members have an upper and lower bound.
Num : Its members have property of being able to act like numbers
