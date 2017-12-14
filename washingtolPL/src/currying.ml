(* note the typesignatures of functions *)

let sorted3_tupled (x,y,z) = z >= y && y >= x

let t1 = sorted3_tupled (7,9,11)

let sorted3 = fun x -> fun y -> fun z -> z >= y && y >= x

let t2 = (((sorted3 7) 9) 11)

(* same as sorted3, all space seperated arguments are curried by default *)
let sorted3_simple x y z = z >= y && y >= x
(* by default space means function application *)
let t3 = sorted3_simple 7 9 11
