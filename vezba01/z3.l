%option noyywrap

%%

[0-9]*F {printf("%.3fC",(atoi(yytext)  -  32)  *  5.0/9.0);}

%%

int main() {
  yylex();
}
