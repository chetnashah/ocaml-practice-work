
(* callback style programming is common for event driven systems *)
(* behavior is registered for events like key press, network data arrival etc. *)

(* list of all callbacks *)
let cbs : (int -> unit) list ref = ref []

let registerCb f = cbs := f :: (!cbs)

(* simulate keypress by calling this function *)
let onEvent i = 
  List.iter (fun f -> f i) !cbs


(* clients *)
let timesPressed = ref 0
let _ = registerCb (fun _ -> timesPressed := !timesPressed + 1)


let printIfPressed i =
  registerCb (fun j ->
    if i = j
    then print_endline ("you pressed" ^ string_of_int i)
    else ())

let _ = printIfPressed 4
let _ = printIfPressed 11
let _ = printIfPressed 23
let _ = printIfPressed 4

(*  on repl
 *  try out : onEvent 3, onEvent 4, check timesPressed etc. *)
