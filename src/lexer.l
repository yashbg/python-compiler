%option noyywrap
%option yylineno

%{
    #include <stdio.h>
    #include <string>
    #include "newparser.tab.h"
    #include <bits/stdc++.h>
    using namespace std;
    extern int line;
    int line_join = 0;
    int column;
    int indent[100];
    int top=0;
%}

DIGIT               [0-9]
HEX_DIGIT           [0-9a-fA-F]
OCT_DIGIT           [0-7]
BIN_DIGIT           [01]
HEX_INTEGER         "0"[Xx]("_"?{HEX_DIGIT})+
OCT_INTEGER         "0"[Oo]("_"?{OCT_DIGIT})+
BIN_INTEGER         "0"[Bb]("_"?{BIN_DIGIT})+
DEC_INTEGER         [1-9]("_"?{DIGIT})*|"0"("_"?"0")*
INTEGER             {HEX_INTEGER}|{OCT_INTEGER}|{BIN_INTEGER}|{DEC_INTEGER}
DIGITPART           {DIGIT}("_"?{DIGIT})*
EXPONENT            [eE][+-]?{DIGITPART}
DOT                 "."
FRACTION            {DOT}{DIGITPART}
POINT_FLOAT         {DIGITPART}?{FRACTION}|{DIGITPART}{DOT}
EXPONENT_FLOAT      ({POINT_FLOAT}|{DIGITPART}){EXPONENT}
FLOAT_NUMBER        {POINT_FLOAT}|{EXPONENT_FLOAT}
IMAGINARY           ({FLOAT_NUMBER}|{DIGITPART})("j"|"J")

LETTER              [_a-zA-Z]        
WHITESPACE          " "|"\f"
NEWLINE             "\n"
KEYWORD             "False"|"await"|"else"|"import"|"pass"|"None"|"break"|"except"| "in"|"raise"|"True"|"class"|"finally"|"is"|"return"|"and"|"continue"|"for"|"lambda"|"try" |"as"|"def"|"from"|"nonlocal"|"while"|"assert"|"del"|"global"|"not"|"with"|"async"|"elif"|"if"|"or"|"yield"
DELIMITERS          "("|")"|"["|"]"|","|":"|"."|";"|"="|"->"|"+="|"-="|"*="|"/="|"//="|"%="|"&="|"|="|"^="|">>="|"<<="|"**="
OPERATORS           "+"|"-"|"*"|"**"|"/"|"//"|"%"|"<<"|">>"|"&"|"|"|"^"|"~"|"<"|">"|"<="|">="|"=="|"!="
NAME                {LETTER}({LETTER}|{DIGIT})*

