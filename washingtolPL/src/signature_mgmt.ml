(* A signature is a type for module, which contains types for all bindings within *)
(* convention to name signatures in ALL_CAPS *)
module type MYMATHLIB =
sig
  (* Notice this is the only place in OCaml that we use val keyword *)
  val fact : int -> int
  val doubler : int  -> int
end


(* Ascribing signature MYMATHLIB to module MyMathLib, to typecheck module *)
module MyMathLib : MYMATHLIB =
struct
  let fact x = 0
  let doubler y = y * 2
end


(* signatures syntax:
 * module type SIGNAME = sig types_for_bindings end 
 *
 * and modules syntax
 * module ModuleName : SIGNAME = struct bindings end 
 *)

(* Note: A signature is just a type interface, it can have many implementation modules
 * all of which confirm to the single Signature, thus also used in hiding implementations *)
