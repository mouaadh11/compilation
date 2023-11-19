%{
#undef yywrap
#define yywrap() 1
#include<stdio.h>
int yyerror(char *msg);

int positive = 0;
int negative = 0;
int charCounter = 0;
%}
%%
[a-zA-Z]+ {
    charCounter++;
}

[+]?[0-9]+ {
    positive++;
}

[-][0-9]+ {
   negative++;
}

[\n] ;
[ ] ;
[;] {yyterminate();}
. {yyerror("Error Lexical");}
%%

yyerror(char *msg) {
    printf("%s", msg);
}


main() {
    
  yylex();
  
  printf("\n---------------\n");
  printf("negative : %d\n" , negative);
  printf("positive : %d \n" , positive);
  printf("word : %d \n" , charCounter);

}