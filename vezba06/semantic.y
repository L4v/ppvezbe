%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int vartype;
  int lit_idx;
  int empty_return = 0;
  int returns = 0;
  int curr_block = 0;
  int switch_start;
  int case_el = 0;
  int for_idx;
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token <i> _AROP
%token <i> _RELOP
%token _COMMA
%token <i> _POST
%token _DO _WHILE
%token _SWITCH _CASE _DEFAULT _BREAK
%token _COLON
%token _FOR

%type <i> num_exp exp literal function_call argument rel_exp assignments

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
       }
  ;

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);
      }
_LPAREN parameter _RPAREN {returns = 0;} body
      {
	if(returns > 0)
	  {
	    if($1 == VOID && !empty_return)
	      {
		err("function if of type void, cannot return");
	      }
	    if($1 != VOID && empty_return)
	      {
		warn("function is non void");
	      }
	  }
	else
	  {
	    if($1 != VOID)
	      {
		warn("function should return");
	      }
	  }
	
        clear_symbols(fun_idx + 1);
        var_num = 0;
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;

body
: _LBRACKET variable_list statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE {vartype = $1;}ids _SEMICOLON
  ;

ids
 : _ID
 {
   int local_id = lookup_symbol($1, VAR|PAR);
   if(local_id == NO_INDEX) 
     {
       insert_symbol($1, VAR, vartype, ++var_num, curr_block);
     }
   else if(get_atr2(local_id) == curr_block)
     {
       err("redefinition of '%s'", $1);
     }
   else
     {
       insert_symbol($1, VAR, vartype, ++var_num, curr_block);
     }
 }
 | ids _COMMA _ID
 {
   int local_id = lookup_symbol($3, VAR|PAR);
   if(local_id == NO_INDEX)
     {
       insert_symbol($3, VAR, vartype, ++var_num, curr_block);
     }
   else if(get_atr2(local_id) == curr_block)
     {
       err("redefinition of '%s'", $3);
     }
   else
     {
       insert_symbol($3, VAR, vartype, ++var_num, curr_block);
     }
 }
 ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement {returns++;}
  | do_statement
  | switch_statement
  | for_statement
  ;

compound_statement
: _LBRACKET 
{
  $<i>$ = get_last_element();
  curr_block++;
}
variable_list
statement_list _RBRACKET
{
  curr_block--;
  clear_symbols($<i>2 + 1);
}
  ;

assignment_statement
  : assignments num_exp _SEMICOLON
  {
    if(get_type($1) != get_type($2))
      err("incompatible types in assignment");
  }
  ;

assignments
: _ID _ASSIGN
{
  $$ = lookup_symbol($1, VAR|PAR);
  if($$ == NO_INDEX)
    err("invalid lvalue '%s' in assignment", $1);
}
| assignments _ID _ASSIGN 
{
  if(get_type($1) == NO_INDEX)
    err("invalid lvalue '%s' in assignment", $1);
  else
    if(get_type($1) != get_type(lookup_symbol($2, VAR|PAR)))
      err("incompatible types in assignment");
}
;

num_exp
  : exp
  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation");
      }
  ;

exp
  : literal
  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
      }
  | function_call
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  | _ID _POST
  {
    $$ = lookup_symbol($1, VAR|PAR);
    if($$ == -1)
      {
	err("Invalid post op");
      }
  }
;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
    _LPAREN argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of args to function '%s'", 
              get_name(fcall_idx));
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
      if(get_atr2(fcall_idx) != get_type($1))
        err("incompatible type for argument in '%s'",
            get_name(fcall_idx));
      $$ = 1;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
  | if_part _ELSE statement
  ;

for_statement
: _FOR _LPAREN _TYPE _ID
{
  $<i>$ = get_last_element();
  int id_local = lookup_symbol($4, VAR|PAR);
  if(id_local != -1)
    {
      err("already declared");
    }
  else
    {
      insert_symbol($4, VAR, $3, NO_ATR, NO_ATR);
    }
}
_ASSIGN literal _SEMICOLON rel_exp _SEMICOLON _ID _POST _RPAREN statement
{
  clear_symbols($<i>5 + 1);
}
;

switch_statement
: _SWITCH { switch_start = get_last_element() + 1; } _LPAREN _ID _RPAREN _LBRACKET cases default_case _RBRACKET
{
  switch_start = get_last_element();
  int local_id = lookup_symbol($4, VAR|PAR);
  if(local_id == -1)
    {
      err("undeclared variable");
    }
}
;

default_case
: 
| _DEFAULT _COLON statement
;

cases
: switch_case
| cases switch_case
;

switch_case
: _CASE literal _COLON statement
{
  
  
  case_el++;
}
| _CASE literal _COLON statement _BREAK _SEMICOLON
{
  int lit = atoi(get_name($2));
  for(int literal_index = 0;
      literal_index < case_el;
      ++literal_index)
    {
      if(get_kind(switch_start + literal_index) != LIT &&
	 get_atr2(switch_start + literal_index) != 99)
	{
	  continue;
	}
      int tmp = atoi(get_name(switch_start + literal_index));
      if(tmp == lit)
	{
	  err("literal exists");
	  break;
	}
    }
  set_atr2($2, 99);
  case_el++;
}
;

do_statement
: _DO statement _WHILE _LPAREN _ID
{
  if(lookup_symbol($5, VAR|PAR) == -1)
    {
      err("%s doesn't exist", $5);
    }
}
_RELOP literal _RPAREN _SEMICOLON
{
  if(get_type(lookup_symbol($5, PAR|VAR)) != get_type($8))
    {
      err("types don't match");
    }
}
;

if_part
  : _IF _LPAREN rel_exp _RPAREN statement
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
      }
  ;

return_statement
: _RETURN _SEMICOLON {empty_return = 1; }
| _RETURN num_exp _SEMICOLON { empty_return = 0; }
      {
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
      }
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();

  synerr = yyparse();
  clear_symtab();
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count)
    printf("\n%d error(s).\n", error_count);

  if(synerr)
    return -1; //syntax error
  else
    return error_count; //semantic errors
}

