%option noyywrap

%%

"//".* {printf("Ovo je bilo izbaceno: %s\n", yytext);}

%%

int main() {
  yylex();
}
