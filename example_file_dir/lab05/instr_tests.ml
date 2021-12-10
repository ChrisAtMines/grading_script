(******************************)
(*   List Processing Tests    *)
(******************************)

(* Func Test *)
let instr_expr_eval_tests = ("Instructor Expression Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [

  (None, parse_string "(54321 + 0 ) + 2", Ok(NumVal(54323.0)));
  (None, parse_string "const x = 1; true? x : 2", Ok(NumVal(1.0)));
  (None, parse_string "\"a\" + \"Jimbothy\"", Ok(StrVal("aJimbothy")));
  (None, parse_string "1 + true",                     Ok(NumVal(2.0)));
])

let instr_func_eval_tests = ("Function Definition Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [
  (Some("Func Printing"), parse_string "const f = (function fun(x){return x}); console.log(f)", Ok(UndefVal)); 
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
  (Some("2 Arguments"), parse_string "const y = 1; function f(x) { return x + y }",
    Ok(ClosureVal(StringMap.empty, (
      Some("f"),
      [("x", None)],
      ReturnBlock(NoPos, BopExpr(NoPos, VarExpr(NoPos, "x"), PlusBop, VarExpr(NoPos, "y"))),
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
  (Some("No args"), parse_string "function f(x) { return 2 }",
    Ok(ClosureVal(StringMap.empty, (
      Some("f"),
      [("x", None)],
      ReturnBlock(NoPos, ValExpr(NoPos, NumVal(2.0))), 
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

(* Call Test *)
let instr_call_eval_tests = ("Instructor Call Evaluation", (fun p -> snd (eval (empty_env,p))), eq_value, eq_exn, Some(str_program,str_value), [
  (Some("Call"), parse_string "const f = function(x){return x+1}; f(1)",                    Ok(NumVal(2.0)));
  (Some("2 Args"), parse_string "const y = 1; const f = function(x){return x+y}; f(2)",            Ok(NumVal(3.0)));
  (Some("Scope 1"), parse_string "const y = 1; const f = function(x){return x+y}; f(2)",    Ok(NumVal(3.0)));
  (Some("Scope 2"), parse_string "const f = function(x){const y = 1; return x+y}; f(2)",    Ok(NumVal(3.0)));
  (Some("No Args"), parse_string "const f = function(x){return 1}; f(1)",                     Ok(NumVal(1.0)));
  (Some("recursion"), parse_string "const f = function t(x){return x===0 ? 0 : x+t(x-1)}; f(5)", Ok(NumVal(15.0)));
  (Some("recursion2"), parse_string "(function dec(x){return x > 0 ? x + dec(x-1) : 0 })(6)", Ok(NumVal(21.0)));
])


