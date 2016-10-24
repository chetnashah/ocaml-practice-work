


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

  
