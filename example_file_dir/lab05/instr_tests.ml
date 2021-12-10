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
  (Some("Closure Val"), parse_string "function f(x){ return x } ",
    Ok(ClosureVal(StringMap.empty, (
      Some("f"),
      [("x", None)], 
      ReturnBlock(NoPos, VarExpr(NoPos, "x")),
      None
    )))
  );
  (Some("Statement Block"), parse_string "function f(x){const z = 1; return z + x}",
    Ok(ClosureVal(StringMap.empty, (
      Some("f"),
      [("x", None)],
      StmtBlock(NoPos, ConstStmt(NoPos, "z", ValExpr(NoPos, NumVal(1.0))),
        ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "z"), PlusBop, VarExpr(NoPos, "x")))
      ),
      None
    )))
  );
  (Some("No name"), parse_string "function (x) { return x }",
    Ok(ClosureVal(StringMap.empty, (
      None,
      [("x", None)],
      ReturnBlock(NoPos, VarExpr(NoPos, "x")), 
      None
    )))
  ); 
  (Some("No args"), parse_string "function f(x) { return x === 1 }",
    Ok(ClosureVal(StringMap.empty, (
      Some("f"),
      [("x", None)],
      ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos,"x"), EqBop, ValExpr(NoPos, NumVal(1.0)))), 
      None
    )))
  ); 
  (Some("Dec"), parse_string "function dec(x) { return x > 0 ? x + dec(x-1) : 0 }",
    Ok(ClosureVal(StringMap.empty, (
      Some("dec"),
      [("x", None)],
      ReturnBlock(NoPos, 
        IfExpr(NoPos, 
          BopExpr(NoPos,
            VarExpr(NoPos, "x"), 
            GtBop, 
            ValExpr(NoPos, NumVal(0.0))
            ), 
          BopExpr(NoPos, 
            VarExpr(NoPos,"x"), 
            PlusBop, 
            CallExpr(NoPos, 
              VarExpr(NoPos, "dec"), 
              [BopExpr(NoPos, 
                VarExpr(NoPos,"x"), 
                MinusBop, 
                ValExpr(NoPos,NumVal(1.0))
              )]
            )
          ), 
          ValExpr(NoPos, NumVal(0.0))
        )), 
      None
    )))
  ); 
])

let instr_call_eval_tests = ("Instr Call Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [
    (None, parse_string "const x = 5; const f = function(y){return x+y}; (function(z){const x = 7; return f(6)})(0)", Ok(NumVal(11.0)));
    (None, parse_string "const x = 5; (function(y){return x+y})(6)", Ok(NumVal(11.0)));
    (None, parse_string "const x = 5; const f = function(y){return x+y}; f(6)", Ok(NumVal(11.0)));
    (None, parse_string "(function(y){return 5+y})(6)", Ok(NumVal(11.0)));
    (None, parse_string "const f = function(y){return 5+y}; f(6)", Ok(NumVal(11.0)))
])
