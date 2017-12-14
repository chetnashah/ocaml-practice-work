(* 
        compile this using 
  ocamlbuild -use-ocamlfind main.d.byte
*)

let make_pair a b = (a,b);;

let compose f g x = f (g x);;

let plus3 x = x + 3;;

let id x = x;;

(* List.init function is only in 4.06 :( *)
let init n f =
  if n = 0 then [] else
  if n < 0 then invalid_arg "List.init" else
  let rec init_aux acc i =
    if i >= n then acc else
    init_aux ((f i)::acc) (i+1)
  in List.rev (init_aux [] 0)

let sample_list = init 10 id;;

(* common names are n_times, repeat, iterate *)
(* applies a function f to x, n times *)
let rec repeat f n x = match n with
    0 -> x
  | _ -> repeat f (n-1) (f x);;
  
(* point free repeate/iterate in terms of repeated composition *)
let rec iterate n f =
  if n = 0 then (function x -> x)
  else compose f (iterate (n-1) f);;

(* repeat in terms of fold *)
let n_times n f x = List.fold_left (fun acc -> fun y -> f acc) x (init n id);; 
  
let () = print_string "main.ml loaded \n";;

let testrepeat = repeat plus3 10 1;;
  
let () = print_string ("\n" ^ string_of_int testrepeat);;

let testiterate = iterate 10 plus3 1;;

let () = print_string ("\n" ^ string_of_int testiterate);;

let testn_times = n_times 10 plus3 1;;

let () = print_string ("\n" ^ string_of_int testn_times);;

