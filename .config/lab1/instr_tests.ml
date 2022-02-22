let instr_nth_tests =
  ("instr_Nth", (fun (i,l)->nth i l), (=), (=),
   Some((fun x -> str_pair string_of_int str_int_list x),
        string_of_int),
   [
     (Some("first element"), (0, [1;2;3;4;5]), Ok 1);
     (Some("last element"), (4, [1;2;3;4;5]), Ok 5);
     (Some("middle element"), (2, [1;2;3;4;5]), Ok 3);
     (Some("index too large"), (5, [1;2;3;4;5]), Error IndexError);
     (Some("negative index"), (-1, [1;2;3;4;5]), Error IndexError)  
  ])

let instr_append_tests =
  ("instr_append", (fun (l1,l2)->append l1 l2), (=), (=),
   Some((fun x -> str_pair str_int_list  str_int_list x),
        str_int_list),
   [
     (Some("simple list"), ([1;2],[3;4]), Ok [1;2;3;4]);
     (Some("empty first list"), ([], [3;4]), Ok [3;4]);
     (Some("empty second list"), ([1; 2], []), Ok [1;2]);
     (Some("empty lists"), ([], []), Ok []);
  ])

let instr_reverse_tests =
  ("instr_reverse", reverse, (=), (=), Some(str_int_list,str_int_list),
   [
     (Some("simple list"), [1;2;3;4;5], Ok[5;4;3;2;1]);
     (Some("empty list"), [], Ok [])
  ])

let instr_length_tests =
  ("instr_length", length, (=), (=), Some(str_int_list,string_of_int),
   [
     (Some("simple list"), [1;2;3;4;5], Ok 5);
     (Some("empty list"), [], Ok 0);
     (Some("1 element"), [1], Ok 1)
  ])

let instr_list_suffix_tests =
  ("instr_list_suffix", (fun (istart,l) -> list_suffix istart l), (=), (=),
   Some((fun x -> str_pair string_of_int  str_int_list x),
        str_int_list),
   [
     (Some("simple list"), (2,[1;2;3;4;5]), Ok [3;4;5]); 
     (Some("whole list"), (0, [1;2;3;4;5]), Ok [1;2;3;4;5]);
     (Some("last element"), (4, [1;2;3;4;5]), Ok [5]);
     (Some("neg index"), (-1, [1;2;3;4;5]), Error IndexError)
  ])

let instr_merge_tests =
  ("instr_merge", (fun (cmp,l1,l2) -> merge cmp l1 l2), (=), (=),
   Some((fun (cmp,l1,l2) -> str_pair str_int_list str_int_list (l1, l2)),
        str_int_list),
   [
     (Some("simple list"), ((<),[1;3],[2;4;5]), Ok [1;2;3;4;5]);
       (* TODO: Add more tests *)
     (Some("greater than"), ((>), [3;1], [5;4;2]), Ok [5;4;3;2;1]);
     (Some("empty lists"), ((<), [], []), Ok []);
     (Some("first empty"), ((<), [], [2;4;5]), Ok [2;4;5]);
     (Some("second empty"), ((<), [1;3], []), Ok [1;3])
  ])


let instr_mergesort_tests =
  ("instr_mergesort", (fun (cmp,l) -> mergesort cmp l), (=), (=),
   Some((fun (cmp,l) -> str_int_list l),
        str_int_list),
   [
     (Some("simple list"), ((<),[1;3;4;2;5]), Ok [1;2;3;4;5]);
     (* TODO: Add more tests *)
     (Some("greater than"), ((>), [1;3;4;2;5]), Ok [5;4;3;2;1]);
     (Some("Empty list"), ((<), []), Ok [])
   ])


