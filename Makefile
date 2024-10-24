# Define compiler
CC = gcc
LEX = flex
YACC = bison

# Define flags
CFLAGS = -Wall -g -Iinclude

# Source files
SRCS = src/main.c src/ast.c src/ir.c

# Object files (these are generated after compiling the sources)
OBJS = main.o ast.o ir.o

# Define executable
EXEC = mini_compiler

# Default rule to build the program
all: $(EXEC)

# Rule to compile the lexer and parser, then link everything
$(EXEC): src/lex.yy.c src/y.tab.c $(OBJS)
	$(CC) $(CFLAGS) src/lex.yy.c src/y.tab.c $(OBJS) -o $(EXEC)

# Lexical analysis
src/lex.yy.c: src/LexicalAnalysis.l
	$(LEX) -o src/lex.yy.c src/LexicalAnalysis.l

# Parsing (Bison/Yacc)
src/y.tab.c: src/parser.y
	$(YACC) -d src/parser.y -o src/y.tab.c

# Compile main.c
main.o: src/main.c include/ast.h include/ir.h
	$(CC) $(CFLAGS) -c src/main.c -o main.o

# Compile AST and IR
ast.o: src/ast.c include/ast.h
	$(CC) $(CFLAGS) -c src/ast.c -o ast.o

ir.o: src/ir.c include/ir.h
	$(CC) $(CFLAGS) -c src/ir.c -o ir.o

# Clean build files
clean:
	rm -f $(OBJS) src/lex.yy.c src/y.tab.c src/y.tab.h $(EXEC)

# PHONY target to ensure 'clean' is not treated as a file
.PHONY: all clean
