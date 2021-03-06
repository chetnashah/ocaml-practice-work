
* What is binding ?
The process of giving a name/pattern matching to a value is binding.

Note: YOU CANNOT COMPARE FUNCTIONS IN ML, even thought they are first
class values.

(=) : 'a -> 'a -> bool, which will always do structural equality (not customizable), but throw on encountering a function or C data

Essential sublanguage of Ocaml (Everything is an expression):
```
expr ::= | c 	      	       // constant
     	 | (op)		       // parenthesized expression
	 | x		       // named object
	 | (e1, e2, .. en)	// tuples
     	 | C e
	 | e1 e2 e3 .. en	// function application
	 | fun x -> e		// lambdas or func definition(mul arg)
	 | function pi -> ei    // lambdas or function definition
	 | let x = e1 in e2	// let expressions
	 | match e0 with pi -> ei // match expressions
	 | if e1 then e2 else e3 // conditional expression
	 | while e1 do e2 done	 // conditional expression
	 | e1 :: e2    	  	 // lists
	 | Constr e1		 // custom type vales
	 | (e1: t1)		// parenthesized expression with type constraint
	 | begin e1 end		// parenthesized expression
	 | e1 infix-op e2
```
Expressions evaluate to values in a dynamic environment,
one enriched by name value bindings.
Values are syntactic subset of expressions :
```
v ::= c | (op) | (v1, v2, v3 ... vn)
      | C v
      | fun x -> e // lambdas(abstractions) are function values
```
Time travel and function closures :
A function value is really a data struct
that has two parts:
1. The code/function (obviously)
2. the environment that was current when function was
   defined(lexical scope). Which gives meaning to all the free
   variables of the function body.
Contrast a closure with an object which also has state/environment but many functions.

A function application :
- evaluates the code part of the closure
- in  the environ ment part of closure(which is relevant if free variables are present)
- extended to bind the function argument

With lexical scoping, well-typed programs are
guaranteed never to have any variables in the code
body other than function argument and variables bound by
closure environment

Recursion with auxillary functions:
sometimes we might need to use auxillary functions that hold
extra argument(which is initially empty) carrying state
of currently constructed answer structure
from matching on original input data structure,
the trick is to return the constructed structure at base case.

i.e. until the base case hits, the modified structure is present in
argument, on hitting base case,the modified strucuture is in
return value of function

global let delcarations :
let abc = 1;

local let declaratiosn :
let abc = 1 in expr;

moral of story : all functions have single argument

Ways to get around it: pass a n-tuple with n values
or
Currying: Take one argument and return a function that takes another argument
the returned function will be able to use the first argument in the environment.

If caller provides too few arguments, we get back a closure waiting for the
remaining arguments, This is also known as partial application.

ways to declare a function :

1) lambda way single argument (anonymous function) : function x -> x * x;
   lambda way with multi argument : "fun" keyword should be used
   lambda way also does pattern matching by the way,
   also the lambda way is an expression, meaning it returns a value (the lambda)
   
2) multi argument let (auto curried):
`let fn a b c = a+b+c`
which expands as
`let fn = function a -> function b -> function c -> a + b + c`

converting let's to lambdas :
```ocaml
let succ x = x + 1;
let succ = function x -> x + 1;
```
converting lambdas to lets:
```ocaml
let succ = function x -> x * x;;
let succ x = x * x;;
```
imp notes :
a function value ( a closure) can be passed around as a value or returned as a result in case of higher order functions.
One thing lambdas(anonymous) can't do by themselves is recursion, since a name must
be given to call itself, It will atleast need a let like e.g. scheme needs letrec.

