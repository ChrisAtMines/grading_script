let instr_reverse_tests = ("Instructor Reverse", reverse, (=), eq_exn, Some(str_int_list, str_int_list), [
	(Some("Empty List"), [], Ok([]));
	(Some("One Element"), [1], Ok([1]));
	(Some("Odd Elements"), [1;2;3], Ok([3;2;1]));
	(Some("Even Elements"), [1;2;3;4], Ok([4;3;2;1]))
])

let instr_sort_tests = ("Instructor Sort", selection_sort, (=), eq_exn, Some(str_int_list, str_int_list), [
	(Some("Empty List"), [], Ok([]));
	(Some("One Element"), [1], Ok([1]));
	(Some("Negatives"), [-5;-3;-2;-4;-1], Ok([-5;-4;-3;-2;-1]))
	(*	(Some("Big Numbers"), [1234567, -1234567], Ok([-1234567, 1234567]))	*)
])

let instr_map_tests = ("Instructor Map", map, (=), eq_exn, Some((fun (_,l) -> str_int_list l), str_int_list), [
	(Some("Empty List"), ((fun n -> n+1),[]), Ok([]));
	(Some("One Element"), ((fun n -> n+1),[1]), Ok([2]));
	(Some("lambda"), ((fun n -> n), [1;2;3]), Ok([1;2;3]))
	(* TODO *)
])

let instr_fold_left_tests = ("Instructor Fold Left", fold_left, (=), eq_exn, Some((fun (_,s,l) -> Printf.sprintf "(f,%s,%s)" s (str_int_list l)), (fun x -> x)), [
	Some("Instructor Test x"), ((fun (acc, x) -> (acc^(string_of_int x))),"",[1;2;3;4;5], Ok("12345"))
	(* TODO *)
])

let instr_fold_right_tests = ("Instructor Fold Right", fold_right, (=), eq_exn, Some((fun (_,s,l) -> Printf.sprintf "(f,%s,%s)" s (str_int_list l)), (fun x -> x)), [
	Some("Instructor Test x"), ((fun (acc, x) -> (acc^(string_of_int x))),"",[1;2;3;4;5], Ok("12345"))
	(* TODO *)
])

let instr_filter_tests = ("Instructor Filter", filter, (=), eq_exn, Some((fun (_,l) -> str_int_list l), str_int_list), [
	(Some("simple list"), ((fun x -> (x > 3)),[1;4;2;5;3;6]), Ok[4;5;6])
	(* TODO *)
])

(***********************)
(** Binary Tree Tests **)
(***********************)
let printer = Some((fun (t,d,s) -> Printf.sprintf "(%s,%d,%s)" (str_binary_tree t) d (str_binary_tree s)),str_binary_tree)
let instr_replace_tests = ("Instructor Replace", (replace : (binary_tree * int * binary_tree) -> binary_tree), ((=) : binary_tree -> binary_tree -> bool), eq_exn, printer, [
	(Some("Test X"), (Node(Empty, 100, Empty), 100, make_leaf 200), Ok(Node(Empty,200,Empty)))
	(* TODO *)
])


let instr_get_max_tests = ("Instructor Get Max", (get_max : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
	(Some("simple tree"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(Some(30)))
	(* TODO *)
])

let instr_get_min_tests = ("Instructor Get Min", (get_min : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
	(Some("simple tree"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(Some(10)))
	(* TODO *)
])

let instr_is_bst_tests = ("Instructor Is BST", is_bst, (=), eq_exn, Some(str_binary_tree,str_bool), [
	(Some("simple non-BST"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(false));
	(Some("simple BST"), Node(Empty,10,Node(Node(Empty,19,Empty),20,Empty)), Ok(true))
])



let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_binary_tree)
let instr_insert_bst_tests = ("Instructor Insert BST", insert_bst, (=), eq_exn, printer, [
	(Some("simple BST"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 30), Ok(Node(Empty,10,Node(Node(Empty,15,Empty),20,Node(Empty,30,Empty)))))
])


let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_bool)
let instr_search_bst_tests = ("Instructor Search BST", search_bst, (=), eq_exn, printer, [
	(Some("simple BST not found"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 30), Ok(false));
	(Some("simple BST found"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 15), Ok(true))
])
