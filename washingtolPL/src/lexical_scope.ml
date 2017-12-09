
(* comes into picture especially with higher order functions *)

let x = 1
(* in the closure of f, x will be 1, not temporal *)
let f y = x + y

(* in the current environment, we shadow x by 2, does not affect closure of f *)
let x = 2

let y = 3

let z = f (x + y)


