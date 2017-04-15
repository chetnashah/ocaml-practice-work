


(* (status, thunk) *)
type 'a deferred = bool ref * (unit -> 'a);;

(* (unit -> 'a) -> 'a deffered *)
let defer (ff: unit -> 'a) = (ref false, ff);;

(* 'a deferred -> 'a *)
let force =
  let calculatedvalue = ref [] in
  let findorapply (st, th) entries = match !st with
      true -> List.hd entries
    | false ->
      st := true;
      let y = th () in
      calculatedvalue := y :: !calculatedvalue;
      y
  in
  (fun dv -> findorapply dv !calculatedvalue)
;;


(* A lazy list is a list where tail of the list is deferred computation
a lazy list is also called a stream. 
*)

type 'a lazy_list = Nil
                  | Cons of 'a * 'a lazy_list
                  | LazyCons of 'a * 'a lazy_list deferred

(* some reference implementation in SML
http://condor.depaul.edu/ichu/csc447/notes/wk9/lazy.html
*)

let nil = Nil;;
let cons x xs = Cons (x,xs);;
let lazy_cons x (fn: unit -> 'a lazy_list) = LazyCons (x,defer fn);;
let is_nil xs = match xs with
    Nil -> true
  | _ -> false;;

let head xs = match xs with
    Cons (a, _) -> a
  | LazyCons (a, _) -> a
  | _ -> raise (Invalid_argument "head xs");;

let tail xs = match xs with
  | Nil -> raise (Invalid_argument "tail Nil")
  | Cons (a, tl) -> tl
  | LazyCons(a, th) ->




