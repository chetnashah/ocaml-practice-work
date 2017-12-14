(* say f after g *)
let compose (f,g) x = f (g x)

(* ocaml does not have compose infix operator *)
let k = compose ((fun x -> x + 1), (fun y -> y * 2)) 9

let sqr_of_abs = compose( compose(sqrt, float_of_int), abs)

(* defining infix functions in Ocaml with brackets around infix op *)
(* pipeline operator is just flipping of function application *)
let ( |> ) f g x = g(f(x))


let sqr_of_abs2 = abs |> float_of_int |> sqrt


