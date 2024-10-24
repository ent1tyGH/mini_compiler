#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/ast.h"
#include "../include/ir.h"

// Global variable to keep track of the IR statements
IRNode* irHead = NULL;
IRNode* irTail = NULL;

// Function to add an IR node to the list
void addIRNode(char* type, char* operand1, char* operand2, char* result) {
    IRNode* newNode = malloc(sizeof(IRNode));
    if (!newNode) {
        fprintf(stderr, "Memory allocation failed for IR node\n");
        exit(1);
    }

    newNode->type = strdup(type);
    if (!newNode->type) {
        fprintf(stderr, "Memory allocation failed for IR node type\n");
        free(newNode);
        exit(1);
    }

    newNode->operand1 = operand1 ? strdup(operand1) : NULL;
    if (operand1 && !newNode->operand1) {
        fprintf(stderr, "Memory allocation failed for operand1\n");
        free(newNode->type);
        free(newNode);
        exit(1);
    }

    newNode->operand2 = operand2 ? strdup(operand2) : NULL;
    if (operand2 && !newNode->operand2) {
        fprintf(stderr, "Memory allocation failed for operand2\n");
        free(newNode->type);
        free(newNode->operand1);
        free(newNode);
        exit(1);
    }

    newNode->result = result ? strdup(result) : NULL;
    if (result && !newNode->result) {
        fprintf(stderr, "Memory allocation failed for result\n");
        free(newNode->type);
        free(newNode->operand1);
        free(newNode->operand2);
        free(newNode);
        exit(1);
    }

    newNode->next = NULL;

    if (irTail) {
        irTail->next = newNode;
    } else {
        irHead = newNode; // This is the first node
    }
    irTail = newNode;
}

// Function to generate IR from AST
void generateIR(ASTNode* rootNode) {
    if (rootNode == NULL) return;

    if (strcmp(rootNode->type, "declaration") == 0) {
        addIRNode("declare", rootNode->children[0]->value, NULL, NULL);
    } else if (strcmp(rootNode->type, "initialization") == 0) {
        addIRNode("assign", rootNode->children[0]->value, rootNode->children[1]->value, rootNode->children[0]->value);
    }

    // Recursively generate IR for child nodes
    for (int i = 0; i < rootNode->childCount; i++) {
        generateIR(rootNode->children[i]);
    }
}

// Function to print the generated IR code
void printIRCode() {
    IRNode* current = irHead;
    while (current != NULL) {
        printf("%s ", current->type);
        if (current->operand1) printf("%s ", current->operand1);
        if (current->operand2) printf("%s ", current->operand2);
        if (current->result) printf("%s ", current->result);
        printf("\n");
        current = current->next;
    }
}

// Function to free the generated IR code
void freeIRCode() {
    IRNode* current = irHead;
    while (current != NULL) {
        IRNode* next = current->next;
        free(current->type);
        free(current->operand1);
        free(current->operand2);
        free(current->result);
        free(current);
        current = next;
    }
    irHead = irTail = NULL;
}
