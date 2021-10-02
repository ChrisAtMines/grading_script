(******************************)
(*   List Processing Tests    *)
(******************************)

(* Reverse Tests *)

let instr_reverse_tests = ("Instructor Reverse Tests", reverse, (=), eq_exn, Some(str_int_list, str_int_list), [
  (Some("Instr Test 1"), [], Ok([]));
  (Some("Instr Test 2"), [1], Ok([1]));
  (Some("Instr Test 3"), [1;2], Ok([2;1]));
  (Some("Empty List"), [], Ok([]));
  (Some("One Element"), [1], Ok([1]));
  (Some("Odd Elements"), [1;2;3], Ok([3;2;1]));
  (Some("Even Elements"), [1;2;3;4], Ok([4;3;2;1]))
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
  (Some("lambda"), ((fun n -> n), [1;2;3]), Ok([1;2;3]));
])

(* Fold Left-right tests *)

let instr_fold_left_tests = ("Fold Left", fold_left, (=), eq_exn, Some((fun (_,s,l) -> Printf.sprintf "(f,%s,%s)" s (str_int_list l)),(fun x -> x)), [
  (Some("Instructor Test x"), ((fun (acc, x) -> (acc^(string_of_int x))),"a",[1;2;3;4;5]), Ok("a12345"));    
  (None, ((fun(acc,x) -> ((string_of_int x)^acc)), " mississippi,", [1;2]), Ok"21 mississippi,");
  (None, ((fun(acc,x) -> ((string_of_int x)^acc)), "", [1;6;9;10]), Ok"10961");
  (None, ((fun(acc,x) -> (acc^(string_of_int x)^acc)), "0", [1;2]), Ok"0102010");
  (None, ((fun(acc,x) -> ((string_of_int x)^acc)), "", [1;5;9;1]), Ok"1951");
  (None, ((fun(acc,x) -> ((string_of_int x)^acc)), "", []), Ok"");


])

let instr_fold_left_int_tests = ("Fold Left", fold_left, (=), eq_exn, Some((fun (_,i,l) -> Printf.sprintf "(f,%d,%s)" i (str_int_list l)),string_of_int), [
  (Some("simple list"), ((fun (x,y) -> x+y),100,[1;2;3;4;5]), Ok(115));
  (Some("factorial"), ((fun (x,y) -> x*y), 1, [1;2;3;4;5]), Ok(120));
  (Some("div"), ((fun (x,y) -> x/y), 1, [1;2;3;4;5]), Ok(0));
])

let instr_fold_right_tests = ("Fold Right", fold_right, (=), eq_exn, Some((fun (_,l,s) -> Printf.sprintf "(f,%s,%s)" (str_int_list l) s),(fun x -> x)), [
  (Some("Instructor Test x"), ((fun  (x, acc) -> (acc^(string_of_int x))),[1;2;3;4;5], ""), Ok("54321"));
  (Some("Instructor Test y"), ((fun  (x, acc) -> ((string_of_int x)^acc)),[1;2;3;4;5], ""), Ok("12345"));
  (Some("Instructor Test z"), ((fun  (x, acc) -> (acc^(string_of_int x))),[1;2;3], "apple"), Ok("apple321"));
  (Some("Empty List"), ((fun  (x, acc) -> (acc^(string_of_int x))),[], ""), Ok(""));
])

let instr_filter_tests = ("Filter", filter, (=), eq_exn, Some((fun (_,l) -> str_int_list l),str_int_list), [
  (Some("simple list"), ((fun x -> (x > 3)),[1;4;2;5;3;6]), Ok[4;5;6]);
  (Some("even list"), ((fun x -> (x mod 2 = 0)),[1;4;2;5;3;6]), Ok[4;2;6]);
  (Some("two conditions"), ((fun x -> (x < 0 && x > -5)),[-10;-7;-5;-4;-1;1;2]), Ok[-4;-1]);
  (Some("simple list"), ((fun x -> (x > 3)),[]), Ok[]);
])

