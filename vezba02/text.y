%{
  #include <stdio.h>
  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;

  int Questions = 0,
    Exclamations = 0,
    Statements = 0;
  int Paragraphs = 0;
%}

%token  DOT QMARK EMARK COMMA NL
%token  CAPITAL_WORD
%token  WORD

%%

text 
  : paragraph 
  | text paragraph
  | NL paragraph
  ;

paragraph 
: sentences NL{Paragraphs++;}

;

sentences
: sentence
| sentences sentence
;

sentence 
  : words punctuation
  ;

punctuation
: DOT {++Statements;}
| QMARK {++Questions;}
| EMARK {++Exclamations;}
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
  fprintf(stdout, "Questions: %d\nExclamations: %d\nStatements: %d\nParagraphs: %d\n",
	  Questions,
	  Exclamations,
	  Statements,
	  Paragraphs);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

