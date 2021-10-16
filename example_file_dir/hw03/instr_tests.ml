(* Lexer tests *)
let instr_lexer_tests = ("Instructor Lexer Tests", lexer, ((=) : token list -> token list -> bool), eq_exn, Some(char_list_to_string,str_token_list), [
  (* keywords *)
  (Some("Instr_lexer_1"), string_to_char_list "true", Ok[KeywordToken("true")]); 
  (Some("Instr_lexer_2"), string_to_char_list "false", Ok[KeywordToken("false")]);
 
  (* numbers *)
  (Some("Instr_lexer_3"), string_to_char_list "100", Ok[NumToken("100")]);
  (Some("Instr_lexer_4"), string_to_char_list "100.72", Ok[NumToken("100.72")]);

  
  (* operators *)
  (Some("Instr_lexer_5"), string_to_char_list "+", Ok[OpToken("+")]);
  (Some("Instr_lexer_6"), string_to_char_list "-", Ok[OpToken("-")]);
  (Some("Instr_lexer_7"), string_to_char_list "||", Ok[OpToken("||")]);
  (Some("Instr_lexer_8"), string_to_char_list "*", Ok[OpToken("*")]);
  (Some("Instr_lexer_9"), string_to_char_list "/", Ok[OpToken("/")]);
  (Some("Instr_lexer_10"), string_to_char_list "&&", Ok[OpToken("&&")]);

  (* strings *)
  (Some("Instr_lexer_11"), string_to_char_list "\"this is a test string\"", Ok[StrToken("this is a test string")]);

  (* combonations *)
  (Some("Instr_lexer_12"), string_to_char_list "-100", Ok[OpToken("-");NumToken("100")]);
  (Some("Instr_lexer_13"), string_to_char_list "7 -100", Ok[NumToken("7");OpToken("-");NumToken("100")]);
  (Some("Instr_lexer_14"), string_to_char_list "true || 100 - false* \"test\"" , Ok[KeywordToken("true");OpToken("||");NumToken("100");OpToken("-");KeywordToken("false");OpToken("*");StrToken("test")]);
])
 
(* Parser tests *)
(* For simplifying reading *)
let vale = fun v -> ValExpr(NoPos, v)
let bope = fun (e1, b, e2) -> BopExpr(NoPos, e1, b, e2)
let uope = fun (u, e) -> UopExpr(NoPos, u, e)

(* load in a good version of the lexer for parser_tests *)
let rec lexer = fun stream -> match stream with
| [] -> []
| 't'::'r'::'u'::'e'::more -> KeywordToken("true")::(lexer more)
| 'f'::'a'::'l'::'s'::'e'::more->KeywordToken("false")::(lexer more)
| '-'::more -> OpToken("-")::(lexer more)
| '!'::more -> OpToken("!")::(lexer more)
| '*'::more -> OpToken("*")::(lexer more)
| '/'::more -> OpToken("/")::(lexer more)
| '|'::'|'::more -> OpToken("||")::(lexer more)
| '&'::'&'::more -> OpToken("&&")::(lexer more)
| '+'::more -> OpToken("+")::(lexer more)
| ' '::more -> (lexer more)
| '\t'::more -> (lexer more)
| '\r'::more -> (lexer more)
| '\n'::more -> (lexer more)
| '"'::more ->
  let (x,y) = extract (more,fun x -> x<>'"') in
  StrToken(char_list_to_string x)::(match y with [] -> [] | _::more -> lexer more)
| _ -> let (x,y) = extract (stream, fun x -> is_digit(x) || x == '.') in NumToken(char_list_to_string x)::(lexer y)


let printer = Some(str_token_list,(fun (eo,l) -> Printf.sprintf "%s; %s" (str_option str_expr eo) (str_token_list l)))
let instr_parser_tests = ("Instr Parser Tests", parser, ((=) : (expr_t option * token list) -> (expr_t option * token list) -> bool), eq_exn, printer, [
  (Some"Instr Parse_1", lexer (string_to_char_list "10 && !\"string\" - false || !5"), Ok(Some(
    bope(
      bope(
        vale(NumVal(10.0)),
        AndBop,
        uope(
          NotUop,
          vale(StrVal("string")))
      ),
      MinusBop,
      bope(
        vale(BoolVal(false)),
        OrBop,
        uope(
          NotUop,
          vale(NumVal(5.0)))
      )
    )),[]));

  
  (Some"Instr Parse_2", lexer (string_to_char_list "1 + !false"), Ok(Some(
    bope( 
      vale(NumVal(1.0)),
      PlusBop,
      uope(
        NotUop, 
        vale(BoolVal(false)))
  )),[]));

  (Some"Instr Parse_3", lexer (string_to_char_list "false"), Ok(Some(
    vale(BoolVal(false))),[]));

  (Some"Instr Parse_4", lexer (string_to_char_list ""), Ok(None,[]));
])

