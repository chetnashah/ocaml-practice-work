
(* A structure matches a signature if the structure provides definitions
 * for all the names specified in the signature (it can provide extra definitions
 * which will be hidden outside module), the provided definitions should match
 * the type requirements given in the signature *)

module type STACK = sig
  type 'a stack (* type is abstract in signature *)
  val empty : 'a stack
  val is_empty : 'a stack -> bool
  val push : 'a -> 'a stack -> 'a stack
  val peek : 'a stack -> 'a
  val pop : 'a stack -> 'a stack
end

(* only STACK implementation decides how it wants to store, e.g. list *)
module ListStack = struct
  type 'a stack = 'a list (* type is concrete in module/implementation *)
  let empty = []
  let is_empty s = (s = [])
  let push x s = x :: s
  let peek = function
    | [] -> failwith "Empty"
    | x::_ -> x
  let pop = function
    | [] -> failwith "Empty"
    | _::xs -> xs
  (* hidden to work only inside the module coz not exposed via signature STACK *)
  let helper = "I am a helper "
end


