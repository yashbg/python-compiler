all: main
main: main.cpp parser
	g++ -std=c++17 main.cpp -o main
parser: parser.tab.c lex.yy.c
	g++ -std=c++17 parser.tab.c lex.yy.c -o parser
lex.yy.c: lexer.l
	flex lexer.l
parser.tab.c: parser.y
	bison -d parser.y
clean:
	rm -f *.tab.c *.tab.h *.yy.c main parser graph.dot
