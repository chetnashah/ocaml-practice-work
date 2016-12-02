
(* takes a list of elements, and returns a list of pairs *)
let encode list =
  let rec aux count acc = function
    | [] -> []
    | [x] -> ((count + 1),x) :: acc
    | a :: (b :: _ as t) -> if a = b then aux (count + 1) acc t
                            else aux 0 ((count + 1,a)::acc) t
  in aux 0 [] list;;
(* # encode ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"];; *)
(* [(4, "a"); (1, "b"); (2, "c"); (2, "a"); (1, "d"); (4, "e")] *)


(* reverse itself is not recursive but uses one inside 
  with an accumulator *)
let rev list =
  let rec aux acc = function
    | [] -> acc
    | h::t -> aux (h::acc) t
  in
  aux [] list;;

let is_palindrome xs = rev xs = xs;;
  
let rec length = function
  | [] -> 0
  | h::t -> 1 + length t;;

let rec at k = function
  | [] -> None
  | h :: t -> if k = 1 then Some h else at (k-1) t;;

let rec mylasttwo = function
  | [] | [_] -> None
  | [x;y] -> Some (x,y)
  | _::t -> mylasttwo t;;

let rec mylast = function
  | [] -> None
  | [el] -> Some el
  | _ :: tl -> mylast tl ;;

  
