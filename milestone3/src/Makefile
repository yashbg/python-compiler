.PHONY: all
all: main

main: main.cpp codegen.cpp codegen.h symtable.cpp symtable.h parser.tab.c lex.yy.c
	g++ -g -std=c++17 main.cpp codegen.cpp symtable.cpp parser.tab.c lex.yy.c -o main

lex.yy.c: lexer.l
	flex lexer.l

parser.tab.c: parser.y
	bison -d parser.y

.PHONY: clean
clean:
	rm -f *.tab.c *.tab.h *.yy.c main parser graph.dot
