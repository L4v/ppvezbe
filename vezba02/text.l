%option noyywrap yylineno
%{
  #include "text.tab.h"
%}

%%

[ \t]+    { /* skip */ }
\n+         { return NEWLINE; }

"."         { return DOT; }
"!"         { return EXCLAMATION_MARK; }
"?"         { return QUESTION_MARK; }
","         { return COMMA; }

"("         { return LPAREN; }
")"         { return RPAREN; }

[A-Z][a-z]* { return CAPITAL_WORD; }
[a-z]+      { return WORD; }
                     
.           { printf("\nline %d: LEXICAL ERROR on char %c", 
                      yylineno, *yytext); }    

