

open OUnit2
open Sum

(* >::: is like describe to name a test suite *)
let tests = "test suite for sum " >::: [
(* individual test cases are made with >:: like it *)
    "empty" >:: (fun _ -> assert_equal 0 (sum []));
    "one" >:: (fun _ -> assert_equal 1 (sum [1]));
    "onetwo" >:: (fun _ -> assert_equal 3 (sum [1; 2]));
  ]

let _ = run_test_tt_main tests
