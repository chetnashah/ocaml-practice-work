

(* suppose you wanted a  tupled version of a curried form function or vice versa *)

let curry f = fun x -> fun y -> f (x,y)
let uncurry f = fun (x,y) -> f x y

(* reversing order for curried functions *)
let other_curry f = fun x -> fun y -> f y x

let rec range (i,j) = if i > j then
  [] else
    i :: range(i+1, j)

let curriedrange = curry range

let countup = curriedrange 1

let xs = countup 7



