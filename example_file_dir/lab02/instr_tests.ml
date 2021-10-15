(* Eval tests *)
let eval_tests = ("Evaluator", eval, eq_value, eq_exn, Some(str_expr,str_value), [
  (None, parse_expr "45 + false",               Ok(UndefVal));
  (None, parse_expr "false !== true",           Ok(BoolVal(true)));
  (None, parse_expr "100 && 200",               Ok(UndefVal));
  (None, parse_expr "!false",                   Ok(BoolVal(true)));
  (None, parse_expr "3 * (4 * 5)",              Ok(NumVal(60.0)));
  (None, parse_expr "-6 * 90 / 8",              Ok(NumVal(-67.5)));
  (None, parse_expr "-100 + -50",               Ok(NumVal(-150.0)));

])



(* Typecheck tests *)
let typecheck_tests = ("Typechecker", typecheck, ((=) : typ_t option -> typ_t option -> bool), eq_exn, Some(str_expr,str_option str_typ), [
  (None, parse_expr "random",                           Error(UnimplementedExpr(VarExpr(NoPos,"random"))));
  (None, parse_expr "100 === random < 5",               Error(UnimplementedExpr(VarExpr(NoPos,"random"))));
  (None, parse_expr "false || (true && false)",         Ok(Some(BoolType)));
  (None, parse_expr "5 / 0 * -5",                       Ok(Some(NumType)));
  (None, parse_expr "false !== ((5 <= 5) && (6 >= 6))", Ok(Some(BoolType)));
])

