
let x = 1

(* higher order function, because returning function, usually with some closure (if returned function has some free variables) *)
let f y =
  let x = y + 1 in
  fun z -> x + y + z

let x = 3           (* irrelavant *)
let g = f 4         (* f returned a function that we bound to g *)
let y = 5
let z = g 6

(* higher order function, because taking another function *)
let f g =
  let x = 3 in
  g 2

let x = 4
let h y = x + y (* closure present since, x is free in definition of h *)
let z = f h
