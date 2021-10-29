(* Eval tests *)
let instr_eval_tests = ("Evaluator", eval, eq_value, eq_exn, Some(str_expr,str_value), [
  (* Val expressions *)
  (Some("Instr_eval_1"), parse_expr "0",                Ok(NumVal(0.)));
  (Some("Instr_eval_2"), parse_expr "false",            Ok(BoolVal(false)));

  (* UopExpr *)
  (Some("Instr_eval_3"), parse_expr "!true",        Ok(BoolVal(false)));
  (Some("Instr_eval_4"), parse_expr "-5",           Ok(NumVal(-5.)));

  (* BopExpr *)
  (* arithmatetic *)
  (Some("Instr_eval_5"), parse_expr "100 + 23",        Ok(NumVal(123.)));
  (Some("Instr_eval_6"), parse_expr "100 - -23",        Ok(NumVal(123.)));
  (Some("Instr_eval_7"), parse_expr "100 / 20",        Ok(NumVal(5.)));
  (Some("Instr_eval_8"), parse_expr "100 * 23",        Ok(NumVal(2300.)));
  (Some("Instr_eval_9"), parse_expr "(100 + 20)/5 - 12*2 ",        Ok(NumVal(0.)));

  (* Boolean logic *)
  (Some("Instr_eval_10"), parse_expr "false === (true && (false || true) && (100 > 200))",        Ok(BoolVal(true)));
  (Some("Instr_eval_11"), parse_expr "false !== ( (50 < 70) && ( -5 <= -2 ) && (100 >= 100))",        Ok(BoolVal(true)));

  (* Undefined values *)
  (Some("Instr_eval_12"), parse_expr "true + false",        Ok(UndefVal));
  (Some("Instr_eval_13"), parse_expr "true && (false || (100 - 6 > 0) || -5)",        Ok(UndefVal));
  (Some("Instr_eval_14"), parse_expr "true && 100",        Ok(UndefVal));
  (Some("Instr_eval_15"), parse_expr "true + 100",        Ok(UndefVal));
  (Some("Instr_eval_16"), parse_expr "-false",        Ok(UndefVal));
  (Some("Instr_eval_17"), parse_expr "!100",        Ok(UndefVal));
])



(* Typecheck tests *)
let instr_typecheck_tests = ("Typechecker", typecheck, ((=) : typ_t option -> typ_t option -> bool), eq_exn, Some(str_expr,str_option str_typ), [
  (Some("Instr_typecheck_1"), parse_expr "100 === false",                Ok(None));
  (Some("Instr_typecheck_2"), parse_expr "100 / true",                   Ok(None));
  (Some("Instr_typecheck_3"), parse_expr "5 / 0 * -5",                       Ok(Some(NumType)));
  (Some("Instr_typecheck_4"), parse_expr "false !== ((5 <= 5) && (6 >= 6))", Ok(Some(BoolType)));
  (Some("Instr_typecheck_5"), parse_expr "false === (true && (false || true) && (100 > 200))",        Ok(Some(BoolType)));
  (Some("Instr_typecheck_6"), parse_expr "true && (false || (100 - 6 > 0) || -5)",        Ok(None));
  (Some("Instr_typecheck_7"), parse_expr "(100 && 100) || true ",                   Ok(None));
])

