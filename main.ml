(* 
        compile this using 
  ocamlbuild -use-ocamlfind main.d.byte
*)

let make_pair a b = (a,b);;

let compose f g x = f (g x);;

let plus3 x = x + 3;;

let rec repeat f n x = match n with
    0 -> x
  | _ -> repeat f (n-1) (f x);;
  
(* point free repeate/iterate in terms of repeated composition *)
let rec iterate n f =
  if n = 0 then (function x -> x)
  else compose f (iterate (n-1) f);;
  
  
let () = print_string "main.ml loaded \n";;

let testrepeat = repeat plus3 10 1;;
  
let () = print_string (string_of_int testrepeat);;