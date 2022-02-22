let instr_map_tests =
  ("instr_map", (fun (f,l)->map f l), (=), (=),
   Some((fun (f,l) -> str_int_list l),
        str_int_list),
   [
     (Some("simple list"), ((fun x -> 1+x), [1;2;3;4;5]), Ok [2;3;4;5;6]);
       (* TODO: Add more tests *)
     (None, ((fun x -> x), [1;2;3;4;5]), Ok [1;2;3;4;5]);
     (None, ((fun x -> x), []), Ok []);
     (None, ((fun x -> x), [1]), Ok [1]);
     (None, ((fun x -> -x), [1]), Ok [-1]);
  ])

let instr_filter_tests =
  ("instr_filter", (fun (f,l)->filter f l), (=), (=),
   Some((fun (f,l) -> str_int_list l),
        str_int_list),
   [
     (Some("simple list"), ((fun x -> (x mod 2)=0), [1;2;3;4;5]), Ok [2;4]);
       (* TODO: Add more tests *)
     (None, ((fun x -> (x mod 2)!=0), [1;2;3;4;5]), Ok [1;3;5]);
     (None, ((fun x -> (x mod 2)=0), []), Ok []);
     (None, ((fun x -> (x mod 2)=0), [1]), Ok []);
     (None, ((fun x -> (x mod 2)=0), [2]), Ok [2]);
  ])

let instr_fold_left_tests =
  ("instr_fold_left", (fun (f,y,l)->fold_left f y l), (=), (=),
   Some((fun (f,y,l) -> str_pair string_of_int str_int_list (y,l)),
        string_of_int),
   [
     (Some("+"), ((+), 0, [1;2;3]), Ok 6);
     (Some("-"), ((-), 0, [1;2;3]), Ok (-6));
       (* TODO: Add more tests *)
     (None, ((+), 42, []), Ok 42);
     (None, ((+), 42, [5]), Ok 47);
     (None, ((-), 42, [5]), Ok 37);
  ])

let instr_fold_right_tests =
  ("instr_fold_right", (fun (f,y,l)->fold_right f y l), (=), (=),
   Some((fun (f,y,l) -> str_pair string_of_int str_int_list (y,l)),
        string_of_int),
   [
     (Some("+"), ((+), 0, [1;2;3]), Ok 6);
     (Some("-"), ((-), 0, [1;2;3]), Ok 2);
     (* TODO: Add more tests *)
     (None, ((+), 42, []), Ok 42);
     (None, ((+), 42, [5]), Ok 47);
     (None, ((-), 42, [5]), Ok (-37));
  ])


let instr_append_tests =
  ("instr_append", (fun (l1,l2)->append l1 l2), (=), (=),
   Some((fun x -> str_pair str_int_list  str_int_list x),
        str_int_list),
   [
     (Some("simple list"), ([1;2],[3;4]), Ok [1;2;3;4]);
       (* TODO: Add more tests *)
     (None, ([], [3;4]), Ok [3;4]);
     (None, ([1;2], []), Ok [1;2]);
     (None, ([], []), Ok [])
  ])

let instr_rev_append_tests =
  ("instr_rev_append", (fun (l1,l2)->rev_append l1 l2), (=), (=),
   Some((fun x -> str_pair str_int_list  str_int_list x),
        str_int_list),
   [
     (Some("simple list"), ([1;2],[3;4]), Ok [2;1;3;4]);
       (* TODO: Add more tests *)
     (None, ([], [3;4]), Ok [3;4]);
     (None, ([1;2], []), Ok [2;1]);
     (None, ([], []), Ok [])
  ])

let instr_flatten_tests =
  ("instr_flatten", (fun l -> flatten l), (=), (=),
   Some((fun l -> "[" ^ str_x_list (str_int_list) l ";" ^ "]" ),
        str_int_list),
   [
     (Some("simple list"), [[1;2];[3;4]], Ok [1;2;3;4]);
     (Some("simple list 2"), [[3;4]; [1;2]], Ok [3;4;1;2]);
     (* TODO: Add more tests *)
     (None, [[]; [3;4]], Ok [3;4]);
     (None, [[1;2]; []], Ok [1;2]);
     (None, [[]; []], Ok [])
   ]
  )


