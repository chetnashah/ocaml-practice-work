
open OUnit2
open Add

let tests = "test suite for add" >::: [
  "add 1 2" >:: (fun _ -> assert_equal 3 (add 1 2));
  "add 7 1" >:: (fun _ -> assert_equal 8 (add 7 1));
]

let _ = run_test_tt_main tests

