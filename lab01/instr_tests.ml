(******************************)
(*   List Processing Tests    *)
(******************************)

(* Reverse Tests *)

let instr_reverse_tests = ("Instructor Reverse Tests", reverse, (=), eq_exn, Some(str_int_list, str_int_list), [
  (Some("Instr Test 1"), [], Ok([]));
  (Some("Instr Test 2"), [1], Ok([1]));
  (Some("Instr Test 3"), [1;2], Ok([1;2]));
])

(* Selection Sort Tests *)

let instr_selection_sort_tests = ("Instructor Selection Sort Tests", selection_sort, (=), eq_exn, Some(str_int_list, str_int_list), [
  (Some("Instr Test 1"), [], Ok([]));
  (Some("Instr Test 2"), [1], Ok([1]));
  (Some("Instr Test 3"), [-1;1;-50;50], Ok([-50;-1;1;50]));
])

(* Map Tests *)

let instr_map_tests = ("Instructor Map Tests", map, (=), eq_exn, Some((fun (_,l) -> str_int_list l), str_int_list), [
  (Some("Instr Test 1"), ((fun n -> n+1), []), Ok([]));
  (Some("Instr Test 2"), ((fun n -> n+1), [1]), Ok([2]));
  (Some("Instr Test 3"), ((fun n -> n*2), [1]), Ok([2]));
  (Some("Instr Test 4"), ((fun n -> n/10), [1;2;3;4;5;]), Ok([0;0;0;0;0;]));
])

(* Fold Left-right tests *)

let instr_fold_left_tests = ("Fold Left", fold_left, (=), eq_exn, Some((fun (_,s,l) -> Printf.sprintf "(f,%s,%s)" s (str_int_list l)),(fun x -> x)), [
  
])

let instr_fold_left_int_tests = ("Fold Left", fold_left, (=), eq_exn, Some((fun (_,i,l) -> Printf.sprintf "(f,%d,%s)" i (str_int_list l)),string_of_int), [
  (Some("simple list"), ((fun (x,y) -> x+y),100,[1;2;3;4;5]), Ok(115))
])

let instr_fold_right_tests = ("Fold Right", fold_right, (=), eq_exn, Some((fun (_,l,s) -> Printf.sprintf "(f,%s,%s)" (str_int_list l) s),(fun x -> x)), [
  
])

let instr_filter_tests = ("Filter", filter, (=), eq_exn, Some((fun (_,l) -> str_int_list l),str_int_list), [
  
])

(******************************)
(*      Binary Tree Tests     *)
(******************************)

let printer = Some((fun (t,d,s) -> Printf.sprintf "(%s,%d,%s)" (str_binary_tree t) d (str_binary_tree s)),str_binary_tree)

let instr_replace_tests = ("Replace", (replace : (binary_tree * int * binary_tree) -> binary_tree), ((=) : binary_tree -> binary_tree -> bool), eq_exn, printer, [

])

let instr_get_max_tests = ("Get Max", (get_max : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
  
])

let instr_get_min_tests = ("Get Min", (get_min : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
  
])

let instr_is_bst_tests = ("Is BST", is_bst, (=), eq_exn, Some(str_binary_tree,str_bool), [
  
])

let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_binary_tree)

let instr_insert_bst_tests = ("Insert BST", insert_bst, (=), eq_exn, printer, [

])

let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_bool)

let instr_search_bst_tests = ("Search BST", search_bst, (=), eq_exn, printer, [

])