Common misues of lambda: if you pass something like:
fun x -> f x (all this lambda does is to use it's argument with another function, which other function will automatically do)
instead just pass f.(unless some kind of laziness is involved)

higher order functions :
```ocaml
let h = function f -> function y -> (f y) + y;;
val h : (int -> int) -> int -> int = <fun> 
```
Why do functional languages don't need type annotation :
they are mostly analyzed by datum they are operating on
and all code is generic <T>

Function refactoring tip: keep functions only where you need them,
e.g. a function should be scoped inside other functions (e.g. with let etc) or inline lambdas, 
if it is not used elseWhere.

Type constraint :
programmer annotating the type helps compiler syntax is like following
`let add (x:int) (y:int) = x + y;;`

Pattern matching :
The reason pattern matching is useful because of
structural induction on the length of terms and constructors
pattern matching applies on values(also function values - just like in lambda calculus)
lamdba style directly starts with pattern matching without letting us specify params , in match style we let specify param along with fn and also pattern match with same name( here v)
```ocaml
let imply v = match v with
| (true,x) -> x
| (false, x) -> true
```
Pattern matching should be linear, that is no variable can occur more than
once inside a pattern e.g.

(Wrong Syntax)
```ocaml
let equal cc = match cc with
| (x,x) -> true  // this a big NO NO
| (x,y) -> false;;
error : the variable is bound several times
```
Pattern matching with "function" keyword lets you pattern match on params:
```ocaml
function p1 -> expr1 | p2 -> expr2 |.... | pn -> exprn;
```
also equivalent to
```ocaml
function exp -> match exp with | p1 -> expr1 | p2 -> expr2 |....| pn -> exprn 
```

Total functions and partial functions in case functions
defined using pattern matching
e.g.
`let (doubler: int -> int) = function x -> x * 2;;`
is total, i.e. is defined for all ints
`let pngpng = function p -> "pong"`
is total, i.e. is defined fo all arguments a'

Here is a function based on pattern matching that is non-total/partial
let pnp = function "ping" -> "pong
which is defined only for input "ping"
and will give Match_failure for all other cases

"new bindings/variable declarations happen in pattern matching
in case unbound variables are encountered in pattern (which is
by the way how let declarations work it seems)"

Pattern matching can happen also without using match or function keywords,
simply using 'let' which does bindings of unbound vars in pattern side of let
binding (usually useful for single case pattern matchings)
e.g. `let (x,y) = 2,3;;` // binds x to 2, and y to 3, env enriched on pattern matching
`let head :: 2 :: _ = [1;2;3];;` // binds head to 1


Naming a value being matched using "as" (Good style) :
During pattern matching, it is sometimes useful to name
part or all of pattern. (Also helps avoid reconstruction sometimes)
"as" keyword in pattern matching, is greedy and takes as many terms to left
as possible unless you put a bracket.
Let's say we have :
```ocaml
# let rec compress = function
  | a :: (b :: _ as t) -> if a = b then compress t else a :: compress t
  | smaller -> smaller;;
```
One would have thought t is bound to _ but instead,
Here t is bound to b :: _

Note rhs of a pattern match that happened correctly,
rhs is evaluated in environment enriched by the bindings done during pattern matching e.g.
```ocaml
let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l   (* inside rhs, after binding l is (cdr l)) *)
```

here is another example of comparing rationals:
```ocaml
let min_rat pr = match pr with
| ((_,0), p2) -> p2
| (p1, (_,0)) -> p1
| (((n1, d1) as r1),((n2, d2) as r2)) ->
    if (n1 * d2) < (n2 * d1) then r1 else r2;;
```

Evaluation order in chained let constructs :
e.g.
```ocaml
 let x = 1 in let y = x+2 in let z = y+3 in z;;
```
Note that here the order of evaluation is also left-to-right.
(It is always left-to-right in every chain of let constructs.)

Scoping in let expressions :
OCaml scoping rules are the usual ones, i.e., names refer to the nearest (innermost) definition. In the expression:
```ocaml
let v = e1 in e2
```
The variable v isn't visible (i.e., cannot be named) in e1. If (by chance) a variable of that name appears in e1, it must refer to some outer definition of (a different) v

Must do ex 3.2 in jason hickey's textbook as practice


 No, no overloading. 
 Overloading in languages with Hindley-Milner type system is problematic since it makes type inference undecidable.

Type information is not preserved at runtime, so you can't match on types or do things like that.

----------  Types and pattern matchin -------------------------
Base data types: int, float, char, string, bool and unit.

product types : tuples(unnamed components) and records(named components)
Sum types: Variants(qualified unions and enum)

Declaring new types :
type keyword is used
type name is always starts with lowercase letter
type constructor is always Uppercase letter optionally followed by "of" followed by arguments
type constructor that does not need any argument is also known as a constant constructor
and can be directly treated as values

list of a single type:
```ocaml
type pincodes = int list;;
type guests = int string;;
```
unnamed tuples/regular tuples :
```ocaml
type myType = int * string;;
type point3d = float * float * float;;
```

tuple/record(named tuples) types(product types) :
(Note: field names should be lower case)
```ocaml
type personalName = {
     name: string;
     initial: string option;
     lastName: string;
}
```
Note: In Ocaml, order of named tuples does not matter,
i.e. `{name: "hi"; initial: "K"; lastName: "Doe"}`
is same as
`{ initial: "K"; name: "hi"; lastName: "Doe"}`
or same as
`{ lastname: "Doe"; initial: "K"; name: "hi" }`

variant(Sum) types:
e.g.
```ocaml
type suit = Spades | Hearts | Diamonds | Clubs;; constant constructors/enums
type card =
| King of suit
| Queen of suit
| Knave of suit
| Minor_card of suit * int
| Trump of int
| Joker;;
```
Type constructors are useful in pattern matching :
people usually write an accompanying
tostring function for declared types like this(like for java POJOs)

```ocaml
let string_of_suit = function
| Spades -> "spades"
| Hearts -> "hearts"
| Diamonds -> "diamonds"
| Clubs -> "clubs"
```
You will often see recursive variants used for defining recursive data types
like trees etc :
```ocaml
type binary_tree =
 | Leaf of int
 | Tree of binary_tree * binary_tree
```
One can also have `parametrized/generics variants`: i.e. type parameter in variant
Usually represented by a tick foloowed by letter e.g. `'a` and this type 
parameter precedes type name in the definition
```ocaml
type 'a binary_tree =
 | Leaf of 'a
 | Tree of binary_tree * binary_tree
```


Since sum types and product types are algebraic data types
you can arbitrarily combine them to make new types
e.g.
1) sum of product of type
```ocaml
type foo =
| Nothing
| Pair of int * int
| Info of String * String
```

2)sum of sum of types
```ocaml
type Meeting = Hello | Hi
type Parting = Bye | GoodBye

type Greeting = Meeting | Greeting
```
3) product of product of types
```ocaml
//t1 = string * string option  * string
type personalName = {
     firstName : string;
     middleInitial : string option;
     lastName : string;
}
// t2 = string option * string * string * string
type addressInfo = {
     address : string option;
     state : string;
     city : string;
     zip : string;
}
// t3 = t1 * t2
type contactInfo = {
     perosnalName : personalName;
     adress: addressInfo;
}
```
4) product of sum of types
```ocaml
type suit = Clubs | Diamonds | Hearts | Spade
type face = One | Two | Three | ... | Jack | Queen | King | Ace
type cardPlayed = {
     suit: suit;
     face: face;
}
```
* Writing good toString functions for algebraic data types:

