(******************************)
(*   Small Step Eval          *)
(******************************)

let instr_expr_eval_tests = ("Instr Simple Expression Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [
    (None, parse_string "(1 === 0) ? 3 : 4", Ok(NumVal(4.0))); 
    (None, parse_string "const x = 1; x + 1", Ok(NumVal(2.0)));
    (None, parse_string "const x = true; x ? 3 : 4", Ok(NumVal(3.0)));
    (None, parse_string "const x = (5 === 5); x ? 3 : 4", Ok(NumVal(3.0)));
    (None, parse_string "const x = 1 + 2; x - 3", Ok(NumVal(0.0)))
])

let instr_func_eval_tests = ("Instr Function Definition Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [ 
    (None, parse_string "function(x){ return x+1 }", Ok(ClosureVal(
            (StringMap.empty),
            (None,
            [("x", None)],
            ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "x"), PlusBop, ValExpr(NoPos, NumVal(1.0)))),
            None)
    )));
    (None, parse_string "function f(x){ return x+1 }", Ok(ClosureVal(
            (StringMap.empty),
            (Some("f"),
            [("x", None)],
            ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "x"), PlusBop, ValExpr(NoPos, NumVal(1.0)))),
            None)
    )));
    (None, parse_string "const y = 1; function(x){ return x+1 }", Ok(ClosureVal(
            (StringMap.add "y" 1 StringMap.empty),
            (None,
            [("x", None)],
            ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "x"), PlusBop, ValExpr(NoPos, NumVal(1.0)))),
            None)
    )));
    (None, parse_string "const y = 1; const z = 2; function(x){ return x+1 }", Ok(ClosureVal(
            (StringMap.add "z" 2 (StringMap.add "y" 1 StringMap.empty)),
            (None,
            [("x", None)],
            ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "x"), PlusBop, ValExpr(NoPos, NumVal(1.0)))),
            None)
    )));
])

let instr_call_eval_tests = ("Instr Call Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [
    (None, parse_string "const x = 5; const f = function(y){return x+y}; (function(z){const x = 7; return f(6)})(0)", Ok(NumVal(11.0)));
    (None, parse_string "const x = 5; (function(y){return x+y})(6)", Ok(NumVal(11.0)));
    (None, parse_string "const x = 5; const f = function(y){return x+y}; f(6)", Ok(NumVal(11.0)));
    (None, parse_string "(function(y){return 5+y})(6)", Ok(NumVal(11.0)));
    (None, parse_string "const f = function(y){return 5+y}; f(6)", Ok(NumVal(11.0)))
])
