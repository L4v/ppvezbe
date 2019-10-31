%{
  #include <stdio.h>
  #include "defs.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  extern int yylineno;
%}

%token _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _ID
%token _INT_NUMBER
%token _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _AROP
%token _LOGOP
%token _POSTINC
%token _RELOP
%token _DO
%token _WHILE
%token _COMMA

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
  ;

function_list
  : function
  | function_list function
  ;

function
  : type _ID _LPAREN parameter _RPAREN body
  ;

type
  : _TYPE
  ;

parameter
  : /* empty */
  | type _ID
  ;

body
  : _LBRACKET variable_list statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : type ids _SEMICOLON
  ;

ids
: _ID
| ids _COMMA _ID
;
statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | post_inc_statement
  | if_statement
  | return_statement
  | do_while_statement
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
  ;

post_inc_statement
: post_inc _SEMICOLON

num_exp
  : exp
  | num_exp _AROP exp
  ;

exp
  : literal
  | _ID
  | function_call
  | _LPAREN num_exp _RPAREN
  | post_inc
  ;

log_exp
: rel_exp _LOGOP rel_exp
| log_exp _LOGOP rel_exp
;

post_inc
: _ID _POSTINC
;

literal
  : _INT_NUMBER
  | _UINT_NUMBER
  ;

function_call
  : _ID _LPAREN argument _RPAREN
  ;

argument
  : /* empty */
  | num_exp
  | log_exp
  ;

do_while_statement
: _DO statement _WHILE _LPAREN rel_exp _RPAREN _SEMICOLON
;

if_statement
: if_part %prec ONLY_IF
 /* %prec oznacava privr token */
  | if_part _ELSE statement
  ;

if_part
  : _IF _LPAREN rel_exp _RPAREN statement
  | _IF _LPAREN log_exp _RPAREN statement
  ;

rel_exp
  : num_exp _RELOP num_exp
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  return 0;
}

int main() {
  return yyparse();
}
