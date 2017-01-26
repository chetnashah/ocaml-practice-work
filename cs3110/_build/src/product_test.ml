
open OUnit2
open Product

let tests = "product tests" >::: [
"multiply with zero returns 0 " >:: (fun _ -> assert_equal 0 (product 9 0));
"multiple with 1 returns itself " >:: (fun _ -> assert_equal 2 (product 2 1));
]

let _ = run_test_tt_main tests
