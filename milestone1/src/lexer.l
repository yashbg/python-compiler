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

    indent[0]=0;
    /*printf("deds to be returned = %d\n", dedentsToBeReturned);*/
    if(dedentsToBeReturned > 0){
        /*printf("reached here\n");*/
        dedentsToBeReturned--;
        return DEDENT;
    }

<<EOF>> {
            while(indent[top] != 0) {
                top--;
                return DEDENT;
            }
            exit(1);
        }

\n([\n\t ]*{COMMENT}\n)+ {
    yylval.tokenname = yytext;
    return NEWLINE;
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
        if(column>indent[top]){
            indent[top+1] = column;
            top++;
            return INDENT;
        } 
        else if(column < indent[top])
        {
            /*printf("Reached here\n");*/
            /*printf("deds to be returned = %d\n", dedentsToBeReturned);*/
            while(column<indent[top]) {
                /*cout << indent[top] << " ";*/
                top--;
                dedentsToBeReturned++;
            }
            /*printf("deds to be returned now = %d\n", dedentsToBeReturned);*/
            if(column!=indent[top]) {
                printf("IndentationError: unindent does not match any outer indentation level at line number %d\n", line);
                exit(1);
            }
            dedentsToBeReturned--;
            return DEDENT;
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
                            line=yylineno; return FALSE;}
else                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ELSE;}
None                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NONE;}
break                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return BREAK;}
in                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return IN;}
True                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return TRUE;}
class                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return CLASS;}
is                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return IS;}
return                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return RETURN;}
and                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return AND;}
continue                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return CONTINUE;}
for                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return FOR;}
def                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DEF;}
while                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return WHILE;}
assert                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ASSERT;}
global                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return GLOBAL;}
not                        { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NOT;}
elif                       { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ELIF;}
if                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return IF;}
or                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return OR;}


"+="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return PLUSEQUAL;}
"-="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return MINEQUAL;}
"*="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return STAREQUAL;}
"/="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return SLASHEQUAL;}
"%="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return PERCENTEQUAL;}
"&="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return AMPEREQUAL;}
"|="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return VBAREQUAL;}
"^="                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return CIRCUMFLEXEQUAL;}
"<<="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return LEFTSHIFTEQUAL;}
">>="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return RIGHTSHIFTEQUAL;}
"**="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DOUBLESTAREQUAL;}
"//="                   { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DOUBLESLASHEQUAL;}
"("                     { line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '(';}
")"                     { line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ')';}
"["                     { line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '[';}
"]"                     { line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ']';}
","                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ',';}
":"                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ':';}
"."                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '.';}
";"                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ';';}
"="                     { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '=';}
"->"                    { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return ARROW;}


"+"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '+';}
"-"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '-';}
"*"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '*';}
"/"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '/';}
"%"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '%';}
"|"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '|';}
"&"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '&';}
"~"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '~';}
"^"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return '^';}
"<"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return LESSTHAN;}
"<="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return LESSTHANEQUAL;}
">"             { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return GREATERTHAN;}
">="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return GREATERTHANEQUAL;}
">>"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return RIGHTSHIFT;}
"<<"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return LEFTSHIFT;}
"//"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DOUBLESLASH;}
"**"            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DOUBLESTAR;}
"=="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return DOUBLEEQUAL;}
"!="            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NOTEQUAL;}

{INTEGER}                           { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NUMBER;}
{FLOAT_NUMBER}                      { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NUMBER;}
{IMAGINARY}                         { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NUMBER;}
{BYTE_STRING}                       {}
{STRING}                            { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return STRING;}
{NAME}                              { string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NAME;}


{COMMENT}                   
{NEWLINE}                   { 
                                if(line_join == 1);
                                else{
                                    string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                             line=yylineno; return NEWLINE;
                                    }
                                }
{WHITESPACE}           
{OTHER}                     {printf("Invalid character %s found at line number %d\n", yytext, line); exit(1);}

%%
