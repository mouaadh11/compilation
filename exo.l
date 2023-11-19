%{
#undef yywrap
#define yywrap() 1
#include <stdio.h>
#include <string.h>
int yyerror(char *msg, int line, int col);
int operators_count = 0,opened_br = 0, operands_count = 0, expression_count, valid = 1, top = -1, line = 0, line_error = 0, col = 0, col_error = 0, error_d = 0;
char expression[100][100], stack[100], str[100];
char file_name[50];
char buffer[250];
%}

%%
"(" { 
    col++;
    top++;
    stack[top] = '(';
    opened_br = 1;
}
")" { 
    if (error_d == 0) {   
    col++;
    opened_br = 0;
    if ( top >= 0 && stack[top] == '(' && (strcmp(expression[expression_count - 1], "*") != 0 && strcmp(expression[expression_count - 1], "/") != 0 && strcmp(expression[expression_count - 1], "-") != 0 && strcmp(expression[expression_count - 1], "+") != 0 )) {
        top--;
    } else {
        top--;
        error_d = 1;
        col_error = col;
        line_error = line;
        yyerror ("error in the number or the order of brackets", line_error, col_error);
        valid = 0;
        continue;
    }
    }
}

"{" { 
    col++;
    top++;
    stack[top] = '{'; 
    opened_br = 1;
}
"}" { 
     if (error_d == 0) {
    opened_br = 0;    
    col++;
    if (top >= 0 && stack[top] == '{' && (strcmp(expression[expression_count - 1], "*") != 0 && strcmp(expression[expression_count - 1], "/") != 0 && strcmp(expression[expression_count - 1], "-") != 0 && strcmp(expression[expression_count - 1], "+") != 0 )) {
        top--;
    } else {
        error_d = 1;
        col_error = col;
        line_error = line;
        yyerror ("error in the number or the order of brackets", line_error, col_error);
        valid = 0;
    }
    }
}

"[" { 
    col++;
    top++;
    stack[top] = '['; 
    opened_br = 1;
}
"]" { 
     if (error_d == 0 ) {
     opened_br = 0;   
    col++;
    if (top >= 0 && stack[top] == '[' && (strcmp(expression[expression_count - 1], "*") != 0 && strcmp(expression[expression_count - 1], "/") != 0 && strcmp(expression[expression_count - 1], "-") != 0 && strcmp(expression[expression_count - 1], "+") != 0 )) {
        top--;
    } else {
        error_d = 1;
        col_error = col;
        line_error = line;
        yyerror ("error in the number or the order of brackets", line_error, col_error);
        valid = 0;
    }
    }
}

"+"|"-"|"*"|"/" { 
     if (1) {
    col++;
        if (strlen(buffer) -1 == strlen(yytext))
        {
            error_d = 1;
            col_error = col;
            line_error = line;
            yyerror ("operator can't be an expression", line_error, col_error);
            valid = 0;
        }
    else if ( expression_count == 0 && (strcmp(yytext, "*") == 0 || strcmp(yytext, "/") == 0 || strcmp(yytext, "+") == 0 || strcmp(yytext, "-") == 0)){
        error_d = 1;
        col_error = col;
        line_error = line;
        yyerror ("you can't start your expression with this operator", line_error, col_error);
        valid = 0;
    }else if (strcmp(expression[expression_count - 1], "*") == 0 || strcmp(expression[expression_count - 1], "/") == 0 || strcmp(expression[expression_count - 1], "+") == 0 || strcmp(expression[expression_count - 1], "-") == 0 || opened_br == 1) {
        error_d = 1;
        col_error = col;
        line_error = line;
        yyerror ("operators error", line_error, col_error);
        valid = 0;
    }

    operators_count++;
    expression_count++;
    
    strcpy(expression[expression_count - 1], yytext);
    }
}

[-]?[0-9]+|[+]?[0-9]+|[a-zA-Z][a-zA-Z0-9]* { 
    if (1) {
    opened_br = 0;
    printf ("%s\n", yytext);
    
    col += strlen(yytext);
    if (strlen(buffer) -1 == strlen(yytext))
    {
        error_d = 1;
        col_error = col - strlen(yytext);
        line_error = line;
        yyerror ("operand can't be an expression", line_error, col_error);
        valid = 0;
    }
    if (operands_count != 0 && (strcmp(expression[expression_count - 1], "*") != 0 && strcmp(expression[expression_count - 1], "/") != 0 && strcmp(expression[expression_count - 1], "-") != 0 && strcmp(expression[expression_count - 1], "+") != 0 )){
        error_d = 1;
        col_error = col - strlen(yytext);
        line_error = line;
        yyerror ("two operands wihtout operator in between", line_error, col_error);
        valid = 0;
    }

    operands_count++;
    expression_count++;
    strcpy(expression[expression_count - 1], yytext); 
    }
}
" " {
    col++;
};
[\n] ;

. { error_d = 1;
    valid = 0; }  // Catch any other characters

%%
int yyerror(char *msg, int line_error, int col_error) {
    int i = 1;
    printf ("%s",buffer);
    for (i = 0; i< col_error-1; i++){
        printf("-");
    }
    printf("^\n");
    printf("error: %s in line: %d col: %d\n\n", msg, line_error, col_error);
    yyterminate();
}
int main() {
    printf("enter file name:");
    scanf("%s", &file_name);
    printf("------------------------------\n");
    FILE *file = fopen(file_name, "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }

    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        
        valid = 1;
        error_d = 0;
        top = -1;
        operands_count = 0;
        operators_count = 0;
        expression_count = 0;
        line++;
        col = 0;
        int i = 0;
        int j = 0;
        for (i = 0; i < 100; i++) {
            for ( j = 0; j < 100; j++) {
                expression[i][j] = "";
            }
        }
        i = 0;
        for (i = 0; i < 100; i++) {
            stack[i] = "";
        }
        yy_scan_string(buffer);
        yylex();
        if (error_d == 0) {
            if (valid == 1 && top == -1) {
                
            } else if (top != -1 ) {
                //printf("Invalid Expression: %s", buffer);
                yyerror("brackets error", line, col+1);
            
            }else{
                yyerror("undefined error", line, col);
            }
        }

    }
    return 0;
}


