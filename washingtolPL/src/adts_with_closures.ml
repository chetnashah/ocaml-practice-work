
(* a set abstract data type like in a Java library *)
(* the interface is just the methods, the data is in their closures *)

(* records need type defined beforehand and we used 'and' to define mutually recursive types *)
type set = S of setmethods and
setmethods = { insert: int -> set; member: int -> bool; size: unit -> int }



