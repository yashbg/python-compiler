%{
    #include <stdio.h>
    #include "parser.tab.h"

    extern int line;
    int line_join = 0;
    int column;
    int indent[100];
    int top=0;
%}

%option noyywrap yylineno nodefault

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
NAME                {LETTER}({LETTER}|{DIGIT})*

STRING_PREFIX       "r"|"u"|"R"|"U"|"f"|"F"|("fr"|"Fr"|"fR"|"FR"|"rf"|"rF"|"Rf"|"RF")
SHORT_STRING        \"([^\"\'\\]|\\.)*\"|\'([^\'\"\\]|\\.)*\'
LONG_STRING         "'''"([^'\\]|\\.|'{1,2})*"'''"|'"""'([^"\\]|\\.|"{1,2})*'"""'
BYTE_STRING_PREFIX  "b"|"B"|("br"|"Br"|"bR"|"BR"|"rb"|"rB"|"Rb"|"RB")
STRING_BODY         ({SHORT_STRING}|{LONG_STRING})
BYTE_STRING         ({BYTE_STRING_PREFIX}{STRING_BODY})
STRING              {STRING_PREFIX}?{STRING_BODY}

COMMENT             \#[^\n]*
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

False                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno; printf("%s\n", yytext); return FALSE;}
else                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ELSE;}
None                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NONE;}
break                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return BREAK;}
in                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return IN;}
True                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return TRUE;}
class                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return CLASS;}
is                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return IS;}
return                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return RETURN;}
and                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return AND;}
continue                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return CONTINUE;}
for                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return FOR;}
def                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DEF;}
while                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return WHILE;}
assert                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ASSERT;}
global                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return GLOBAL;}
not                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NOT;}
elif                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ELIF;}
if                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return IF;}
or                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return OR;}


"+="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return PLUSEQUAL;}
"-="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return MINEQUAL;}
"*="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return STAREQUAL;}
"/="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return SLASHEQUAL;}
"%="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return PERCENTEQUAL;}
"&="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return AMPEREQUAL;}
"|="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return VBAREQUAL;}
"^="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return CIRCUMFLEXEQUAL;}
"<<="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return LEFTSHIFTEQUAL;}
">>="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return RIGHTSHIFTEQUAL;}
"**="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DOUBLESTAREQUAL;}
"//="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DOUBLESLASHEQUAL;}
"("                     { line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '(';}
")"                     { line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ')';}
"["                     { line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '[';}
"]"                     { line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ']';}
","                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ',';}
":"                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ':';}
"."                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '.';}
";"                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ';';}
"="                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '=';}
"->"                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return ARROW;}


"+"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '+';}
"-"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '-';}
"*"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '*';}
"/"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '/';}
"%"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '%';}
"|"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '|';}
"&"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '&';}
"~"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '~';}
"^"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return '^';}
"<"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return LESSTHAN;}
"<="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return LESSTHANEQUAL;}
">"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return GREATERTHAN;}
">="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return GREATERTHANEQUAL;}
">>"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return RIGHTSHIFT;}
"<<"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return LEFTSHIFT;}
"//"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DOUBLESLASH;}
"**"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DOUBLESTAR;}
"=="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return DOUBLEEQUAL;}
"!="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NOTEQUAL;}

{INTEGER}                           { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NUMBER;}
{FLOAT_NUMBER}                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NUMBER;}
{IMAGINARY}                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NUMBER;}
{BYTE_STRING}                       {}
{STRING}                            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return STRING;}
{NAME}                              { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("%s\n", yytext); return NAME;}


{COMMENT}                   
{NEWLINE}                   { 
                                if(line_join == 1);
                                else{
                                    string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; printf("NEWLINE\n"); return NEWLINE;
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