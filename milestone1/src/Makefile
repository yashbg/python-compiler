all: main
main: main.cpp parser.tab.c lex.yy.c
	g++ -std=c++17 main.cpp parser.tab.c lex.yy.c -o main
lex.yy.c: lexer.l
	flex lexer.l
parser.tab.c: parser.y
	bison -d parser.y
clean:
	rm -f *.tab.c *.tab.h *.yy.c main parser graph.dot
