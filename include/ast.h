#ifndef AST_H
#define AST_H

#include <stdlib.h>
#include <string.h>

#define MAX_CHILDREN 10  // Set a reasonable limit for children

// Define the structure for an AST node
typedef struct ASTNode {
    char* type;                         // Type of the node (e.g., "OPERATOR", "CONSTANT")
    char* value;                        // Value of the node (e.g., "+", "42")
    struct ASTNode* children[MAX_CHILDREN]; // Array to store child nodes
    int childCount;                     // Number of child nodes
} ASTNode;

// Function declarations for creating, managing, and freeing AST nodes

/**
 * Creates a new AST node.
 * 
 * @param type - The type of the node (e.g., "OPERATOR", "CONSTANT").
 * @param value - The value of the node.
 * @return A pointer to the newly created ASTNode.
 */
ASTNode* createNode(const char* type, const char* value);

/**
 * Adds a child node to the parent AST node.
 * 
 * @param parent - The parent node.
 * @param child - The child node to be added.
 */
void addChild(ASTNode* parent, ASTNode* child);

/**
 * Frees the memory allocated for an AST node and its children recursively.
 * 
 * @param node - The AST node to be freed.
 */
void freeASTNode(ASTNode* node);

#endif  // AST_H
