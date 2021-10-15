(* Lexer tests *)
let instr_lexer_tests = ("Instructor Lexer Tests", lexer, ((=) : token list -> token list -> bool), eq_exn, Some(char_list_to_string,str_token_list), [
  (None, string_to_char_list "1.234truefalse  \"one two\"123", Ok[NumToken("1.234"); KeywordToken("true"); KeywordToken("false"); StrToken("one two"); NumToken("123")]);
])
 
(* Parser tests *)
let printer = Some(str_token_list,(fun (eo,l) -> Printf.sprintf "%s; %s" (str_option str_expr eo) (str_token_list l)))
let instr_parser_tests = ("Simple Parser", parser, ((=) : (expr_t option * token list) -> (expr_t option * token list) -> bool), eq_exn, printer, [
  (None, [NumToken("123");OpToken("-");NumToken("23")], Ok(Some(BopExpr(NoPos,ValExpr(NoPos,NumVal(123.0)),MinusBop,ValExpr(NoPos,NumVal(23.0)))),[]));
  (None, lexer (string_to_char_list "1 + 2 + 3 * 5 + 6"), Ok(Some(BopExpr(NoPos,ValExpr(NoPos,NumVal(1.0)),PlusBop,BopExpr(NoPos,ValExpr(NoPos,NumVal(2.0)),PlusBop,BopExpr(NoPos,BopExpr(NoPos,ValExpr(NoPos,NumVal(3.0)),TimesBop,ValExpr(NoPos,NumVal(5.0))),PlusBop,ValExpr(NoPos,NumVal(6.0)))))),[]))
])

