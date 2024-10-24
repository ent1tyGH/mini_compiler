#include "../include/ast.h"
#include <stdio.h>

/**
 * Creates a new AST node.
 */
ASTNode* createNode(const char* type, const char* value) {
    // Allocate memory for the new AST node
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed for AST node\n");
        exit(EXIT_FAILURE); // Use EXIT_FAILURE for better readability
    }

    // Allocate and copy the type and value strings
    node->type = strdup(type);
    if (!node->type) {
        fprintf(stderr, "Memory allocation failed for node type\n");
        free(node);
        exit(1);
    }

    node->value = strdup(value);
    if (!node->value) {
        fprintf(stderr, "Memory allocation failed for node value\n");
        free(node->type);
        free(node);
        exit(1);
    }

    node->childCount = 0;  // No children initially

    return node;
}

/**
 * Adds a child node to the parent.
 */
void addChild(ASTNode* parent, ASTNode* child) {
    if (parent->childCount < MAX_CHILDREN) {
        parent->children[parent->childCount++] = child;
    } else {
        fprintf(stderr, "Exceeded maximum number of children\n");
    }
}

/**
 * Frees an AST node and its children recursively.
 */
void freeASTNode(ASTNode* node) {
    if (node == NULL) return;

    // First, free all the children recursively
    for (int i = 0; i < node->childCount; i++) {
        freeASTNode(node->children[i]);
    }

    // Free the strings
    free(node->type);
    free(node->value);

    // Free the node itself
    free(node);
}
