%{
#undef yywrap
#define yywrap() 1
#include<stdio.h>
int yyerror(char *msg);

int positive = 0;
int negative = 0;
int charCounter = 0;
int maxWord = 0;
char file[50];
char longWord[100];
int longWord = 0;
%}
%%
[a-zA-Z]+ {
    if (maxWord == 0){
        longWord[] = yytext;
        maxWord = strlen(yytext);
    }else{
        if(strlen(yytext) > maxWord){
            maxWord = strlen(yytext);
            strcopy(yytext,)

    }}
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
[;] {
    printf("\n---------------\n");
    printf("negative : %d\n" , negative);
    printf("positive : %d \n" , positive);
    printf("word : %d \n" , charCounter);
    yyterminate();}

. {yyerror("Error Lexical");}
%%


yyerror(char *msg) {
    printf("%s", msg);
}


main() {
  printf("enter file name:");
  scanf("%s", &file);  
  yyin = fopen(file, "r");
  yylex();
}