let instr_sort_test_cases = [
    (Some("simple list"), ((<),[1;3;4;2;5]), Ok [1;2;3;4;5]);
    (* TODO: Add more tests *) 
    (Some("greater than"), ((>), [1;3;4;2;5]), Ok [5;4;3;2;1]);
    (Some("Empty list"), ((<), []), Ok [])

  ]

let instr_insert_tests =
  ("instr_insert", (fun (cmp,elt,l)->insert cmp elt l), (=), (=),
   Some(((fun (cmp,elt,l) -> str_pair string_of_int str_int_list (elt,l)),
         (fun y -> str_int_list y)
     )),
   [
     (Some("simple <"), ((<), 0, [-1;1;2]), Ok ([-1; 0; 1; 2]));
     (Some("simple >"), ((>), 0, [2;1;-1]), Ok ([2; 1; 0; -1]));
     (* TODO: Add more tests *)
     (None, ((<), 1, []), Ok ([1]));
     (None, ((<), 2, [1]), Ok ([1;2]));
     (None, ((>), 2, [1]), Ok ([2;1]));
     (None, ((<), 1, [1;2]), Ok ([1;1;2]));
     (None, ((>), 1, [2;1]), Ok ([2;1;1]));
   ])

let instr_insertionsort_tests =
  ("instr_insertionsort", (fun (cmp,l) -> insertionsort cmp l), (=), (=),
   Some((fun (cmp,l) -> str_int_list l),
        str_int_list),
   instr_sort_test_cases)


let select_test_eq (s1,l1) (s2,l2) =
  (s1 = s2) && (int_list_cmp l1 l2)

let instr_select_tests =
  ("instr_select", (fun (cmp,l)->select cmp l), select_test_eq, (=),
   Some(((fun (cmp,l) -> str_int_list l),
         (fun (s,l) -> str_pair string_of_int str_int_list (s,l))
     )),
   [
     (Some("simple <"), ((<), [1;-1;2]), Ok (-1,[2;1]));
     (Some("simple >"), ((>), [1;-1;2]), Ok (2,[1;-1]));
     (* TODO: Add more tests *)
     (Some("single"), ((<), [1]), Ok (1, []))
   ])


let instr_selectionsort_tests =
  ("instr_selectionsort", (fun (cmp,l) -> selectionsort cmp l), (=), (=),
   Some((fun (cmp,l) -> str_int_list l),
        str_int_list),
   instr_sort_test_cases)


let pivot_test_eq (a1,b1) (a2,b2) =
  (int_list_cmp a1 a2) && (int_list_cmp b1 b2)

let instr_pivot_tests =
  ("instr_pivot", (fun (cmp,elt,l)->pivot cmp elt l), pivot_test_eq, (=),
   Some(((fun (cmp,elt,l) -> str_pair string_of_int str_int_list (elt,l)),
         (fun y -> str_pair str_int_list  str_int_list y)
     )),
   [
     (Some("simple <"), ((<), 0, [-1;1;0;-2; 2]), Ok ([-2; -1],[2; 0; 1]));
     (Some("simple >"), ((>), 0, [-1;1;0;-2; 2]), Ok ([2; 1], [-2; 0; -1]));
     (* TODO: Add more tests *)
     (Some("single"), ((<), 0, [0]), Ok ([], [0]))
  ])

let instr_quicksort_simple_tests =
  ("instr_quicksort_simple", (fun (cmp,l) -> quicksort_simple cmp l), (=), (=),
   Some((fun (cmp,l) -> str_int_list l),
        str_int_list),
   instr_sort_test_cases)

let instr_quicksort_better_tests =
  ("instr_quicksort_better", (fun (cmp,l) -> quicksort_better cmp l), (=), (=),
   Some((fun (cmp,l) -> str_int_list l),
        str_int_list),
   instr_sort_test_cases)
