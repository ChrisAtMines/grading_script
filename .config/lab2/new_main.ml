open Testing
open Lab2

let main () =
  (* Implementation *)
  Testing.print_tests Lab2.map_tests;
  Testing.print_tests Lab2.filter_tests;
  Testing.print_tests Lab2.fold_left_tests;
  Testing.print_tests Lab2.fold_right_tests;

  (* Use *)
  Testing.print_tests Lab2.append_tests;
  Testing.print_tests Lab2.rev_append_tests;
  Testing.print_tests Lab2.flatten_tests;
  Testing.print_tests Lab2.insert_tests;
  Testing.print_tests Lab2.insertionsort_tests;
  Testing.print_tests Lab2.select_tests;
  Testing.print_tests Lab2.selectionsort_tests;
  Testing.print_tests Lab2.pivot_tests;
  Testing.print_tests Lab2.quicksort_simple_tests;
  Testing.print_tests Lab2.quicksort_better_tests;

  (* Implementation *)
  Testing.print_tests Lab2.instr_map_tests;
  Testing.print_tests Lab2.instr_filter_tests;
  Testing.print_tests Lab2.instr_fold_left_tests;
  Testing.print_tests Lab2.instr_fold_right_tests;

  (* Use *)
  Testing.print_tests Lab2.instr_append_tests;
  Testing.print_tests Lab2.instr_rev_append_tests;
  Testing.print_tests Lab2.instr_flatten_tests;
  Testing.print_tests Lab2.instr_insert_tests;
  Testing.print_tests Lab2.instr_insertionsort_tests;
  Testing.print_tests Lab2.instr_select_tests;
  Testing.print_tests Lab2.instr_selectionsort_tests;
  Testing.print_tests Lab2.instr_pivot_tests;
  Testing.print_tests Lab2.instr_quicksort_simple_tests;
  Testing.print_tests Lab2.instr_quicksort_better_tests;
;;

main ()
