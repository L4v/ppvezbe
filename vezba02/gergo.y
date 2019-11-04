%{
  #include <stdio.h>
  int yylex(void);
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;
  int num_par = 0;
%}

%token  DOT
%token  CAPITAL_WORD
%token  WORD
%token  NL
%token EXCLAMATION_MARK COMMA QUESTION_MARK LPAREN RPAREN

%%

text 
  : paragraph
  | text paragraph
  | NL paragraph
  ;
      
paragraph
  : sentences NL	{num_par++;}
  ;
    
sentences
  : sentence
  | sentences sentence
  ;

sentence 
  : words DOT
  ;

words 
  : CAPITAL_WORD
  | words WORD
  | words CAPITAL_WORD    
  ;

%%

int main() {
  yyparse();
  printf("Number of paragraphs: %d\n", num_par);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

