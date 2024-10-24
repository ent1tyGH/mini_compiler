#ifndef IR_H
#define IR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CODE_SIZE 100

// Structure for IR code (three-address code)
typedef struct {
    char op[10];       // Operator (e.g., +, =, input)
    char arg1[50];     // First operand
    char arg2[50];     // Second operand
    char result[50];   // Result or target
} IRCode;

// Node structure for the linked list of IR instructions
typedef struct IRNode {
    char* type;              // Type of IR instruction
    char* operand1;         // First operand
    char* operand2;         // Second operand
    char* result;           // Result
    struct IRNode* next;    // Pointer to the next node
} IRNode;

// Global array of IR codes
extern IRCode irList[MAX_CODE_SIZE];
extern int irCount;       // Counter to keep track of how many IR instructions

// Temporary variable counter
extern int tempVarCounter;

// Function prototypes
char* newTempVar();
int addIRCode(const char* op, const char* arg1, const char* arg2, const char* result);
void generateIR(ASTNode* rootNode);
void printIRCode();
void freeIRCode();

#endif // IR_H
