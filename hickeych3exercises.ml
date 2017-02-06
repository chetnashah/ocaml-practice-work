


type key = string
type value = int
type dictionary = (string -> int)
type add = dictionary -> key -> value -> dictionary
type find = dictionary -> key -> value

let (fnEmpty: dictionary) = (function (key: key) -> 0);;

(* there is bug in implementations specified in book *)   
let fnAdd dict k v = fun k' -> if k' = k then v else dict k';;

(* this function is kind of redundant, don't you think ? *)
let (fnFind: find) = fun dict k -> dict k;;

let emp = fnEmpty;;
let dx1 = fnAdd emp "x" 99;;
let dx2 = fnAdd dx1 "y" 100;;
let dx3 = fnAdd dx2 "z" 101;;


(* Stream is an infinite sequence
   that support hd(s) which returns an
   item and tl(s) which returns a new
   stream with the first element removed
*)

type stream = int -> int;;
type addConstant = stream -> int -> stream;;
type diffStreams = stream -> stream -> stream;;
type stMap = (int -> int) -> stream -> stream;;

let square y = y * y;;
let s x = x;;
let hd (s: stream) = s 0;;
let tl (s: stream) = (fun i -> s (i + 1));;

let streamOfIntegers = s;;
let zeroth = hd streamOfIntegers;;
let next = tl streamOfIntegers;;
let first = hd next;;
let nextnext = tl next;;

(* try out hd (tl (tl (tl (tl (tl s)))))) *)

let (+:) :addConstant = fun s c ->
  (fun x -> x + c);;

let (-|) :diffStreams = fun s1 s2 ->
  (fun x -> (hd s1) - (hd s2));;

let stMap: stMap = fun f s1 ->
  fun x -> f x;;

(* make a square stream with :
   let sqs = stMap square streamOfIntegers
*)

(* note fun cannot be used for matching, only function *)
(* patterns with guards using "when" *)

let rec fib2 = function
    i when i < 2 -> i
  | i -> fib2 (i-1) + fib2(i-2);;

(* wildcard pattern and pattern ranges *)

let is_uppercase = function
    'A' .. 'Z' -> true
  | _ -> false;;

(* incomplete matches - ocaml warns you *)

let is_uppercase2 = function
    'A' .. 'Z' -> true;;

(* always heed the compiler warnings *)

let is_odd i =
  match i mod 2 with
    0 -> false
  | 1 -> true
  | _ -> raise (Invalid_argument "is_odd");; (* added bcoz compiler warning, try -1 *)

exception Foo of string;;

(* exercise 5.4 *)
type select = (string * string * float -> bool) -> (string * string * float) list

(* return list of all tuples that match the predicate *)
let rec select pred lst =
  match lst with
  | h :: tl -> if pred h then h :: (select pred tl) else (select pred tl)
  | [] -> [];;

let db = [
  "John", "x3456", 50.1;
  "Jane", "x1234", 107.3;
  "Joan", "unlisted", 12.7;
];;

let ans = select (fun (_,_,salary) -> salary < 100.0) db;;

(* normal append function *)

let rec append l1 l2 =
  match l1 with
  | h :: tl -> h :: append tl l2
  | [] -> l2;;

(* tail recursive append function *)

let appendT l1 l2 =
  let rec appe ls accum =
    match ls with
    | h :: tl -> appe tl (h :: accum)
    | [] -> accum
  in List.rev(appe l2 (List.rev l1));;


(* Binary tree paremetrized with union types *)

type 'a tree =
    Node of 'a * 'a tree * 'a tree
  | Leaf;;

(* operating on recursive structures with pattern matchin *)

let rec cntNonLeafNodes = function
    Leaf -> 0
  | Node(_, left, right) ->
    cntNonLeafNodes left + cntNonLeafNodes right + 1;;


(* Lets make a set data structure using this tree structure we have *)
(* Leaf only is empty set *)

let emptyTree = Leaf;;

(* This is an unbalanced bintree where original set is made right subtree *)
let insert x s = Node (x, Leaf, s);;

(* take a list and keep inserting into set, in reverse order *)
let rec set_of_list = function
    [] -> emptyTree
  | h :: tl -> insert h (set_of_list tl);;

let ss = set_of_list [1;2;3;97;98;99;];;

(* Simple membership function *)
let rec mem x = function
    Leaf -> false
  | Node (y, left, right) ->
    x = y || mem x left || mem x right;;

(* In order to make the binary tree, height balanced, we can
   rotate trees maintaining invariant that for any interior node
   Node(x, left, right), labels in left child are smaller than x,
   and labels in right node are greater than x *)

let rec binsert x = function
    Leaf -> Node (x, Leaf, Leaf)
  | Node (y, left, right) as node ->
    if x < y then
      Node (y, insert x left, right)
    else if x > y then
      Node (y, left, insert x right)
    else
      node;;


(* Not these functions add in reverse order *)
let rec bset_of_list = function
    [] -> Leaf
  | h :: tl -> binsert h (bset_of_list tl);;

let bss = bset_of_list [1;2;3;66;65;64;];;

(* Now we can speed up search by pruning tree searchusing order comparison *)

let rec bmem x = function
    Leaf -> false
  | Node (y, left, right) ->
    x = y || (x < y && mem x left) || (x > y && mem x right);;


(* Now we address red-black trees *)

