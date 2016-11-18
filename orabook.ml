

let make_pair a b = (a,b);;

let compose f g x = f (g x);;

let rec repeat f n x = match n with
    0 -> x
  | _ -> repeat f (n-1) (f x);;
  
(* point free repeate/iterate in terms of repeated composition *)
let rec iterate n f =
  if n = 0 then (function x -> x)
  else compose f (iterate (n-1) f);;
  
  
let () = print_string "orabook.ml loaded";;
  
