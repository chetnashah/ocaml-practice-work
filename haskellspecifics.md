

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

Type constructors(return) map types(objects) to different category (a -> Maybe a)
but we also have to map hom-set to different category ( (a->b) -> (Maybe a -> Maybe b) )
which is where we make instance Functors of various types

Product types are not symmetric :
* (a,b) is not same as (b,a), type of earlier is a * b and that of latter is b * a

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