1. for variant/tagged union/discriminated unions/sum types, use pattern matching to write a
good toString function

e.g.
```ocaml
type animal = Cat of int
     	    | Dog of int
	    | Bear of String
	    | Fish

let animalPrinter (ani: animal) = match ani with
    		      	| Cat cn -> "Animal is a cat with num : " ^ (string_of_int cn)
			| Dog dn -> "Animal is a dog with nuum : " ^ (string_of_int dn)
			| Bear st -> "Animal is a bear with st : " ^ st
			| Fish -> "Animal is a fish with no other arg"
```
(* ^ is ocaml's way of joining strings together *)

2. for record/tuple(product types) pattern matching the pattern should look like a record/tuple
e.g/
```ocaml
# type state = {
     lcd: int; (* last computation done *)
     vpr: int; (* value printed on screen *)
  }

# let statePrinter (stt: state) = match stt with
    		       	      | { lcd = a; vpr = d; } -> "Found lcd with " ^ (string_of_int a) ^ " Found vpr with " ^ (string_of_int d)

# let sti = { lcd = 4; vpr = 0; };;

# statePrinter sti;;
```

-------- Subtyping and inclusion polymorphism in Ocaml(More in Ora book --
Subtyping makes it possible for an object of some type to be
considered and used as an object of other type.
Subtyping relation is only meaningful between objects,
it can only be expressed between objects.

Also unlike mainstream oo languages such as C++, Java, SmallTalk
subtyping and inheritance are different concepts in Ocaml.



-------------------------------------- Expressions -----------------------------------

Sequence Control Structure : 
A sequence of expression is also an expression, with the evaluation value of the last
expr in sequence.

i.e.  expr1; expr2; expr3; expr4; ... exprn;

is also an expr with value of evaluation of exprn, and yes all expr are evaluated in order



Conditinal Control Structure :
if expr1 then expr2 else expr3 , evaluates to expr2 if expr1 is true, otherwise expr3


Parenthesized (grouping) expressions (for sequence control structure) :
One can group togethr multiple expression (like the sequence control structure) with value being last of all expressions
using two ways ===> parentheses/begin end
i.e.
     let expr =  ( expr1; expr2; expr3; expr4; ... exprn )
OR
     let expr = begin expr1; expr2; expr3; expr4; ... exprn end


let binding is also an expression.
let binding is defined as let pattern = expr;;, this whole line is an expr,
so you can do:
```ocaml
let a =4 in
    let b = 5 in
    	let c = 2 in
	    a * b * c;;
```

Function definition is an expression :
e.g.
function x -> x * x;; is an expression
so you can do

let sq = function x -> x * x;;

bcoz let binding is nothing but let pattern = expr;;
Similarly function with multiple cases of pattern matchin is an expr


-------------Ocaml structures and modules ---------------
Module : ?

Structure : Structure packages together related definitions 
into a namespace.
(e.g.
definitions of data type and associated operations over 
that type e.g. stack, queue etc). and it is introduced by
syntax : 
```ocaml
module ModuleName [:t] = 
struct
  definitions 
end
```
Signature : Signature are interfaces for structures.
A signature specifies which components of structure are 
accessible from outside(can hide some) and with which type.
syntax :
```ocaml
module type SignatureName = sig 
  type specifications 
end
```
Modules and files :
.ml and .mli files are automatically wrapped in 
struct and sig respectively e.g.
If myfile.ml has contents DM  [and myfile.mli has contents DS]
then OCaml compiler behaves essentially as though: 
```ocaml
module Myfile [: sig DS end] = 
struct
  DM
end
```
Note:  no struct or sig keywords, no naming of module or module type 
Note:  comments to client in .mli
, comments to implementers in .ml



---------------Understanding let in terms of scheme-------------
1.) let without "in"
e.g.
let x = 1;;
let y = 2;;
let z = x + y;;

These are global binding of general form let identifier = expr

2.) let with "in" or let with a body,
These let expressions are of the general form:
----> let id = exp1 in exp2
----> let id = bound-term-expr in body-expr
Hete exp1 is called let-bound term & Here exp2 is called the body of let expression
. and id=exp1 is only valid within exp2 i.e. the body.

Binding is static(lexical) meaning that value is determined by nearest enclosing definition in program text.

Evaluation rules: let-bound term i.e. expr1(let-bound-term) is always evaluated first and its value is bound to id before going into evaluating expr2(let-body)

Shadowing: newest lexical definition is available:
e.g. try following out
```ocaml
#let x = 7 in
 let y =
     let x = 2 in
     	 x + 1 // 2 is shadowing 7
 in
 x + y;;// 7 in effect.
```
will give you 10

Another example:
```ocaml
let x = 1;; // global id x
// 1
let z = // glbal id z
    let x = x + x in
    let x = x + x in // sequential binding like let*
    	x + x;;
// z= 8

x;;
// 1
```

* Every value binding and every function binding is an act of pattern matching.
e.g. let identifier = expression is just a special case of
let pattern = expression. where bindings are done.

* Every function in ML takes exactly one argument.
let p1 p2 .. pn = expression

--------------------lambdas in Ocaml------------------------
functions are first class values in functional programming language
meaning they/lambdas can be given a name.

