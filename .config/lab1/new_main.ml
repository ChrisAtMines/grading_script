open Testing
open Lab1

let main () =
  Testing.print_tests Lab1.nth_tests;
  Testing.print_tests Lab1.append_tests;
  Testing.print_tests Lab1.reverse_tests;
  Testing.print_tests Lab1.length_tests;
  Testing.print_tests Lab1.list_prefix_tests;
  Testing.print_tests Lab1.list_suffix_tests;
  Testing.print_tests Lab1.merge_tests;
  Testing.print_tests Lab1.mergesort_tests;
  
  Testing.print_tests Lab1.instr_nth_tests;
  Testing.print_tests Lab1.instr_append_tests;
  Testing.print_tests Lab1.instr_reverse_tests;
  Testing.print_tests Lab1.instr_length_tests; 
  Testing.print_tests Lab1.instr_list_suffix_tests;
  Testing.print_tests Lab1.instr_merge_tests;
  Testing.print_tests Lab1.instr_mergesort_tests;

;;

main ()
