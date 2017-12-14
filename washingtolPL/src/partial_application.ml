
(* we have not passed list yet, so this is a useful closure/function to have, which
 * is closed over combinare function that adds to number and initial acc 0 *)
let sum = List.fold_left (fun x y -> x + y) 0

(* pass the list *)
let s = sum [1;2;3;45;6;7]

(* Most library functions are also auto-curried by default *)

let rec exists pred xs = match xs with
  [] -> false
  | x::xs' -> pred x || exists pred xs'

let hasZero = exists (fun x -> x=0)