e.g. let increment = function i -> i + 1;;

for which the scheme equivalent would have been
(define increment (lambda (x) (+ 1 x)))

There is sugar for defining functions without using lambda everytime:
e.g.
let increment i = i + 1;;

for which scheme equivalent would have been
(define (increment x) (+ 1 x))

Function application: Function application is so universal in fp langs
that instead of using syntax like f(x) the syntax for function application
is just a 'space' so it is "f x" in Ocaml.

-----------------------Multi argument functions ---------------------

Single argument functions are simple. You just give them the argument
and they rewrite the term that is the body, evaluate it and return the
value.

The way multi argument functions are designed is that given a single
argument, they return a functioon that takes rest of arguments until
all arguments are given at which point the body-expression is
evaluated and returned.

There are many ways to write this:
1.) lambda form
`# let sum = fun i j -> i + j;;`
val sum : int -> int -> int // this type expr associates to right. 

Note: this is same as :
`# let sum = (fun i -> (fun j -> i + j));;`
So all multi argument functions can be converted into single arg functions

2.) sugared let form
`# let sum i j = i + j;;`

Another useful use of multi argument functions is partial application
e.g.
let incr = sum 1;;
// since sum with incomplete numkber of arguments returns a function,
// to which we gave the name increment!

Things to remember:
** functions can be arbitrarily nested.
** functions can be passed as arguments to other functions
For higher order functions that take functions as arguments
you'll notice explicit parentheses in higher order fn type definition
** functions can be returned from functions.

----------------Scoping rules of functions ----------------------

Static binding/lexical scoping:
To drive the point home :
The value of a variable is determined by code in which a function
is defined -- not by the code in which a function is evaluated.

If function has free variables when defined, it encloses
text environment during the time of definition.

Here is a concrete example:

let i = 5;;
let addi j = i + j;; // is a free variable and is enclosed with 5.
let i = 7;; we shadowed i's value
addi 3;;// value used is the one enclosed when addi was defined i.e 5
-: val = 8

----------------------Labeled parameters and arguments------------
One often gets confused between parameters and arguments.
One good way to remember is Klingon Style taken from sjbaker's site:
Klingon function calls do not have parameters, they have arguments
and they always WIN THEM.

So function calls have arguments.
& function definitions have formal parameters.

Ocaml allows functions to have labeled and optional parameters.

Labeled parameters are specified with syntax ~label: pattern.
Labeled argumets have similar syntax ~label: expression.

e.g.
```ocaml
# let f ~x:i ~y:j = i - j;; //x and y are labels, i & j are labeled parameters
val f: x:int -> y:int -> int = <fun>
```

// labeled arguments passed to function f
```ocaml
# f ~y:1 ~x:2 ;;
-: int = 1
```
// NOte: order does not matter in case of labeled arguments
// passing a single labeled argument
```ocaml
# f ~y:1;;
-: x:int -> int = <fun>
```
** Many a times you would want to be label names same as parameter
names when defining a function, so there is a ocaml shorthand ~label

e.g.
```ocaml
# let f ~x ~y = x - y;;
```
** similarly argument ~label represents both the label and argument

e.g.
```ocaml
# let y = 1 in
  let x = 2 in
      f ~y ~x;;
```

Optional parameters can be specified with ?
e.g.
```ocaml
# let g ?(x = 1) y = x - y;;
val g: ?x:int -> int = <fun>
```
arguments:
```ocaml
# g 1;; // y is interpreted as 1

# g ~x:3 4;; // to use optional argument, it should always be labeled.
```
Rules of thumb to follow for optional and labeled arguments:
* optional parameter should always be followed by non optional parameter. This makes definition unambiguous to the compiler.
This is because it isn't possible to know when an optional
argument has been omitted.
Try out plyaing wiht
```
# let f ~x ?(y = 1) = x - y;;
```

* order of labeled args does not matter, except when label occurs more than once(wtf?)
```ocaml
# let h ~x:i ~x:j ?(y = 1) ~z =
   i*1000 + j*100 + y*10 + z;;

# h ~z:3 ~x:4 ~y:5 ~x:6;;
  int = 4653
```
* Labeled and optional arguments should be specified explicitly for
higher order functions.
Always annotate types of input/output functions in higher order fns
e.g.
```ocaml
# let apply (g: ?x:int -> int -> int) = g ~x:1 2 + 3;;
```
---------------------Pattern matching semantics----------------------------
```ocaml
match exp0 with
  | pat1 -> expr1
  | pat2 -> expr2
  | pat3 -> expr3
```
Operational semantics:
            First always exp0 is evaluated, then it is matched top to bottom,
            left to right with patterns. A pattern is an expression made of
            constants and variables. When matching against a constant, same
            constant should be found on the other side else mathching fails
            and variable pattern matching always succeeds with accompanying
            binding.
            Suppose pati matches, only then expri is evaluated and rewritten
            as result of whole match expression.

Pattern matching in functions :
Ocaml provides the keyword function (instead of fun) for single argument pattern
matching.
e.g.
let rec fib = function
 | 0 -> 0
 | 1 -> 1
 | i -> fib (i-1) + fib(i-2)

PAtterns are everywhere :
let pattern = expression
let identifier pattern patttern ... pattern = expression
fun pattern -> expression
function pattern -> expression

Note: pattern matching cannot have function values:
e.g. following throws error:
match (fun i -> i + 1) with
  (fun i -> i + 1) -> true;;

