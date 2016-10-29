

let overallexp = print_string " 2= "; 1+1;;


(* parenthesized (grouped expressions) *)
let hilo = ( print_string "hi"; print_string "lo"; print_string "bhye" );;
(* hilo and hilo2 are the same thing *)
let hilo2 = begin print_string "hi2"; print_string "lo2"; print_string "bye2" end;;




let () = print_endline "hello start program";;


  (* -------------- looping and iteration in OCaml ------------------------- *)

  (* looping constructs like for and while are second class citizens since recursion and folding are primary tools for iteration *)

  (* List.iter, List.map, List.fold and recursion are preferred over other looping constructs *)

  (* get into tail recursion *)
