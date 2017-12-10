
(* a fold takes a combiner(a function of two args- current acc and one item of list),
 * a unit/initalacc and a list ::
 * Step 1: computes combiner repeatedly applied to acc & x
 * Step 2: and giving that new value to acc which continues on Step 1
 * until there are no more x to process, whereby it returnes latest value of acc *)
let rec fold (f, acc, xs) =
  match xs with
  [] -> acc
  | x::xs' -> fold (f, f(acc,x), xs')
