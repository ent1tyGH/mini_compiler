#include <stdio.h>
#include <stdlib.h>  // Include for malloc and realloc
#include "../include/ast.h"
#include "../include/ir.h"
#include "../include/tokens.h"  // Include the header file for tokens

// External references from the parser and lexer
extern int yyparse();
extern FILE *yyin;

// The root of the AST (defined in the parser)
extern ASTNode* rootNode;

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <source-file>\n", argv[0]);
        return 1;
    }

    // Initialize the tokens array
    tokens = malloc(MAX_TOKENS * sizeof(struct Token));
    if (!tokens) {
        fprintf(stderr, "Memory allocation failed for tokens array\n");
        return 1;
    }

    // Open the input file
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening input file");
        free(tokens);  // Free the tokens array before exiting
        return 1;
    }

    // Parse the input and generate the AST
    if (yyparse() == 0) {
        printf("Parsing successful!\n");

        // Generate Intermediate Representation (IR)
        generateIR(rootNode);

        // Print the generated IR
        printIRCode();
    } else {
        fprintf(stderr, "Parsing failed!\n");
    }

    // After printing the IR code
    freeIRCode();
    freeASTNode(rootNode);
    
    // Free the tokens array after usage
    free(tokens);

    fclose(yyin);
    return 0;
}