Patterns primarily are made of combination of constants, variables and costructors

-----------------------------type systems and schemes---------------------

Any good language with a sound type system will have three kind of types:
0. base types like int, char, bool etc.
and (for making compound types)
1. each of types (records, structs, product types)
2. one of types (enums, Sum types)
3. refer other types (including itself) as type parameters for polymorphism.
4. Possibly subtyping from existing types.

An interesting compound type is int list, which uses 1, 2 and 3.

lets consider a function like : fn x => x;
How polymorphic is it in terms of types? very!
this identity function has infinitely many types e.g. int -> int, string -> string, float -> float ... etc
i.e. one for each choice of type parameter
There is a pattern here: which is captured by notion of a type scheme.
A type scheme is a type expression involving one or more type variables
A type variable stands for an unknown but arbitrary type expression.
Type variables are written 'a (alpha), 'b (beta), 'c (gamma)

E.g. type scheme: 'a -> 'a
has instances int->int, string->string, (int*int)->(int*int)
But it does not have instances int->string,

However type scheme: 'a -> 'b
has both possible instances string -> string and int -> string

Type schemes are used to express polymorphic behaviour of functions.
e.g. fn (x,y) => x
will have type scheme 'a -> 'b -> 'a

It is remarkable in ML that every expression has a principal type scheme.
That there is almost always a best or most general way to infer
types for expressions that maximises generality and hence flexibility.

How is this achieved ?
Type inference is a process of constraint satisfaction.
First the expression determines a set of equations governing
relationships among types of its subexpressions.

Constraint generation: if function is applied to an argument,
then a constraint equating the domain type of function with type
of argument is generated.

This constraint satisfaction is also known as unification, and
solved using a process similar to gaussian elimination.

Solution of 3 types:
1. overconstrained : no solution, type error.
2. underconstrained: many solutions, ambiguous(overloading) or polymorphic
3. uniquely determined: prcisely one solution


-----------------------Data structures and polymorphism---------------------
ML languages provide parametric polymorphism.
Types and expressions can be parametrized by type variables.
Type variables are lowercase identifiers with quote in front of them.
Alpha ('a) , Beta ('b) etc.

There may be times when compiler infers a polymorhpic type where
one wasn't intended. In this case types can be constrained with
syntax (s : type), where s can be pattern or expression.

e.g.
```ocaml
#let id_int (i: int) = i;;
val id_int : int -> int = <fun>
```
Above was a constraint on parameter/argument type of a function,
If you want constraint for return type of function,
it can be put after last parameter.

e.g.
```ocaml
#let do_if b i j : int = if b then i else j;;
val do_if : bool -> int -> int -> int = <fun>
```
if we had not specified int at the end the type of expression would have
been
do_if : bool -> 'a -> 'a -> 'a = <fun>

** Value Restriction

For an expression to be truly polymorphic it must be an immutable value.
which means
1) it is already fully evaluated
2) it can't be modified by assignment

A type variable '_a (the actual letter doesn't matter, the crucial thing is the underscore) is a so called weak type variable. This is a variable that cannot be generalized, i.e., it can be substituted with only one concrete type. It is like a mutable value, but in the realm of types.

A type denoted with a weak type variable '_a is not included in a type that is denoted with a generic type variable. Moreover, it even can't escape the compilation unit, and should be either hidden or concretized.

Weak type variables are created when an expression is not a pure value (that is defined syntactically). Usually, it is either a function application, or an abstraction. It is usually possible, to get rid of weak type variables by doing a so called eta-expansion, when you substitute a partially applied function to a normal function application by enumerating all function arguments
i.e. id3 = ( fun x -> id2 x)

The general point of value restriction is that mutable values are not
polymorphic. In addition, function applications are not polymorphic
because function might create mutable value or perform assignment.
Thus even for simple applications like id id where it is obvious that
no assignments are performed.

** Eta expansion

Given an expression e of function type
Eta Expansion : e is same as fn z => e z, where z does not appear in e
Eta contraction fn z => e z is same as e, where z does not appear in e

Eta expansion looks like putting into a thunk.
Eta contraction looks like taking out of a thunk.

Eta expansion is a syntactic change used to work around value restriction

** Overloading:

Adhoc polymorphism like overloading allows functions to have same name
  with different parameter types, when function application is invoked
  compiler selects which call to invoked depending on type of arguments
  OCAML DOES NOT PROVIDE OVERLOADING. It is hard to provide type inference
  and overloading at the same time.

** Subtype polymorphism and dynamic method dispatch:

Subtype polymorphism and dynamic method dispatch are concepts used
extensively in OO programs. Both kinds of polymorphism are fully supported
in Ocaml.

Tuples and lists:

They are parametrized types, or higher kinded types or types which
take other types to make a concrete type.
e.g. list itself is not a concrete type,
list int or list string is concrete type.
list 'a is a list of any possible type 'a but list items must all be of
type 'a unlike in scheme, where u can have a list of items of different types.

Lists and tuples can be desconstructed by pattern matching through
constructors (,) and (::)

Function operating on lists can also be polymorphic e.g. (map, reduce etc.)
e.g. they have 'a list in their signatures
('a -> 'b) -> 'a list -> 'b list = <fun>

Parametrized types:
As we know there are some types(List, Stack, Queue, Tree)
can be parametrized by other types e.g. (Int, String, Car) to form
a more concrete type i.e. List<String>, Stack<Int>..

Many a times we would like container types to be parametrized but it
can be much more general than that also.

