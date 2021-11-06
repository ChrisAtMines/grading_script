(* Eval tests print/if expr *)
let instr_eval_print_if_tests = ("Instructor Print/If tests", (fun p -> eval (empty_env,p)), eq_value, eq_exn, Some(str_program,str_value), [
    (Some("Instr print/if 1"), parse_string "console.log( -1 > 0 ? \"Test failed\" : \"--------------Test passed\n\" )", Ok(UndefVal) );
    (Some("Instr print/if 2"), parse_string "console.log( console.log(\"----------------Value should be 5 :  \" + 5 + \"\n\") )", Ok(UndefVal) );
    (Some("Instr print/if 3"), parse_string "console.log(\"---------------Value should be 16 : \") ? \"Test failed\" : console.log((5 > 1)*16 + \"\n\")", Ok(UndefVal) );
    (Some("Instr print/if 4"), parse_string "426 !== 426 ? !true + -5 : !false - -100 ", Ok(NumVal(101.0)) );
    (Some("Instr print/if 5"), parse_string "426 >= 426 ? !true + -5 : !false - -100 ", Ok(NumVal(-5.0)) );
])

(* Eval strings *)
let instr_eval_strings = ("Instructor String eval tests", (fun p -> eval (empty_env,p)), eq_value, eq_exn, Some(str_program,str_value), [
    (Some("Instr String 1"), parse_string "\"Hello\" <= \"hello\"", Ok(BoolVal(true)));
    (Some("Instr String 2"), parse_string "\"H\" + \"i\" + 5", Ok(StrVal("Hi5")));
    (Some("Instr String 3"), parse_string "\"H\" + \"i\" + true", Ok(StrVal("Hitrue")));
    (Some("Instr String 4"), parse_string "\"H\" + \"i\" === \"Hi\"", Ok(BoolVal(true)));
    (Some("Instr String 5"), parse_string "false + true + \"\"", Ok(StrVal("1")));
  ])

(* Eval consts variables *)
let instr_eval_const = ("Instructor Const eval tests", (fun p -> eval (empty_env,p)), eq_value, eq_exn, Some(str_program,str_value), [
    (Some("Instr Const 1"), parse_string "const x = 20; const x = 2; x",            Ok(NumVal(2.0)));
    (Some("Instr Const 2"), parse_string "const x = 20; const y = true; y >= x ? !y : !(-0)",            Ok(BoolVal(true)));
    (Some("Instr Const 3"), parse_string "const str = \"-------------Test pass\"; const x = console.log(str); x",            Ok(UndefVal));
    (Some("Instr Const 4"), parse_string "const t = \"Fizz\"; const x = t + \"Buzz\"; x + t",            Ok(StrVal("FizzBuzzFizz")));
    (Some("Instr Const 5"), parse_string "const x = 100; const y = 200; const z = x + y; const a = z/x >= 2; const b = z/y <= 10; b - a ",            Ok(NumVal(0.0)));

  ])
