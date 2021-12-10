open Javascript_ast
open Javascript_main
open Flags
open Testing

let col_width = 70

(* https://stackoverflow.com/a/61348066/1613162 *)
let my_really_read_string in_chan =
    let res = Buffer.create 1024 in
    let rec loop () =
        match input_line in_chan with
        | line ->
            Buffer.add_string res line;
            Buffer.add_string res "\n";
            loop ()
        | exception End_of_file -> Buffer.contents res
    in
    loop ()

let get_channel i =
  let i = (match i with
  | Some(i) -> Printf.printf "reading from file...\n"; i
  | None -> Printf.printf "reading from stdin (press CTRL+D when finished)...\n"; flush stdout; stdin) in
  i

let get_input_ast i =
  let result = get_ast (get_channel i) in
  result

let get_input_str i =
  let i = get_channel i in
  my_really_read_string i

let _ =
let i = parse_command_line () in 
(* run unit tests *)
let exit_status = if !Flags.test && List.length !Flags.mode > 0 then (
  let (total,failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.simple_expr_eval_tests in
    let _ = list_check Lab05.simple_func_eval_tests in
    let _ = list_check Lab05.simple_call_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in

(* student tests *)
  let (total_expr,expr_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.expr_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in
  let (total_func,func_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.func_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in
  let (total_call,call_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.call_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in

(* instr tests *)
  let (_,instr_expr_eval_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.instr_expr_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in
  
  let (_,instr_func_eval_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.instr_func_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in

  let (_,instr_call_eval_failed) = 
  (List.fold_left (fun acc mode ->
  Printf.printf "running %s tests...\n" (get_assignment_desc mode);
  match mode with
  | (Lab05) ->
    reset_test_counts ();
    let _ = list_check Lab05.instr_call_eval_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in


  let _ = Printf.printf "total = %d; failed = %d\n" total failed in
  
  if total_expr < 3 
  then Printf.printf "Func Eval missing tests = %d    -%d pts\n" (2 - total_expr) (5 - total_expr*2);
  let _ = Printf.printf "Studt Func Eval failed  = %d    -%d pts\n" expr_failed (expr_failed*2) in
  if total_func < 2 
  then Printf.printf "Func Eval missing tests = %d    -%d pts\n" (2 - total_func) (5 - total_func*2);
  let _ = Printf.printf "Studt Func Eval failed  = %d    -%d pts\n" func_failed (func_failed*2) in
  if total_call < 5
  then Printf.printf "Call Eval missing tests = %d    -%d pts\n" (5 - total_call) (5 - total_call); 
  let _ = Printf.printf "Studt Call Eval failed  = %d    -%d pts\n" call_failed (call_failed) in

  let _ = Printf.printf "Instr Expr Eval failed  = %d    -%d pts\n" instr_expr_eval_failed  (instr_expr_eval_failed*5) in 
  let _ = Printf.printf "Instr Func Eval failed  = %d    -%d pts\n" instr_func_eval_failed (instr_func_eval_failed*5) in
  let _ = Printf.printf "Instr Call Eval failed  = %d    -%d pts\n" instr_call_eval_failed  (instr_call_eval_failed*5) in 

  if failed > 0 then 1 else 0 (* exit status *)
) else if !Flags.test then (
  let input_str = get_input_str i in
  (*Printf.printf "input_str = %s\n" input_str;*)
  let input_tests = parse_test input_str in
  let (_,result) = List.fold_left (fun (index,acc) (mode, flags, test_func, test_group, test_name, input, expected_output) ->
    let test_group = (match test_group with Some(s) -> Printf.sprintf ": %s" s | None -> "") in
    let test_name = if (StringSet.mem "private" flags) then ": [secret]" else (match test_name with Some(s) -> ": "^s | None -> "") in
    (*Printf.printf "str_sexp on input = %s\n" (str_sexp input);*)
    let (total,failed) = (try StringMap.find mode acc with Not_found -> (0,0)) in
    let a = Flags.get_assignment mode in
    let desc = Flags.get_assignment_desc a in
    let str = Printf.sprintf "%3d Test %s: %s.%s%s%s..." index desc (String.capitalize_ascii mode) test_func test_group test_name in
    let space = (try String.make (col_width - (String.length str)) ' ' with Invalid_argument(_) -> " ") in
    let f = (match a with
      | Lab05 -> Lab05.run_test
    ) in
    let output = f (test_func, test_name, input) in
    Printf.printf "%s%s" str space;
    (*Printf.printf "s-expression in: %s\n" (str_sexp input);
    Printf.printf "s-expression out: %s\n" (str_sexp output);*)
    let b = (eq_sexp expected_output output) in
    let success = b in
    if success then Printf.printf "pass\n" else Printf.printf "FAIL\n";
    if not b && not (StringSet.mem "private" flags) then Printf.printf "  input: %s\n  expected: %s\n  received: %s\n" (str_sexp input) (str_sexp expected_output) (str_sexp output);
    let (total,failed) = (total+1, failed+(if success then 0 else 1)) in
    (index+1, StringMap.add mode (total,failed) acc)
  ) (1,StringMap.empty) input_tests in
  let (total,failed) = List.fold_left (fun (acc_total,acc_failed) (mode,(total,failed)) ->
    let _ = Printf.printf "[%s] total = %d; failed = %d\n" mode total failed in
    (acc_total+total, acc_failed+failed)
  ) (0,0) (StringMap.bindings result) in
  (*Printf.printf "num passed = %s\n" (str_x_list (fun (k,(n1,n2)) -> Printf.sprintf "%s->(%d,%d)" k n1 n2) (StringMap.bindings result) ", ")*)
  if failed > 0 then 1 else 0 (* exit status *)
) else (
  let input_str = get_input_str i in
  List.iter (fun mode ->
    Printf.printf "Running %s...\n" (get_assignment_desc mode);
    let result = (match mode with
    | (Lab05) ->
      let input_ast = parse_string input_str in
      Printf.printf "parse input: %s\n" (Javascript_ast.str_program input_ast);
      let (final_env,v) = Lab05.eval (empty_env,input_ast) in
      let v_num = to_num v in
      let v_bool = to_bool v in
      let v_str = to_str v in
      let eval = Javascript_ast.str_value v in
      Printf.sprintf "------------------------------\nEVAL:    %s\nenv:     %s\n------------------------------\nto_num:  %s\nto_bool: %s\nto_str:  %s\n"(*"\nfinal env:\n%s\n"*)
        eval (str_environment_simple final_env) (str_float v_num) (string_of_bool v_bool) v_str (*(str_option str_environment !Lab04.final_env)*)
    ) in
    Printf.printf "%s\n" result
  ) !Flags.mode;
  0 (* exit status *)
) in
exit exit_status

