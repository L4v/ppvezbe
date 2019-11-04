%{
  #include <stdio.h>
  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;
  int Questions = 0;
  int Exclamations = 0;
  int Statements = 0;
  int Paragraphs = 0;
    
%}

%token  DOT
%token  EXCLAMATION_MARK
%token  QUESTION_MARK
%token  COMMA
%token  CAPITAL_WORD
%token  WORD
%token  NEWLINE
%token  LPAREN RPAREN

%%

 /* Plagijat od Gergely Kis */

text 
: paragraph
| text paragraph
| NEWLINE paragraph
;


paragraph
: sentences NEWLINE {Paragraphs++;}
;

sentences
: sentence
| sentences sentence
;

sentence
  : words end
  ;


words 
  : CAPITAL_WORD
  | words comma WORD
  | words comma CAPITAL_WORD
  ;

comma
:
| COMMA
;

end
: DOT {Statements++;}
| EXCLAMATION_MARK {Exclamations++;}
| QUESTION_MARK {Questions++;}

%%

int main() {
  yyparse();
  fprintf(stdout,"Statements:%d\nQuestions:%d\nExclamations:%d\nParagraphs:%d\n",
	  Statements,
	  Questions,
	  Exclamations,
	  Paragraphs);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

