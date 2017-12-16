
let x = ref 42 (* type of x is int ref *)
let y = ref 42

(* only possible operations on type t ref are assignment and dereference *)
let z = x
let _ = x := 43

let w = (!y) + (!z)