STRING_PREFIX       "r"|"u"|"R"|"U"|"f"|"F"|("fr"|"Fr"|"fR"|"FR"|"rf"|"rF"|"Rf"|"RF")
SHORT_STRING        \"([^\"\'\\]|\\.)*\"|\'([^\'\"\\]|\\.)*\'
LONG_STRING         "'''"([^'\\]|\\.|'{1,2})*"'''"|'"""'([^"\\]|\\.|"{1,2})*'"""'
BYTE_STRING_PREFIX  "b"|"B"|("br"|"Br"|"bR"|"BR"|"rb"|"rB"|"Rb"|"RB")
STRING_BODY         ({SHORT_STRING}|{LONG_STRING})
BYTE_STRING         ({BYTE_STRING_PREFIX}{STRING_BODY})
STRING              {STRING_PREFIX}?{STRING_BODY}
     
COMMENT             "#"(.*\n)|(''')(.*\n)*(.*)(''')
OTHER               .


%%

    while(column<indent[top]) {
        top--;
        if(column > indent[top]) {
            printf("Indentation Error\n");
            exit(1);
        }
        /*printf("now column = %d top = %d indent[top] = %d\n", column, top, indent[top]);*/
        else {
            printf("DEDENT\n");
            return DEDENT;
        }
    }

<<EOF>> {
            while(indent[top] != 0) {
                top--;
                printf("DEDENT\n");
                return DEDENT;
            }
            exit(1);
        }


^[\n\t ]+ {
    if(line_join == 1) {
        REJECT;
    }
    else{
        int spaces=0;
        if(top==0) indent[top]=0;
        column=0;
        while(isspace(yytext[spaces])) {
            if(yytext[spaces]=='\t') column+=2;
            else if(yytext[spaces]=='\n') column=0;
            else column++;
            spaces++;
        }
        //printf("\ncolumn = %d, top = %d, indent[top] = %d\n", column, top, indent[top]);
        if(column>indent[top]){
            indent[top+1] = column;
            top++;
            printf("INDENT\n");
            return INDENT;
        } 
        else
        {
            while(column<indent[top]) {
                top--;
                /*printf("now column = %d top = %d indent[top] = %d\n", column, top, indent[top]);*/
                if(column > indent[top]) {
                    printf("Indentation Error\n");
                    exit(1);
                }
                else {
                    return DEDENT;
                    printf("DEDENT\n");
                }
            }
            if(column!=indent[top]) {
                printf("IndentationError: unindent does not match any outer indentation level\n");
                //exit(1);
            }
        }
    }
}

\\[\n][\t ]* {
    /*----Explicit Line Joining------*/
}

False                      { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return FALSE;}
else                       { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ELSE;}
None                       { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NONE;}
break                      { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return BREAK;}
in                         { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return IN;}
True                       { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return TRUE;}
class                      { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return CLASS;}
is                         { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return IS;}
return                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return RETURN;}
and                        { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return AND;}
continue                   { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return CONTINUE;}
for                        { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return FOR;}
def                        { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DEF;}
while                      { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return WHILE;}
assert                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ASSERT;}
global                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return GLOBAL;}
not                        { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NOT;}
elif                       { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ELIF;}
if                         { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return IF;}
or                         { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return OR;}


"+="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return PLUSEQUAL;}
"-="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return MINEQUAL;}
"*="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return STAREQUAL;}
"/="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return SLASHEQUAL;}
"%="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return PERCENTEQUAL;}
"&="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return AMPEREQUAL;}
"|="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return VBAREQUAL;}
"^="                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return CIRCUMFLEXEQUAL;}
"<<="                   { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return LEFTSHIFTEQUAL;}
">>="                   { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return RIGHTSHIFTEQUAL;}
"**="                   { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DOUBLESTAREQUAL;}
"//="                   { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DOUBLESLASHEQUAL;}
"("                     { line_join = 1; yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '(';}
")"                     { line_join = 0; yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ')';}
"["                     { line_join = 1; yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '[';}
"]"                     { line_join = 0; yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ']';}
","                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ',';}
":"                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ':';}
"."                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '.';}
";"                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ';';}
"="                     { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '=';}
"->"                    { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return ARROW;}


"+"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '+';}
"-"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '-';}
"*"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '*';}
"/"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '/';}
"%"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '%';}
"|"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '|';}
"&"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '&';}
"~"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '~';}
"^"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return '^';}
"<"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return LESSTHAN;}
"<="            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return LESSTHANEQUAL;}
">"             { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return GREATERTHAN;}
">="            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return GREATERTHANEQUAL;}
">>"            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return RIGHTSHIFT;}
"<<"            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return LEFTSHIFT;}
"//"            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DOUBLESLASH;}
"**"            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DOUBLESTAR;}
"=="            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return DOUBLEEQUAL;}
"!="            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NOTEQUAL;}

{INTEGER}                           { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NUMBER;}
{FLOAT_NUMBER}                      { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NUMBER;}
{IMAGINARY}                         { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NUMBER;}
{BYTE_STRING}                       {}
{STRING}                            { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return STRING;}
{NAME}                              { yylval.tokenname=yytext; line=yylineno; printf("%s\n", yytext); return NAME;}


{COMMENT}                   
{NEWLINE}                   { 
                                if(line_join == 1);
                                else{
                                    yylval.tokenname=yytext; line=yylineno; printf("NEWLINE\n"); return NEWLINE;
                                    }
                                }
{WHITESPACE}           
{OTHER}                     {printf("Invalid character %s found at line number %d\n", yytext, line); exit(1);}

%%

/*
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }

    yyin = file;
    yylex();

    fclose(file);
    return 0;
}
*/