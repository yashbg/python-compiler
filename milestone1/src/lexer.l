%{
  #include <stdio.h>
  #include "parser.tab.h"

  extern int line;
  extern FILE *lexer_logfile;
  
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
    fprintf(lexer_logfile, "%s\n", "INDENT");
    return INDENT;
  }

  while(dedentsToBeReturned > 0){
    dedentsToBeReturned--;
    fprintf(lexer_logfile, "%s\n", "DEDENT");
    return DEDENT;
  }

\n([\n\t ]*{COMMENT}\n)+  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++){
                              yylval.tokenname[i] = str[i];
                            }
                            yylval.tokenname[str.size()] = '\0';
                            fprintf(lexer_logfile, "%s\n", "NEWLINE");
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
                                    printf("Lexer: IndentationError: unindent does not match any outer indentation level at line number %d\n", line);
                                    exit(1);
                                  }
                                }
                                fprintf(lexer_logfile, "NEWLINE\n");
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
                            fprintf(lexer_logfile, "%s\n", "FALSE");
                            return FALSE;
                          }

else                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "ELSE");
                            return ELSE;
                          }

None                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NONE");
                            return NONE;
                          }

break                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "BREAK");
                            return BREAK;
                          }

in                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "IN");
                            return IN;
                          }

True                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "TRUE");
                            return TRUE;
                          }

class                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "CLASS");
                            return CLASS;
                          }

is                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "IS");
                            return IS;
                          }

return                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "RETURN");
                            return RETURN;
                          }

and                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "AND");
                            return AND;
                          }

continue                  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "CONTINUE");
                            return CONTINUE;
                          }

for                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "FOR");
                            return FOR;
                          }

def                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DEF");
                            return DEF;
                          }

while                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "WHILE");
                            return WHILE;
                          }

assert                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "ASSERT");
                            return ASSERT;
                          }

global                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "GLOBAL");
                            return GLOBAL;
                          }

not                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NOT");
                            return NOT;
                          }

elif                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "ELIF");
                            return ELIF;
                          }

if                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "IF");
                            return IF;
                          }

or                        {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "OR");
                            return OR;
                          }



"+="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "PLUSEQUAL");
                            return PLUSEQUAL;
                          }

"-="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "MINEQUAL");
                            return MINEQUAL;
                          }

"*="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "STAREQUAL");
                            return STAREQUAL;
                          }

"/="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "SLASHEQUAL");
                            return SLASHEQUAL;
                          }

"%="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "PERCENTEQUAL");
                            return PERCENTEQUAL;
                          }

"&="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "AMPEREQUAL");
                            return AMPEREQUAL;
                          }

"|="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "VBAREQUAL");
                            return VBAREQUAL;
                          }

"^="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "CIRCUMFLEXEQUAL");
                            return CIRCUMFLEXEQUAL;
                          }

"<<="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "LEFTSHIFTEQUAL");
                            return LEFTSHIFTEQUAL;
                          }

">>="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "RIGHTSHIFTEQUAL");
                            return RIGHTSHIFTEQUAL;
                          }

"**="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DOUBLESTAREQUAL");
                            return DOUBLESTAREQUAL;
                          }

"//="                     {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DOUBLESLASHEQUAL");
                            return DOUBLESLASHEQUAL;
                          }

"("                       {
                            line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "'('");
                              return '(';
                          }

")"                       {
                            line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "')'");
                              return ')';
                          }

"["                       {
                            line_join = 1; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "'['");
                              return '[';
                          }

"]"                       {
                            line_join = 0; string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "']'");
                              return ']';
                          }

","                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "','");
                              return ',';
                          }

":"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "':'");
                              return ':';
                          }

"."                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "'.'");
                              return '.';
                          }

";"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "';'");
                              return ';';
                          }

"="                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "'='");
                              return '=';
                          }

"->"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                            yylval.tokenname[i] = str[i];
                              yylval.tokenname[str.size()] = '\0'; 
                              line=yylineno;
                              fprintf(lexer_logfile, "%s\n", "ARROW");
                              return ARROW;
                          }

                        


"+"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'+'");
                            return '+';
                          }

"-"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'-'");
                            return '-';
                          }

"*"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'*'");
                            return '*';
                          }

"/"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'/'");
                            return '/';
                          }

"%"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'%'");
                            return '%';
                          }

"|"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'|'");
                            return '|';
                          }

"&"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'&'");
                            return '&';
                          }

"~"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'~'");
                            return '~';
                          }

"^"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "'^'");
                            return '^';
                          }

"<"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "LESSTHAN");
                            return LESSTHAN;
                          }

"<="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "LESSTHANEQUAL");
                            return LESSTHANEQUAL;
                          }

">"                       {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "GREATERTHAN");
                            return GREATERTHAN;
                          }

">="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "GREATERTHANEQUAL");
                            return GREATERTHANEQUAL;
                          }

">>"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "RIGHTSHIFT");
                            return RIGHTSHIFT;
                          }

"<<"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "LEFTSHIFT");
                            return LEFTSHIFT;
                          }

"//"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DOUBLESLASH"); return
                          DOUBLESLASH;}

"**"                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DOUBLESTAR");
                            return DOUBLESTAR;
                          }

"=="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "DOUBLEEQUAL"); return
                          DOUBLEEQUAL;}

"!="                      {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NOTEQUAL");
                            return NOTEQUAL;
                          }


{INTEGER}                 {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NUMBER");
                            return NUMBER;
                          }

{FLOAT_NUMBER}            {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NUMBER");
                            return NUMBER;
                          }

{IMAGINARY}               {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NUMBER");
                            return NUMBER;
                          }

{BYTE_STRING}             /* ignore BYTE_STRING */

{STRING}                  {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "STRING");
                            return STRING;
                          }

{NAME}                    {
                            string str = yytext;  
                            for(int i=0;i<str.size();i++)
                              yylval.tokenname[i] = str[i];
                            yylval.tokenname[str.size()] = '\0'; 
                            line=yylineno;
                            fprintf(lexer_logfile, "%s\n", "NAME");
                            return NAME;
                          }



{COMMENT}                 /* ignore COMMENT */

{WHITESPACE}              /* ignore WHITESPACE */

{OTHER}                   {
                            printf("Lexer: Invalid character %s found at line number %d\n", yytext, line);
                            exit(1);
                          }

%%
