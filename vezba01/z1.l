%option noyywrap

%%

0[xX][0-9a-fA-F]{1,4} {printf("hex broj: %s\n", yytext);}



("+"|"-")?[0-9]+"."[0-9]*([eE]("+"|"-")?[0-9]{1,3})?          { printf("broj: %s\n", yytext); }

[bB][rR][eE][aA][kK] {printf("break!\n");}

"//".*



%%

int main() {
  yylex();
}
