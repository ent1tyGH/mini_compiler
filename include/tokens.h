// tokens.h
#ifndef TOKENS_H
#define TOKENS_H

// Define the structure for tokens
struct Token {
    char token[50];
    char type[50];
};

extern struct Token* tokens;
extern int MAX_TOKENS;
extern int TOKEN_COUNT;

#endif  // TOKENS_H
