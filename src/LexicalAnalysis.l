%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>  // Include for malloc and realloc
#include "../include/tokens.h"

int x = 0, y = 0, z = 0, p = 0, a = 0, b = 0, c = 0, d = 0, X = 0;
int cin_flag = 0, cout_flag = 0;

int MAX_TOKENS = 10;
int TOKEN_COUNT = 0;

struct Token* tokens = NULL;

void add_token(const char* token_value, const char* token_type) {
    // Resize token array if necessary
    if (TOKEN_COUNT >= MAX_TOKENS) {
        MAX_TOKENS *= 2;
        struct Token* temp = realloc(tokens, MAX_TOKENS * sizeof(struct Token));
        if (!temp) {
            fprintf(stderr, "Memory reallocation failed\n");
            exit(1);
        }
        tokens = temp;
    }

    // Allocate memory for the token and type strings
    strncpy(tokens[TOKEN_COUNT].token, token_value, sizeof(tokens[TOKEN_COUNT].token) - 1);
    tokens[TOKEN_COUNT].token[sizeof(tokens[TOKEN_COUNT].token) - 1] = '\0';  // Ensure null termination

    strncpy(tokens[TOKEN_COUNT].type, token_type, sizeof(tokens[TOKEN_COUNT].type) - 1);
    tokens[TOKEN_COUNT].type[sizeof(tokens[TOKEN_COUNT].type) - 1] = '\0';

    TOKEN_COUNT++;
}

%}

%%

"cin" {
    printf("\n%s is a Keyword ", yytext);
    add_token(yytext, "INPUT");
    cin_flag = 1;
};
"cout" {
    printf("\n%s is a Keyword ", yytext);
    add_token(yytext, "OUTPUT");
    cout_flag = 1;
};

">>" {
    printf("\n%s is an Input Operator", yytext);
    add_token(yytext, "RSHIFT");
};
"<<" {
    printf("\n%s is an Output Operator", yytext);
    add_token(yytext, "LSHIFT");
};

[0-9]+ {
    printf("\n%s is a Constant", yytext);
    add_token(yytext, "CONSTANT");
};

"=" {
    printf("\n%s is an ASSIGNMENT", yytext);
    add_token(yytext, "ASSIGNMENT");
};

"+" { a++; x = 1; add_token(yytext, "PLUS"); }
"-" { b++; y = 1; add_token(yytext, "MINUS"); }
"*" { c++; z = 1; add_token(yytext, "MULTIPLY"); }
"/" { d++; p = 1; add_token(yytext, "DIVIDE"); }

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("\n%s is an Identifier ", yytext);
    add_token(yytext, "IDENTIFIER");
}

\"[^"]*\" {
    printf("\n%s is a String Literal", yytext);
    add_token(yytext, "STRING_LITERAL");
}

";" {
    X++;
    add_token(yytext, "SEMICOLON");
}

[\(\)\{\}\.,\*\&\^\%\$\#\@\!\'\":\|\\\\\/\?\>\<] {
    X++;
    add_token(yytext, "SPECIAL");
}

[ \t\n]+ { /* Ignore whitespace */ }

%%

int yywrap() {
    return 1;
}
