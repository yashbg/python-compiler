%{
  #include <stdio.h>
  #include "parser.tab.h"

  extern FILE *lexer_logfile;
  extern void yyerror(const char *);

  int dedentsToBeReturned = 0;
  int indentToBeReturned = 0;
  int line_join = 0;
  int column;
  int indent[100];
  int top=0;

  void store_token();
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

\n([\n\t ]*{COMMENT}[\n\t ]+)+  {
                            store_token();
                            if (!line_join) {
                              int last_newline_pos =  -1, len = strlen(yytext);
                              for(int i = 0; i < len; i++){
                                if(yytext[i] == '\n') last_newline_pos = i;
                              }
                              if(last_newline_pos != -1){
                                fprintf(lexer_logfile, "Reached Comment pattern  ");
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
                                    yyerror("indentation error: unindent does not match any outer indentation level");
                                  }
                                }
                                fprintf(lexer_logfile, "NEWLINE\n");
                                return NEWLINE;
                              }
                            }
                          }

[\n\t ]+                  {
                            if (!line_join) {
                              int last_newline_pos =  -1, len = strlen(yytext);
                              for(int i = 0; i < len; i++){
                                if(yytext[i] == '\n') last_newline_pos = i;
                              }
                              if(last_newline_pos != -1){
                                fprintf(lexer_logfile, "Reached indent pattern  ");
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
                                    yyerror("indentation error: unindent does not match any outer indentation level");
                                  }
                                }
                                fprintf(lexer_logfile, "NEWLINE\n");
                                return NEWLINE;
                              }
                            }
                          }

\\[\n][\t ]*              /*----Explicit Line Joining------*/

False                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "FALSE");
                            return FALSE;
                          }

else                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "ELSE");
                            return ELSE;
                          }

None                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "NONE");
                            return NONE;
                          }

break                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "BREAK");
                            return BREAK;
                          }

in                        {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "IN");
                            return IN;
                          }

True                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "TRUE");
                            return TRUE;
                          }

class                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "CLASS");
                            return CLASS;
                          }

return                    {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "RETURN");
                            return RETURN;
                          }

and                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "AND");
                            return AND;
                          }

continue                  {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "CONTINUE");
                            return CONTINUE;
                          }

for                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "FOR");
                            return FOR;
                          }

def                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DEF");
                            return DEF;
                          }

while                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "WHILE");
                            return WHILE;
                          }

global                    {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "GLOBAL");
                            return GLOBAL;
                          }

not                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "NOT");
                            return NOT;
                          }

elif                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "ELIF");
                            return ELIF;
                          }

if                        {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "IF");
                            return IF;
                          }

or                        {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "OR");
                            return OR;
                          }



"+="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "PLUSEQUAL");
                            return PLUSEQUAL;
                          }

"-="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "MINEQUAL");
                            return MINEQUAL;
                          }

"*="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "STAREQUAL");
                            return STAREQUAL;
                          }

"/="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "SLASHEQUAL");
                            return SLASHEQUAL;
                          }

"%="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "PERCENTEQUAL");
                            return PERCENTEQUAL;
                          }

"&="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "AMPEREQUAL");
                            return AMPEREQUAL;
                          }

"|="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "VBAREQUAL");
                            return VBAREQUAL;
                          }

"^="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "CIRCUMFLEXEQUAL");
                            return CIRCUMFLEXEQUAL;
                          }

"<<="                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "LEFTSHIFTEQUAL");
                            return LEFTSHIFTEQUAL;
                          }

">>="                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "RIGHTSHIFTEQUAL");
                            return RIGHTSHIFTEQUAL;
                          }

"**="                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DOUBLESTAREQUAL");
                            return DOUBLESTAREQUAL;
                          }

"//="                     {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DOUBLESLASHEQUAL");
                            return DOUBLESLASHEQUAL;
                          }

"("                       {
                            line_join = 1;
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'('");
                            return '(';
                          }

")"                       {
                            line_join = 0;
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "')'");
                            return ')';
                          }

"["                       {
                            line_join = 1;
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'['");
                            return '[';
                          }

"]"                       {
                            line_join = 0;
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "']'");
                            return ']';
                          }

","                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "','");
                            return ',';
                          }

":"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "':'");
                            return ':';
                          }

"."                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'.'");
                            return '.';
                          }

";"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "';'");
                            return ';';
                          }

"="                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'='");
                            return '=';
                          }

"->"                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "ARROW");
                            return ARROW;
                          }




"+"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'+'");
                            return '+';
                          }

"-"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'-'");
                            return '-';
                          }

"*"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'*'");
                            return '*';
                          }

"/"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'/'");
                            return '/';
                          }

"%"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'%'");
                            return '%';
                          }

"|"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'|'");
                            return '|';
                          }

"&"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'&'");
                            return '&';
                          }

"~"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'~'");
                            return '~';
                          }

"^"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "'^'");
                            return '^';
                          }

"<"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "LESSTHAN");
                            return LESSTHAN;
                          }

"<="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "LESSTHANEQUAL");
                            return LESSTHANEQUAL;
                          }

">"                       {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "GREATERTHAN");
                            return GREATERTHAN;
                          }

">="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "GREATERTHANEQUAL");
                            return GREATERTHANEQUAL;
                          }

">>"                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "RIGHTSHIFT");
                            return RIGHTSHIFT;
                          }

"<<"                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "LEFTSHIFT");
                            return LEFTSHIFT;
                          }

"//"                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DOUBLESLASH");
                            return DOUBLESLASH;
                          }

"**"                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DOUBLESTAR");
                            return DOUBLESTAR;
                          }

"=="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "DOUBLEEQUAL");
                            return DOUBLEEQUAL;
                          }

"!="                      {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "NOTEQUAL");
                            return NOTEQUAL;
                          }


{INTEGER}                 {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "INTEGER");
                            return INTEGER;
                          }

{FLOAT_NUMBER}            {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "FLOAT_NUMBER");
                            return FLOAT_NUMBER;
                          }

{IMAGINARY}               {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "IMAGINARY");
                            return IMAGINARY;
                          }

{BYTE_STRING}             /* ignore BYTE_STRING */

{STRING}                  {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "STRING");
                            return STRING;
                          }

{NAME}                    {
                            store_token();
                            fprintf(lexer_logfile, "%s\n", "NAME");
                            return NAME;
                          }



{COMMENT}                 /* ignore COMMENT */

{WHITESPACE}              /* ignore WHITESPACE */

{OTHER}                   yyerror("invalid character");

%%

void store_token() {
  for (int i = 0; i < yyleng; i++) {
    yylval.tokenname[i] = yytext[i];
  }
  yylval.tokenname[yyleng] = '\0';
}
