%{
  #include <stdio.h>
  #include "parser.tab.h"

  extern int line;
  
  int dedentsToBeReturned = 0;
  int indentToBeReturned = 0;
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
WHITESPACE          " "|"\f"|"\t"
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

  if(indentToBeReturned > 0){
    indentToBeReturned = 0;
    printf("%s\n", "INDENT");
    return INDENT;
  }

  while(dedentsToBeReturned > 0){
    dedentsToBeReturned--;
    printf("%s\n", "DEDENT");
    return DEDENT;
  }

\n([\n\t ]*{COMMENT}\n)+  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++){
                              yylval.tokenname[i] = str[i];
                            }
                            yylval.tokenname[str.size()] = '\0';
                            printf("%s\n", "NEWLINE");
                            return NEWLINE;
                          }

[\n\t ]+                  {
                            if(line_join == 1) {
                              REJECT;
                            }
                            else{
                              int last_newline_pos =  -1, len = strlen(yytext);
                              for(int i = 0; i < len; i++){
                                if(yytext[i] == '\n') last_newline_pos = i;
                              }
                              if(last_newline_pos != -1){
                                int currindent = len - last_newline_pos - 1;
                                if(currindent > indent[top]){
                                  top++;
                                  indent[top] = currindent;
                                  indentToBeReturned = 1;
                                }
                                else if(currindent < indent[top]){
                                  while(currindent < indent[top]){
                                    top--;
                                    dedentsToBeReturned++;
                                  }
                                  if(currindent != indent[top]) {
                                    printf("IndentationError: unindent does not match any outer indentation level at line number %d\n", line);
                                    exit(1);
                                  }
                                }
                                printf("NEWLINE\n");
                                return NEWLINE;
                              }
                            }
                          }

\\[\n][\t ]*              /*----Explicit Line Joining------*/

False                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "FALSE");
                            return FALSE;
                          }

else                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "ELSE");
                            return ELSE;
                          }

None                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NONE");
                            return NONE;
                          }

break                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "BREAK");
                            return BREAK;
                          }

in                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "IN");
                            return IN;
                          }

True                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "TRUE");
                            return TRUE;
                          }

class                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "CLASS");
                            return CLASS;
                          }

is                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "IS");
                            return IS;
                          }

return                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "RETURN");
                            return RETURN;
                          }

and                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "AND");
                            return AND;
                          }

continue                  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "CONTINUE");
                            return CONTINUE;
                          }

for                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "FOR");
                            return FOR;
                          }

def                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DEF");
                            return DEF;
                          }

while                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "WHILE");
                            return WHILE;
                          }

assert                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "ASSERT");
                            return ASSERT;
                          }

global                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "GLOBAL");
                            return GLOBAL;
                          }

not                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NOT");
                            return NOT;
                          }

elif                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "ELIF");
                            return ELIF;
                          }

if                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "IF");
                            return IF;
                          }

or                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "OR");
                            return OR;
                          }



"+="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "PLUSEQUAL");
                            return PLUSEQUAL;
                          }

"-="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "MINEQUAL");
                            return MINEQUAL;
                          }

"*="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "STAREQUAL");
                            return STAREQUAL;
                          }

"/="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "SLASHEQUAL");
                            return SLASHEQUAL;
                          }

"%="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "PERCENTEQUAL");
                            return PERCENTEQUAL;
                          }

"&="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "AMPEREQUAL");
                            return AMPEREQUAL;
                          }

"|="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "VBAREQUAL");
                            return VBAREQUAL;
                          }

"^="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "CIRCUMFLEXEQUAL");
                            return CIRCUMFLEXEQUAL;
                          }

"<<="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "LEFTSHIFTEQUAL");
                            return LEFTSHIFTEQUAL;
                          }

">>="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "RIGHTSHIFTEQUAL");
                            return RIGHTSHIFTEQUAL;
                          }

"**="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DOUBLESTAREQUAL");
                            return DOUBLESTAREQUAL;
                          }

"//="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DOUBLESLASHEQUAL");
                            return DOUBLESLASHEQUAL;
                          }

"("                       {
                            line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "'('");
                              return '(';
                          }

")"                       {
                            line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "')'");
                              return ')';
                          }

"["                       {
                            line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "'['");
                              return '[';
                          }

"]"                       {
                            line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "']'");
                              return ']';
                          }

","                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "','");
                              return ',';
                          }

":"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "':'");
                              return ':';
                          }

"."                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "'.'");
                              return '.';
                          }

";"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "';'");
                              return ';';
                          }

"="                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "'='");
                              return '=';
                          }

"->"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              printf("%s\n", "ARROW");
                              return ARROW;
                          }

                        


"+"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'+'");
                            return '+';
                          }

"-"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'-'");
                            return '-';
                          }

"*"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'*'");
                            return '*';
                          }

"/"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'/'");
                            return '/';
                          }

"%"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'%'");
                            return '%';
                          }

"|"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'|'");
                            return '|';
                          }

"&"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'&'");
                            return '&';
                          }

"~"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'~'");
                            return '~';
                          }

"^"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "'^'");
                            return '^';
                          }

"<"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "LESSTHAN");
                            return LESSTHAN;
                          }

"<="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "LESSTHANEQUAL");
                            return LESSTHANEQUAL;
                          }

">"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "GREATERTHAN");
                            return GREATERTHAN;
                          }

">="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "GREATERTHANEQUAL");
                            return GREATERTHANEQUAL;
                          }

">>"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "RIGHTSHIFT");
                            return RIGHTSHIFT;
                          }

"<<"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "LEFTSHIFT");
                            return LEFTSHIFT;
                          }

"//"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DOUBLESLASH"); return
                          DOUBLESLASH;}

"**"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DOUBLESTAR");
                            return DOUBLESTAR;
                          }

"=="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "DOUBLEEQUAL"); return
                          DOUBLEEQUAL;}

"!="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NOTEQUAL");
                            return NOTEQUAL;
                          }


{INTEGER}                 {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NUMBER");
                            return NUMBER;
                          }

{FLOAT_NUMBER}            {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NUMBER");
                            return NUMBER;
                          }

{IMAGINARY}               {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NUMBER");
                            return NUMBER;
                          }

{BYTE_STRING}             /* ignore BYTE_STRING */

{STRING}                  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "STRING");
                            return STRING;
                          }

{NAME}                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            printf("%s\n", "NAME");
                            return NAME;
                          }



{COMMENT}                 /* ignore COMMENT */

{WHITESPACE}              /* ignore WHITESPACE */

{OTHER}                   {
                            printf("Invalid character %s found at line number %d\n", yytext, line);
                            exit(1);
                          }

%%
