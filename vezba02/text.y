%{
  #include <stdio.h>
  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;
  int ExclamationMarks = 0;
  int QuestionMarks = 0;
  int Paragraphs = 0;
%}

%token  DOT
%token  QMARK
%token  EMARK
%token  COMMA
%token  CAPITAL_WORD
%token  WORD
%token  NEWLINE

%%

text 
  : paragraph
  | text paragraph
  ;
          
paragraph 
: sentence  {Paragraphs++;}
| paragraph sentence {Paragraphs++;}
| paragraph NEWLINE {Paragraphs++;}
;

sentence 
: words
| words QMARK {QuestionMarks++;}
| words EMARK {ExclamationMarks++;}
| words DOT
;

words 
  : CAPITAL_WORD
  | words WORD
  | words COMMA WORD
  | words CAPITAL_WORD
  | words COMMA CAPITAL_WORD
  ;

%%

int main() {
  yyparse();
  fprintf(stdout,
 "Broj upitnih: %d\nBroj uzvicnih: %d\nBroj pasusa:%d\n",
	  QuestionMarks,
	  ExclamationMarks,
	  Paragraphs);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

