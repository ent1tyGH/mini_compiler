%{
#include <stdio.h>
#include <stdlib.h>
#include "../include/ast.h"

// Declare root node of AST
ASTNode* rootNode;

// Function prototype for the lexer
int yylex(void);
void yyerror(const char *s);
%}

// Token declarations with types
%token <ival> INTEGER
%token <sval> IDENTIFIER STRING_LITERAL
%token ASSIGN PLUS INPUT OUTPUT SEMICOLON

// Define the union to handle multiple data types
%union {
    int ival;
    char* sval;
    ASTNode* node;
}

// Define the type for the parser rules
%type <node> program statement_list statement declaration_statement initialization_statement input_statement output_statement addition_statement expression cin_statement cout_statement

%%

program:
    statement_list
    {
        $$ = $1;
        rootNode = $$;  // Set rootNode to the root of the AST
    }
    ;

statement_list:
    statement
    {
        $$ = createNode("statement_list", NULL);  // Create new AST node for statement_list
        addChild($$, $1);  // Add the statement node as a child
    }
    | statement_list statement
    {
        addChild($1, $2);  // Add the new statement as a child
        $$ = $1;  // Return the existing statement list
    }
    ;

statement:
    declaration_statement
    {
        $$ = $1;  // Forward the declaration statement node
    }
    | initialization_statement
    {
        $$ = $1;  // Forward the initialization statement node
    }
    | input_statement
    {
        $$ = $1;  // Forward the input statement node
    }
    | output_statement
    {
        $$ = $1;  // Forward the output statement node
    }
    | addition_statement
    {
        $$ = $1;  // Forward the addition statement node
    }
    | cin_statement
    {
        $$ = $1;  // Forward the cin statement node
    }
    | cout_statement
    {
        $$ = $1;  // Forward the cout statement node
    }
    ;

declaration_statement:
    IDENTIFIER SEMICOLON
    {
        $$ = createNode("declaration", $1);  // Create a declaration node with the identifier
    }
    ;

initialization_statement:
    IDENTIFIER ASSIGN INTEGER SEMICOLON
    {
        // Create initialization node and add the integer value as a child
        $$ = createNode("initialization", $1);
        char buffer[12];
        snprintf(buffer, 12, "%d", $3);  // Convert integer to string
        addChild($$, createNode("integer", buffer));
    }
    ;

input_statement:
    INPUT IDENTIFIER SEMICOLON
    {
        $$ = createNode("input", $2);  // Create input node with the identifier
    }
    | INPUT IDENTIFIER INPUT IDENTIFIER SEMICOLON
    {
        $$ = createNode("input", $2);  // Create input node with the first identifier
        addChild($$, createNode("identifier", $4));  // Add the second identifier as a child
    }
    ;

output_statement:
    OUTPUT expression SEMICOLON
    {
        $$ = createNode("output", NULL);  // Create output node
        addChild($$, $2);  // Add the expression or identifier as a child
    }
    | OUTPUT STRING_LITERAL SEMICOLON
    {
        $$ = createNode("output", $2);  // Create output node with the string literal
    }
    ;

addition_statement:
    IDENTIFIER ASSIGN expression SEMICOLON
    {
        $$ = createNode("addition", $1);  // Create addition node with the left-hand identifier
        addChild($$, $3);  // Add the expression as a child
    }
    ;

expression:
    IDENTIFIER
    {
        $$ = createNode("identifier", $1);  // Return identifier as node
    }
    | INTEGER
    {
        char buffer[12];
        snprintf(buffer, 12, "%d", $1);  // Convert integer to string
        $$ = createNode("integer", buffer);  // Return integer as node
    }
    | expression PLUS expression
    {
        $$ = createNode("addition", NULL);  // Create an addition node for expression
        addChild($$, $1);  // Add the left operand
        addChild($$, $3);  // Add the right operand
    }
    ;

cin_statement:
    INPUT IDENTIFIER SEMICOLON
    {
        $$ = createNode("cin", $2);  // Create node for cin operation with the identifier
    }
    ;

cout_statement:
    OUTPUT IDENTIFIER SEMICOLON
    {
        $$ = createNode("cout", $2);  // Create node for cout operation with the identifier
    }
    ;

%%

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
