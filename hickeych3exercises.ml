


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

(* Red-black trees have following invariants
   1. every leaf is black
   2. All children of every red node are black
   3. Every path from root to a leaf has same number of black nodes as
      every other path.
   4. The root is always black *)

type color = Red | Black;;

type 'a rbtree =
    Node of color * 'a * 'a rbtree * 'a rbtree
  | Leaf;;

let rec rbmem x = function
    Leaf -> false
  | Node (_, y, left, right) ->
    x = y || (x < y && rbmem x left) || (x > y && rbmem x right);;

(* Maintaining invariants while inserting ->
   1. Find location where node is to be inserted
   2. If possible add new node with red label, bcoz 3 will be preserved
      But this may violate 2 -> red-red parent child
   So the balance function which considers case of red-red and rearranges *)

(* all cases with R-R relationship are converted to R-B-B *)
let balance = function
    Black, z, Node (Red, y, Node (Red, x, a, b), c), d
  | Black, z, Node (Red, x, a, Node (Red, y, b, c)), d
  | Black, x, a, Node (Red, z, Node (Red, y, b, c), d)
  | Black, x, a, Node (Red, y, b, Node (Red, z, c, d)) ->
    Node (Red, y, Node(Black, x, a, b), Node (Black, z, c, d))
  | a, b, c, d ->
    Node (a, b, c, d);;

let rbinsert x s =
  let rec rbins = function
      Leaf -> Node (Red, x, Leaf, Leaf)
    | Node (color, y, a, b) as s ->
      if x < y then balance (color, y, rbins a, b)
      else if x > y then balance (color, y, a, rbins b)
      else s
  in
  match rbins s with (* first ins in s and then make the first one black *)
    Node (_, y, a, b) -> (Black, y, a, b)
  | Leaf -> raise (Invalid_argument "insert");;

type 'a mylist = Nil | Cons of 'a * 'a mylist;;


let rec mylistmap fn = function
    Nil -> Nil
  | Cons (h, tl) -> Cons (fn h, mylistmap fn tl);;

let mylistval = Cons(1, Cons(2, Cons(3, Cons(4, Nil))));;

let mapans = mylistmap square mylistval;;

let rec mylistappend xs ys = match xs with
    Nil -> ys
  | Cons (h, tl) -> Cons (h, mylistappend tl ys);;

let mylval1 = Cons (1, Cons(2, Cons(3, Nil)));;
let mylval2 = Cons (44, Cons(11, Cons(76, Nil)));;

let myapplist = mylistappend mylval1 mylval2;;

type unary_number = Z | S of unary_number;;

(* adds two unary numbers *)
let rec addUns un1 un2 = match un1 with
    Z -> un2
  | (S tl) -> (S (addUns tl un2));;

let un1 = S Z;;
let un2 = S (S Z);;

let rec multUns un1 un2 acc = match un1 with
    Z -> acc
  | (S tl) -> multUns tl un2 (addUns acc un2);;

type small = Four | Three | Two | One;;

let lt_small sm1 sm2 = not (sm1 < sm2);;

(* Doing arithmetic expressions *)

type unop = Neg;;
type binop = Add | Sub | Mul | Div;;
type exp =
    Constant of int
  | Unary of unop * exp
  | Binary of exp * binop * exp;;

let rec eval ex: int =
  match ex with
    Constant c -> c
  | Unary (u, e) -> -1 * (eval e)
  | Binary (e1, b, e2) -> match b with
      Add -> (eval e1) + (eval e2)
    | Sub -> (eval e1) - (eval e2)
    | Mul -> (eval e1) * (eval e2)
    | Div -> (eval e1) / (eval e2);;

let ex1 = Binary (Constant 2, Mul, Unary (Neg, Constant 4));;

type ('k, 'v) treeDict = Empty | Node of 'k * 'v * ('k, 'v) treeDict * ('k, 'v) treeDict;;


let rec addDict tr k v = match tr with
    Empty -> Node(k, v, Empty, Empty)
  | Node (kk, vv, tLeft, tRight) ->
    if k = kk then
      Node (kk, v, tLeft, tRight)
    else if k > kk then
      Node (kk, vv, tLeft, addDict tRight k v)
    else
      Node (kk, vv, addDict tLeft k v, tRight);;

let rec findDict tr k = match tr with
    Empty -> raise (Invalid_argument "Cannot find in empty tree")
  | Node (kk,vv,tLeft,tRight) ->
    if k = kk then
      vv
    else if k > kk then
      findDict tRight k
    else
      findDict tLeft k;;


(* Doubly linked lists (cyclic data structure) with mutale features *)