(******************************)
(*      Binary Tree Tests     *)
(******************************)
let b_tree1 = Node( Node(Empty,1,Empty), 2, Node(Empty, 3, Empty))
let b_tree2 = Node( Node(Empty,5,Empty), 6, Node(Empty, 7, Empty))
let b_tree3 = Node( b_tree1, 4, b_tree2 )

let b_tree4 = Node( Node(Empty,9,Empty), 10, Node(Empty, 11, Empty))
let b_tree5 = Node( Node(Empty,13,Empty), 14, Node(Empty, 15, Empty))
let b_tree6 = Node( b_tree4, 12, b_tree5 )

let b_tree = Node( b_tree3, 8, b_tree6 )
let not_b_tree = Node( b_tree3, 8, Node(b_tree4, 12, make_leaf 12))

let printer = Some((fun (t,d,s) -> Printf.sprintf "(%s,%d,%s)" (str_binary_tree t) d (str_binary_tree s)),str_binary_tree)

let instr_replace_tests = ("Replace", (replace : (binary_tree * int * binary_tree) -> binary_tree), ((=) : binary_tree -> binary_tree -> bool), eq_exn, printer, [
  (Some("Test X"), (Node(Empty, 100, Empty), 100, make_leaf 200), Ok(Node(Empty,200,Empty)));
  (Some("No Replacement"), (b_tree3, 100, make_leaf 200), Ok(b_tree3));
  (None, (b_tree3, 1, make_leaf 200), Ok(Node( Node( Node (Empty, 200, Empty), 2, Node(Empty, 3, Empty)), 4, b_tree2)));
])

let instr_get_max_tests = ("Get Max", (get_max : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
  (Some("simple tree"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(Some(30)));
  (Some("max 2"), b_tree, Ok(Some(15)));
  (Some("max none"), Empty, Ok(None));
])

let instr_get_min_tests = ("Get Min", (get_min : binary_tree -> data option), ((=) : data option -> data option -> bool), eq_exn, Some(str_binary_tree,str_option string_of_int), [
  (Some("simple tree"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(Some(10)));
  (Some("max 2"), b_tree, Ok(Some(1)));
  (Some("min none"), Empty, Ok(None));
])

let instr_is_bst_tests = ("Is BST", is_bst, (=), eq_exn, Some(str_binary_tree,str_bool), [
  (Some("simple non-BST"), Node(Empty,10,Node(Node(Empty,30,Empty),20,Empty)), Ok(false));
    (Some("simple BST"), Node(Empty,10,Node(Node(Empty,19,Empty),20,Empty)), Ok(true));
    (Some("Big BST"), b_tree, Ok(true));
    (Some("Not BST"), not_b_tree, Ok(false));
])

let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_binary_tree)

let instr_insert_bst_tests = ("Insert BST", insert_bst, (=), eq_exn, printer, [
  (Some("simple BST"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 30), Ok(Node(Empty,10,Node(Node(Empty,15,Empty),20,Node(Empty,30,Empty)))));
  (Some("big BST"), (b_tree, 30), Ok( Node( b_tree3, 8, Node( b_tree4, 12, Node ( Node(Empty,13,Empty), 14, Node(Empty, 15, Node (Empty, 30, Empty ) ) ))) ) );
  (Some("same tree"), (b_tree, 7), Ok( b_tree ));
])

let printer = Some((fun (a,b) -> Printf.sprintf "(%s,%d)" (str_binary_tree a) b),str_bool)

let instr_search_bst_tests = ("Search BST", search_bst, (=), eq_exn, printer, [
  (Some("simple BST not found"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 30), Ok(false));
    (Some("simple BST found"), (Node(Empty,10,Node(Node(Empty,15,Empty),20,Empty)), 15), Ok(true));
    (Some("big BST found"), (b_tree, 9), Ok(true));
    (Some("big BST not found"), (b_tree, 0), Ok(false));
])
