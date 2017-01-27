


type key = string
type value = int
type dictionary = (string -> int)
type add = dictionary -> key -> value -> dictionary
type find = dictionary -> key -> value

let (fnEmpty: dictionary) = (function (key: key) -> 0);;

(* there is bug in implementations specified in book *)   
let fnAdd dict k v = fun k' -> if k' = k then v else dict k';;

(* this function is kind of redundant, don't you think ? *)
let (fnFind: find) = fun dict k -> dict k;;

let emp = fnEmpty;;
let dx1 = fnAdd emp "x" 99;;
let dx2 = fnAdd dx1 "y" 100;;
let dx3 = fnAdd dx2 "z" 101;;