------------------------------Tail recursion--------------------------

Recursion : A function is recursive if it calls itself in some way.
A backbone for looping and iteration in functional programming.

Tail Recursion : A specific kind of recursion where value produced by
recursive call is directly returned by caller without further computation.
e.g. consider following two implementations :


non tail recursive (multiplaction happens after the structurally smaller
  recursive value is computed)

let rec fact n =
    if n = 0
       1
    else
      fact (n-1) * n;; // * happens after

Tail recursive implementation (result is directly returned betn all calls):
uses standard trick, where an extra argument often called acc is used
to collect result of computation.

let rec fact2 n =
  let rec loop accum i =        // the computation is collected in accum
    if i = 0 then
      accum
    else
      loop (i * accum) (i-1)   // we are doing computation when passing args 
  in                           // using accumulator, instead after returning
    loop 1 n;;

So why tail recursion? isn't the first style easier to reaad?
Bcoz tail recursion can be optimized effectively by compiler.
One can remove all the intermediate stacks because the computation
has already been performed in the accumulator, by the time the
deepest call/stack is reached. There is no need to keep around intermediate
stacks.

Lists and tail recursion :
Lists need tail recursion, since we are iterating over list primarily using
recursion, the stack space would otherwise be linear in the length of list.

Not only would that be slow but it would also man that list length is limited
by maximum stack size.

Let's see the normal implementation of map :
let rec map f = function
  h :: t -> f h :: map f t  // non tail-rerusive since :: happens after map
 |[] -> []

Tail recursive style implementation of map :

let rec rev accum = function
  h :: t -> rev (h :: accum) t
 |[] -> accum

let rec rev_map f accum = function
  h :: t -> rev_map f (f h :: accum) t
 |[] -> accum

let map f l = rev [] (rev_map f [] l);;

Traversiong list twice, once with rev_map and once with rev, is often
faster than non-tail-recursive implementation.

Make sure you do exercises in Ch. 5

All case expressions in match exp1 with ... should have the same type.
Although it seems like obvious thing try guessing type signature of following:

let nth i (x,y,z) =
 match i with
   1 -> x
  |2 -> y
  |3 -> z
  |_ -> raise (Invalid_argument "nth")

-----------------------------Lazy evaluation ----------------------------

It is possible to simulate lazy evaluation by using thunks. A thunk is a function of the form fun () -> .... It takes advantage of the fact that the body of a function is not evaluated when the function is defined, but only when it is applied. Thus function bodies are evaluated lazily.

e.g. let f = fun () -> List.hd [];;
val f: unit -> 'a = <fun>

means doesn't fail immediately , but only when called
f ();;
Exception: Failure "hd";;

Other way to write thunk is
let f () = 10 / 0;;
val f: unit -> 'a = <fun>


-----------------------Unions/tagged unions/variants----------------------------


A disjoint union or union for short, represent union of several different
types, where each of the parts is given a unique explicit name(Constructor).

Ocaml allows exact union types and open union types.

Here is syntax for exact union types:

type typename =
| Identifier1 of type1
| Identifier2 of type2
| Identifier3 of type3
.
.
.
| Identifiern of typen

The constructor name "must" be capitalized. The part "of typen" is optional
in which case it will be unit.

Here is a useful example that defines a numeric type
that is "either" a int with name Integer, "or" a float with name Real
"or" a canonical Zero.
The or is highlighted for the fact that it is a disjoint union.
```ocaml
# type number =
Zero
| Integer of int
| Real of float;;
```
How to construct values of union type?
Just tag it with Constructor

e.g.
```ocaml
#let z = Integer 1;;
```
Note: Patterns also use constructors, remember patterns are combinations
of patterns, constants and Constructors.

Union types are necessary for cases when we want to write recursive
pattern matching but sub term may be one of the types in union types

Which is to say that recursive Union types are even more interesting.
And they model tree like structures. Which also makes it really
easy to work with trees/ recursive grammars in general.

This combination of succintly specifying recursive data types with union
along with pattern matching, makes working with recursive structures
a breeze.

Variants can help you specify recursive structures
e.g.
datatype intList = Nil | Cons of int * intList;;

But we are stuck here with a Container type list of single type int.
We wish to generalize Container type List over all possible item types
e.g. List of String, List of Ints, List of Cars, i.e. a type variable

And hence was born the need for Parametrized variants
or variants that can have a type parameter/ type variable 'a;

e.g. 
```ocaml
type 'a genericlist = Nil | Cons of 'a * 'a genericlist;;
```
A parameterized datatype is an example of a parameterized type constructor: a function that takes in parameters and gives back a type. Other languages have parameterized type constructors. For example, in Java you can declare a parameterized class.
```java
class List<T> {  //T is the type variable
  T head;
  List <T> tail;
  ...
}
```

Let's go along the same lines and define a generic binary tree,
where each node is either a leaf or has two child subtrees.
How do I define my own parametrized variant: =>
```ocaml
# type 'a tree =
  Node of 'a * 'a tree * 'a tree
 |Leaf;;
```
If the constructor requires the value of tuple type it is a good idea
to put it in parentheses.
e.g.
```ocaml
let kk = Node (1, Leaf, Leaf);;
```
Multiple type parameters : let's say you want something to be generic
not only on a single type parameter, but on two type parameters,
e.g. like a dictionary. You might have done Java, then you would know
`HashMap<K,V>` has two type variables `K` and `V`.
In ML, multiple type parameters are written between parentheses,
and seperated by commas.
i.e.
```ocaml
  type ('a, 'b) xxx = { aaa: 'a; bbb: 'b; ccc: int; }
```
Question: We can have parametrized types, but can we have parametrized
functions ?

