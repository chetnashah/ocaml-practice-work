
(*  e1; e2 
 *  computes executes expression e1, throws away the result and executes e2,
 *  and the result of the full expression is the result of expression e2,
 *  useful use case is print, e.g.
 *  print "!"; e2
 *  is used to check executions of e2 *)

let len = String.length "hello world"

(* return all strings in xs, that are strictly shorter than length of s *)
let allShorterThan1  (xs,s) = List.filter (fun x -> String.length x < (Printf.printf "\n!"; String.length s)) xs

let ans = allShorterThan1 (["oho";"hi";"dude";"small";"professional";"buffers"],"props")

(* same as allShorterThan1, but since String.length s is fixed, it can be put in closure *)
(* filter runs our lambda on each element of xs for testing predicate, but we have avoided
 * recomputation of String.length s, by just looking it up in the closure *)
let allShorterThan2 (xs,s) = 
  let slen = (Printf.printf "\n*\n"; String.length s) in
  List.filter (fun x -> String.length x < slen) xs

let ans2 = allShorterThan2  (["oho";"hi";"dude";"small";"professional";"buffers"],"props") 

