%option noyywrap yylineno
%{
  #include "text.tab.h"
%}

%%

"\n"        { return NEWLINE; }
[ \t\n]+    { /* skip */ }

"."         { return DOT; }
"?"         { return QMARK; }
"!"         { return EMARK; }
","         { return COMMA; }
[A-Z][a-z]* { return CAPITAL_WORD; }
[a-z]+      { return WORD; }
                     
.           { printf("\nline %d: LEXICAL ERROR on char %c", 
                      yylineno, *yytext); }    