-------------------------Open & Closed union types-----------------------
The second union type different from exact union type is open,
i.e. subsequent definitions may add more cases to the type.
Also known as Polymorphic variants, don't confuse them with
parametrized variants.

Syntax is similar to union types, but constructor names
are prefixed with back-quote (`)
and type deifinition is enclosed in [> ...] brackets.

Open types will often need an _ in definition alson
```ocaml
type color = Red | Black;;
let typeprinteropen = function
| `Red -> "Hi color"
| `None -> "found None"
| _ -> "What is this ?";;
val typeprinteropen : [> `None | `Red ] -> key = <fun>
```
Otherwise they result in Closed union type definitons :
```ocaml
let typeprinter = function
| `Red -> "Hi true"
| `None -> "found none"
;;
val typeprinter : [< `None | `Red ] -> key = <fun>  
```
Closed Union type :
> = specified cases and more.. OpenUnion
< = specified cases only. ClosedUnion

Type definition for open types:
Writing a simple type definition motivated from above 
e.g.
type mixedColor = [> `Red | `None ];;
does not work and says the variable 'a is unbound

This is because actually any type constructor not explicitly mentioned
is also a part of the type e.g. `Zero
Type theoretically, any function defined over open type,
must be polymorphic over unspecified cases also.

Technically, this amounts to same thing as saying open type
is some type 'a that includes at least cases specified in definition
and more. So we must write type variable explicitly

type 'a mixedColor = [> `Red | `None ] as 'a;;
Note the output has written constraint :
type 'a mixedColor = 'a constraint 'a = [> `None | `Red ] 

The constraint form is also written as
```ocaml
let (zero: a' mixedColor) = `Zero;;
val zero : [> `None | `Red | `Zero ] = `Zero 
```

#### Need for polymorphic variants
Also it should be said polymorphic constructors.

The fact that every constructor is assigned to a unique type when defined and used. Even if the same name appears in the definition of multiple types, the constructor itself belongs to only one type. Therefore, one cannot decide that a given constructor belongs to multiple types, or consider a value of some type to belong to some other type with more constructors.

That is, a variant tag does not belong to any type in particular.

e.g.
```ocaml
type animal = Cat | Dog
type flower = Rose | Tulip

let string_of_animal_or_flower x = match x with
  | Rose -> "rose"
  | Tulip -> "tulip"
  | Dog -> "dog"
  | Cat -> "cat"

// Error: This variant pattern is expected to have
// type flower. The constructor Dog does not belong to type flower
```

Here we see that `type flower_or_animal` with all four constructors will not 
be created on the fly, and we will see type error.

Similarly, error will also be thrown when you try to mix values of both types
in a list. e.g.
```ocaml
let a = [Dog; Cat; Rose; Tulip;];; // throws error 
```

To fix this,you can use polymorphic variant/constructors which have a leading
backtick e.g. 
```ocaml
`Dog
```

Solution e.g.
```ocaml
// Below constructors exist out of a type
let string_of_flower_or_animal x = match x with
  | `Rose -> "rose"
  | `Tulip -> "tulip"
  | `Dog -> "dog"
  | `Cat -> "cat"

let j = [`Rose; `Tulip; `Dog; `Cat];;
```

Upper and lower bounds.

---------------------------Reference Cell and side effects-----------------

Principal tool is reference cell.
Which can be viewed as kind of box. Box always holds a value,
but contents of box can be replaced by assignments
A ref is a record type with a single mutable field called content.s
Primary operations

1. Allocation (create reference cell)
```ocaml
   val ref: 'a -> 'a ref // allocation operations return ref of type passed
```
2. Assignment (Change reference cell contents)
```ocaml
   val (:=) : 'a ref -> 'a -> unit // assignment operations do their work on the 
   storage and don't return anything so are usually followed by a ';'
```
3. Dereferencing (Get value inside reference cell)
```ocaml
   val (!) : 'a ref -> 'a // dereference operations remove ref of the type passed
```
Uses in one example:
```ocaml
let flag = ref false;;
flag := (not !flag);; // toggle flag contents and assign back
```
Pointers and mutable field assignment,

Any record that has a mutable field `<-` is used to assign
value to the mutable field
```ocaml
type tt = { mutable mf: int };; (* note: mutable keyword goes b4 field name *)
let t1 = { mf = 1 };;
t1.mf <- 99;;    (* changing the value of mutable field *)
```

Why imperative mutability?
Sometimes for algorithms, I/O

You can make your own types which are refs by suffixing
existing type with ref

Implementation is also simple
```ocaml
type 'a ref = { mutable contents: 'a };;

let ref x = { contents = x };;
val ref: 'a -> 'a ref = <fun>

let (!) r = r.contents;;
val ! : 'a ref -> 'a = <fun>

let (:=) x b = x.contents <- b;;
val (:=) :: 'a ref -> 'a -> unit = <fun>
```

e.g.
```ocaml
type intboxes = int ref;; // in types ref is written in end
type intarray = (int -> int) ref;;
```
you can also have ref of compound types
e.g. 
```ocaml
let myarr = ref (fun n -> 0);; // in values ref is written at start
```
Value restriction says that polymorphism should be restricted to
immutable values only.
A function application is not a value and mutable reference cell
is not a value, by this definition they are not truly polymorphic
as `'_a` indicate.

Also cyclic data structures(e.g. circular doubly linked list)
need imperativeness, ask why?

Here is an excerpt from the haskell mailing list :

Immutability and cyclic data structures do not mix very well at all.
"Updating" an immutable structure of course really means generating a
new structure.  However, because of immutability any parts that do not
change can be shared between the old and new structures.  The parts
the must be rebuilt are only those nodes from which the updated part
is reachable.  Typically, with acyclic data structures (i.e. trees),
this part that must be updated is small, and large parts of the
structure remain unchanged and can be shared between the old and new
structures.  However, with cyclic data structures, typically every
part of the structure is reachable from every other part --- hence,
any update necessitates rebuilding the entire structure.

Another problem with cyclic data structures is that one often cannot
perform operations such as "map" without losing all the sharing.

There are solutions to this but you're right that they tend to require
a fair bit of background to understand.  The simplest way to proceed
is to assign unique identifiers to nodes and store the data structure
implicitly, e.g. by storing in each node the identifiers of its
neighbors rather than actual references to them.  In essence this is
"simulating" the ability to have mutable pointers.

Memoization and mutability :
It is a good idea to memoize long time taking computation in a mutable
storage and return result if we already have it in a table,
Supposingly f is a pure function then so is memo f(referentially transparent)
It behaves like original function, except it trades space for time.
e.g. first call to fib 40 might take 15 secs but second call with same
arguments will be instantaneous.
Also the meomoizing logic is independent of functions it is called on
so can work on a wide class of functions
Some even say, Behind a function there might be a factory, a gear, a machine
or a lookup table, no-one knows. All you care about is same output for same
input.

Exception and effects:
ML has expressions with types, may have values and may have an effect.
By effect we mean some action that is not captured in the value.

Main examples of effects in ML :
Exceptions : Evaluation may be aborted by signaling exceptional condition.
Mutation : Storage is modified during expression evaluation.
I/O : Reading and writing from/to sources/sinks during evaluation.
Communication : Data may be sent/recvd from communication channels.

Exceptions and Raising:
Static violations are signalled by type checking errors( 3 + "3" )
Dynamic violations are signalled by raising exceptions. ( 3 / 0 )

Exceptions are first-class values in Ocaml, and can be stored
and manipulated like any other value and must begin with uppercase letter.

Exceptions can (optionally) take a parameter so they can carry
a value with them that can be extracted and examined if the
exception is caught. also known as value carrying 
```ocaml
    # exception Foo of string;;
    exception Foo of string
    # exception Bar of int;;
    exception Bar of int
    # exception Foobar of int * string;;
    exception Foobar of int * string
    # raise (Foo "yikes");;
    Exception: Foo "yikes".
    # raise (Bar 12);;
    Exception: Bar 12.
    # raise (Foobar (12,"yikes"));;
    Exception: Foobar (12, "yikes").
```
Exceptions are thrown using "raise" function. raise takes an exception
and does not return, rather it throws exception

One can write evaluation of exceptions as following
3 div 0 "raises" Division_by_zero

Exceptions need to have names to be able to be distinguished from
each other. e.g. Div vs Overflow

Match_failure is exception at run-time indicative of vialotion of pre
condition of invocation of function in program.
Also if no inexhaustive match warnings arise during type checking,
then exception Match can never raise during evaluation

hd [] "rasies" Match

Exception handlers and catching :
The other half complientary to raising exceptions is catching them with
exception handlers.
In general exception mechanisms are used to effect non-local transfers
of control.
By using an exception handler we may "catch" a raised exception
and continue evaluation along some other path.


Exception handling with "try expr with pattern-matching":
```ocaml
let safe_inverse n =
  try Some (1/n)
  with Division_by_zero -> None

let safe_list_find p l =
  try Some (List.find p l)
  with Not_found -> None
```

--------------------------------- Records and arrays -------------------------

Records types can be defined with type keyword and placing a ; seperated
list of labels and their types seperated with ":" inside curly brances
```ocaml
type db_entry = {
     name : string;
     age : int option;
}
```
Record values are initialized with using "=" in place of ":",
like following
```ocaml
let entry1 = {
    name = "Chetna";
    age = None
}
```
the interpreter automatically infers type based on fields. (entry1: db_entry)

Note: You cannot initialize a record value e.g. entry1 without declaring it's type first.
e.g. you have to declare type db_entry above first before making a record like entry1,
otherwise compiler throws error: "Unbound record field name"

What if I leave out one entry of the record like following :
```ocaml
let et2 = {
    name = "Kumar";
}
```
then the compiler will throw error :
Some record fields are undefined. So for initializing a record value
always gives all label values.

Ways to access record labels:
1. Dot Notation : use `recordname.fieldname`, e.g. `entry1.name`
2. Pattern matching : `let { name = n1; height = h1 } = entry1;;`
   then the values are captured in n1 and h1.

3. Functional record updates using with :
e.g.
```ocaml
let entry2 = { entry1 with age = Some 52 };
```
Tuples are just syntactic sugar for record with field names: 1, 2 ..etc
kind of like in other languages(e.g. python) lists are dicts with keys 0, 1, .. etc


---------------------- equality and comparisions ------------------------

`x = y` in ocaml just like `x.equals(y)` in Java. (Strucutural/value/deep equality)

and `x == y` just like `x == y` (comparing the address) in Java. (shallow/address equality)