(* API for elem of DLL// Nil or Elem (content, leftref, righref) *)
type 'a elem = Nil | Elem of 'a * 'a elem ref * 'a elem ref;;

let nil_elem = Nil;;

let get el = match el with
    Nil -> raise (Invalid_argument "Get on Nil")
  | Elem (x, _, _) -> x;;
let prev_elem el = match el with
    Nil -> raise (Invalid_argument "prev_elem on Nil")
  | Elem (_, prev, _) -> !prev;;
let next_elem el = match el with
    Nil -> raise (Invalid_argument "next_elem on Nil")
  | Elem (_, _, next) -> !next;;
let create_elem x = Elem (x, ref Nil, ref Nil);;



(* API for DLL *)
type 'a dllist = 'a elem ref;; (* the head is ref to first element *)
let create () = ref Nil;;

(* example of multiple pattern matching *)
let insert elem list = match elem, !list with
    Nil, _ -> raise (Invalid_argument "cannot insert Nil in dll")
  | Elem (_, prev, next), Nil -> (* We insert elem in a Nil list *)
    prev:= Nil;
    next:= Nil;
    list:= elem
  | Elem (_, prev1, next1), (Elem (_, prev2, _) as head) ->
    (* INserting elem in a non empty list with a head *)
    prev1 := Nil;
    next1 := head;
    prev2 := elem;
    list := elem;;

(* see nested matching *)
let remove elem list = match elem with
    Nil -> raise (Invalid_argument "can't remove nil from list")
  | Elem (_, prev, next) ->
    (match !prev with
       Elem (_,_, prev_next) -> prev_next := !next
     | Nil -> list := !next
    );
    (match !next with
       Elem(_, next_prev, _) -> next_prev := !prev
     | Nil -> ()
    );
;;

(* memo function that remembers values of functioons with arguments *)
(* val memo: ('a -> 'b) -> ('a -> 'b)) *)

let memo f =
  let table = ref [] in
  let rec find_or_apply entries x = (* look for x in entries *)
    match entries with
      (x', y) :: _ when x' = x -> y (* already computed, just return *)
    | _ :: entries -> find_or_apply entries x (* keep looking in list *)
    | [] ->  (* entry was not found in table, apply and put it in table *)
      let y = f x in
      table := (x,y) :: !table;
      y
  in
  (fun x -> find_or_apply !table x);;

(* use time function to measure time taken by functions *)
let time f x =
  let start = Sys.time () in
  let y = f x in
  let finish = Sys.time () in
  Printf.printf "Elapsed time : %f seconds\n" (finish -. start);
  y;;

let rec fib x : int = match x with
    0 | 1 as i -> i
  | i -> fib (i - 1) + fib (i - 2);;

let memo_fib = memo fib;;

(*
time memo_fib 40;;
time memo_fib 40;;
*)



(* graph representation : vertex and edges list of vxv *)
type vertex = int;;
type graph = (vertex, vertex list) treeDict;;

let gdata = [1,2; 1,3; 1,4; 2,4; 3,4];;

(* populate graph from given edge list, with adjacency list representation *)
let rec populate dct edgelist = match edgelist with
    [] -> dct
  | h :: tl -> (
      let v1 = fst h in
      let v2 = snd h in
      let newlist = (
        try
          v2 :: (findDict dct v1)
        with
        _ -> v2 :: []
      ) in
      populate (addDict dct v1 newlist) tl
    );;

let gready = populate Empty gdata;;

(* predicate that returns if v1 can reach  to v2 (directional) *)
let reacahble g v1 v2 = false;;

(*
val makeheap : int -> heap  : create heap containing single element
val insert : heap -> int -> heap : add element to heap, dups allowed
val findmin : heap -> int : return smallest element of heap
val deletemin : heap -> heap : return new heap without smalles element
val meld: heap -> heap -> heap : join two heaps containing elements of both

some helper functions would be sinkup, sinkdown etc.
*)


(* Disjoint set data structure with path compression *)
(* uses ref based features for path compression *)

(* represent vertex as a pair(label, parent link), Links all upwards*)
(* parent is either Root i or Parent of vertex) where i is size of tree *)

type 'a parent =
    Root of int
  | Parent of 'a vert
and
  'a vert = 'a * 'a parent ref;;

let vertlabellist = [1;2;4;5;6;7;8;9;10];;
let unionlist = [(2,4); (1,5); (2,6); (4,8); (5,9); (4,8); (1,7)];;
let makeVert l = (l, (l, ref (Root 1)));;
let vertlist = List.map makeVert vertlabellist;;


let union ((_,p1) as u1) ((_, p2) as u2) =
  match !p1, !p2 with
    Root size1, Root size2 when size1 > size2 ->
    p2 := Parent u1;
    p1 := Root (size1 + size2)
  | Root size1, Root size2 ->
    p1 := Parent u2;
    p2 := Root (size1 + size2)
  | _ -> raise (Invalid_argument "union: not roots");;

let rec simple_find ((_, p) as v) =
  match !p with
    Root _ -> v
  | Parent v -> simple_find v;;

let rec compress root (_, p) =
  match !p with
    Root _ -> ()
  | Parent v -> p := Parent root; compress root v

let find v =
  let root = simple_find v in
  compress root v;
  root;;


let processUnion lst = List.iter (fun (x,y) ->
    let u1 = find x in
    let u2 = find y in
    if u1 != u2 then begin
      union u1 u2
    end
  ) lst;;

(* (status, thunk) *)
type 'a deferred = bool ref * (unit -> 'a);;

(* (unit -> 'a) -> 'a deffered *)
let defer (ff: unit -> 'a) = (ref false, ff);;

(* 'a deferred -> 'a *)
let force =
  let calculatedvalue = ref [] in
  let findorapply (st, th) entries = match !st with
      true -> List.hd entries
    | false ->
      st := true;
      let y = th () in
      calculatedvalue := y :: !calculatedvalue;
      y
  in
  (fun dv -> findorapply dv !calculatedvalue)
;;







