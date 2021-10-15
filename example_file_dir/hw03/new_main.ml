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
  | (Hw03) ->
    reset_test_counts ();
    let _ = list_check Hw03.extract_tests_int in
    let _ = list_check Hw03.extract_tests_char in
    let _ = list_check Hw03.simple_lexer_tests in
    let _ = list_check Hw03.simple_parser_tests in
    let _ = list_check Hw03.lexer_tests in
    let _ = list_check Hw03.parser_tests in
    let _ = list_check Hw03.instr_lexer_tests in
    let _ = list_check Hw03.instr_parser_tests in
    get_test_counts acc
  ) (0,0) !Flags.mode) in
  let _ = Printf.printf "total = %d; failed = %d\n" total failed in
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
      | _ -> fun _ -> failwith (Printf.sprintf "S-Expression test input format not supported for assignment: %s" (Flags.get_assignment_name a))
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
    | Hw03 ->
      let cl = Hw03.string_to_char_list input_str in
      let tokens = Hw03.lexer cl in
      let (ast,l) = Hw03.parser tokens in
      Printf.sprintf "lexed:  %s\nparsed: %s; %s\n" (Hw03.str_token_list tokens) (str_option Javascript_ast.str_expr ast) (Hw03.str_token_list l)
    ) in
    Printf.printf "%s\n" result
  ) !Flags.mode;
  0 (* exit status *)
) in
exit exit_status
