(* Sum tests *)

let instr_sum_tests = ("Instructor Tests", sum, (=), eq_exn, Some(string_of_int, string_of_int), [
  (Some("Test 1"), 4, Ok(30));
  (Some("Test 2"), 8, Ok(510));
  (Some("Test 3"), 12, Ok(8190));
  (Some("Test Big"), 49, Ok(1125899906842622));
  (Some("Test  Negative"), -1, Ok(0));
  (Some("Test  One"), 0, Ok(0));
])

(* Tree tests *)

let instr_tree_1 = Node( Node(  Node( Leaf(1), 3, Leaf(2) ), 7, Node( Leaf(4), 6, Leaf(5))), 8, Node( Leaf(9), 11, Leaf(10)))

let instr_tree_2 = Leaf(1)

let instr_tree_3 = Node(Leaf(15), 19, Node(Leaf(16), 18, Leaf(17)))

let instr_tree_4 = Node( instr_tree_1, 20, instr_tree_3 )

let instr_traverse2_pre_tests = ("Instructor traverse2_pre", traverse2_pre, (=), eq_exn, Some(str_tree, str_int_list), [
  (Some("Test traverse2_pre 1"), instr_tree_1, Ok([8;7;3;1;2;6;4;5;11;9;10]));
  (Some("Test traverse2_pre 2"), instr_tree_2, Ok([1]));
  (Some("Test traverse2_pre 3"), instr_tree_3, Ok([19; 15; 18; 16; 17]));
  (Some("Test traverse2_pre 4"), instr_tree_4, Ok([20;8;7;3;1;2;6;4;5;11;9;10;19;15;18;16;17]));
])

let instr_traverse2_post_tests = ("Instructor traverse2_post", traverse2_post, (=), eq_exn, Some(str_tree, str_int_list), [
  (Some("Test traverse2_post 1"), instr_tree_1, Ok([1;2;3;4;5;6;7;9;10;11;8]));
  (Some("Test traverse2_post 2"), instr_tree_2, Ok([1]));
  (Some("Test traverse2_post 3"), instr_tree_3, Ok([15;16;17;18;19]));
  (Some("Test traverse2_post 4"), instr_tree_4, Ok([1;2;3;4;5;6;7;9;10;11;8;15;16;17;18;19;20]));
])
