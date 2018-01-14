
(* modules are used to namespace bindings inside a module accessed via
 * ModuleName.bindingName , namespacing and modules are good for modularity
 * and software engineering, e.g. map functions for different modules won't collide
 * e.g. List.map, Tree.map bindings exist in different modules/namespaces and hence won't 
 * shadow or collide with each other *)
module MyMathLib = 
struct
  (* all bindings should lie between struct - end *)
  let rec fact x =
    if x=0
    then 1
    else x * fact (x - 1)

  let doubler y = y + y
end
