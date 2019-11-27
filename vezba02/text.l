%option noyywrap yylineno
%{
  #include "text.tab.h"
%}

%%

"\n"        { return NL;}
[ \t]+    { /* skip */ }

","         { return COMMA; }
"."         { return DOT; }
"?"         { return QMARK; }
"!"         { return EMARK; }
[A-Z][a-z]* { return CAPITAL_WORD; }
[a-z]+      { return WORD; }
                     
.           { printf("\nline %d: LEXICAL ERROR on char %c", 
                      yylineno, *yytext); }    

