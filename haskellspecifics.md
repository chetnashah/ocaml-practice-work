
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

