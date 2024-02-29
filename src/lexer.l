%option noyywrap
%option yylineno

%{
    #include <stdio.h>
    #include <string>
    // #define YY_DECL int yylex()
    #include "parser.tab.h"
    #include <bits/stdc++.h>
    using namespace std;
    extern int line;
    int column;
    int indent[100];
    int top=0;
    // FSTRING_START MIDDLE END - ignore
    // NAME - done
    // TYPE_COMMENT - done
    // STRING - done 
    // INDENT DEDENT 
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
DELIMITERS          "("|")"|"["|"]"|"{"|"}"|","|":"|"."|";"|"@"|"="|"->"|"+="|"-="|"*="|"/="|"//="|"%="|"@="|"&="|"|="|"^="|">>="|"<<="|"**="
OPERATORS           "+"|"-"|"*"|"**"|"/"|"//"|"%"|"@"|"<<"|">>"|"&"|"|"|"^"|"~"|":="|"<"|">"|"<="|">="|"=="|"!="
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

False                      {yyval.tokenname=yytext; line=yylineno; return FALSE;}
await                      {yyval.tokenname=yytext; line=yylineno; return AWAIT;}
else                       {yyval.tokenname=yytext; line=yylineno; return ELSE;}
import                     {yyval.tokenname=yytext; line=yylineno; return IMPORT;}
pass                       {yyval.tokenname=yytext; line=yylineno; return PASS;}
None                       {yyval.tokenname=yytext; line=yylineno; return NONE;}
break                      {yyval.tokenname=yytext; line=yylineno; return BREAK;}
except                     {yyval.tokenname=yytext; line=yylineno; return EXCEPT;}
in                         {yyval.tokenname=yytext; line=yylineno; return IN;}
raise                      {yyval.tokenname=yytext; line=yylineno; return RAISE;}
True                       {yyval.tokenname=yytext; line=yylineno; return TRUE;}
class                      {yyval.tokenname=yytext; line=yylineno; return CLASS;}
finally                    {yyval.tokenname=yytext; line=yylineno; return FINALLY;}
is                         {yyval.tokenname=yytext; line=yylineno; return IS;}
return                     {yyval.tokenname=yytext; line=yylineno; return RETURN;}
and                        {yyval.tokenname=yytext; line=yylineno; return AND;}
continue                   {yyval.tokenname=yytext; line=yylineno; return CONTINUE;}
for                        {yyval.tokenname=yytext; line=yylineno; return FOR;}
lambda                     {yyval.tokenname=yytext; line=yylineno; return LAMBDA;}
try                        {yyval.tokenname=yytext; line=yylineno; return TRY;}
as                         {yyval.tokenname=yytext; line=yylineno; return AS;}
def                        {yyval.tokenname=yytext; line=yylineno; return DEF;}
from                       {yyval.tokenname=yytext; line=yylineno; return FROM;}
nonlocal                   {yyval.tokenname=yytext; line=yylineno; return NONLOCAL;}
while                      {yyval.tokenname=yytext; line=yylineno; return WHILE;}
assert                     {yyval.tokenname=yytext; line=yylineno; return ASSERT;}
del                        {yyval.tokenname=yytext; line=yylineno; return DEL;}
global                     {yyval.tokenname=yytext; line=yylineno; return GLOBAL;}
not                        {yyval.tokenname=yytext; line=yylineno; return NOT;}
with                       {yyval.tokenname=yytext; line=yylineno; return WITH;}
async                      {yyval.tokenname=yytext; line=yylineno; return ASYNC;}
elif                       {yyval.tokenname=yytext; line=yylineno; return ELIF;}
if                         {yyval.tokenname=yytext; line=yylineno; return IF;}
or                         {yyval.tokenname=yytext; line=yylineno; return OR;}
yield                      {yyval.tokenname=yytext; line=yylineno; return YIELD;}


"+="                    {yyval.tokenname=yytext; line=yylineno; return PLUSEQUAL;}
"-="                    {yyval.tokenname=yytext; line=yylineno; return MINEQUAL;}
"*="                    {yyval.tokenname=yytext; line=yylineno; return STAREQUAL;}
"@="                    {yyval.tokenname=yytext; line=yylineno; return ATEQUAL;}
"/="                    {yyval.tokenname=yytext; line=yylineno; return SLASHEQUAL;}
"%="                    {yyval.tokenname=yytext; line=yylineno; return PERCENTEQUAL;}
"&="                    {yyval.tokenname=yytext; line=yylineno; return AMPEREQUAL;}
"|="                    {yyval.tokenname=yytext; line=yylineno; return VBAREQUAL;}
"^="                    {yyval.tokenname=yytext; line=yylineno; return CIRCUMFLEXEQUAL;}
"<<="                   {yyval.tokenname=yytext; line=yylineno; return LEFTSHIFTEQUAL;}
">>="                   {yyval.tokenname=yytext; line=yylineno; return RIGHTSHIFTEQUAL;}
"**="                   {yyval.tokenname=yytext; line=yylineno; return DOUBLESTAREQUAL;}
"//="                   {yyval.tokenname=yytext; line=yylineno; return DOUBLESLASHEQUAL;}
"("                     {yyval.tokenname=yytext; line=yylineno; return '(';}
")"                     {yyval.tokenname=yytext; line=yylineno; return ')';}
"["                     {yyval.tokenname=yytext; line=yylineno; return '[';}
"]"                     {yyval.tokenname=yytext; line=yylineno; return ']';}
"{"                     {yyval.tokenname=yytext; line=yylineno; return '{';}
"}"                     {yyval.tokenname=yytext; line=yylineno; return '}';}
","                     {yyval.tokenname=yytext; line=yylineno; return ',';}
":"                     {yyval.tokenname=yytext; line=yylineno; return ':';}
"."                     {yyval.tokenname=yytext; line=yylineno; return '.';}
";"                     {yyval.tokenname=yytext; line=yylineno; return ';';}
"@"                     {yyval.tokenname=yytext; line=yylineno; return "@";}
"="                     {yyval.tokenname=yytext; line=yylineno; return '=';}
"->"                    {yyval.tokenname=yytext; line=yylineno; return ARROW;}


"+"             {yyval.tokenname=yytext; line=yylineno; return '+';}
"-"             {yyval.tokenname=yytext; line=yylineno; return '-';}
"*"             {yyval.tokenname=yytext; line=yylineno; return '*';}
"/"             {yyval.tokenname=yytext; line=yylineno; return '/';}
"%"             {yyval.tokenname=yytext; line=yylineno; return '%';}
"|"             {yyval.tokenname=yytext; line=yylineno; return '|';}
"&"             {yyval.tokenname=yytext; line=yylineno; return '&';}
"~"             {yyval.tokenname=yytext; line=yylineno; return '~';}
"^"             {yyval.tokenname=yytext; line=yylineno; return '^';}
"<"             {yyval.tokenname=yytext; line=yylineno; return LESSTHAN;}
"<="            {yyval.tokenname=yytext; line=yylineno; return LESSTHANEQUAL;}
">"             {yyval.tokenname=yytext; line=yylineno; return GREATERTHAN;}
">="            {yyval.tokenname=yytext; line=yylineno; return GREATERTHANEQUAL;}
">>"            {yyval.tokenname=yytext; line=yylineno; return RIGHTSHIFT;}
"<<"            {yyval.tokenname=yytext; line=yylineno; return LEFTSHIFT;}
"//"            {yyval.tokenname=yytext; line=yylineno; return DOUBLESLASH;}
"**"            {yyval.tokenname=yytext; line=yylineno; return DOUBLESTAR;}
"=="            {yyval.tokenname=yytext; line=yylineno; return DOUBLEEQUAL;}
"!="            {yyval.tokenname=yytext; line=yylineno; return NOTEQUAL;}
":="            {yyval.tokenname=yytext; line=yylineno; return COLON_EQUAL;}

{INTEGER}                           {yyval.tokenname=yytext; line=yylineno; return NUMBER;}
{FLOAT_NUMBER}                      {yyval.tokenname=yytext; line=yylineno; return NUMBER;}
{IMAGINARY}                         {yyval.tokenname=yytext; line=yylineno; return NUMBER;}
{BYTE_STRING}                       {yyval.tokenname=yytext; line=yylineno; return BYTE_STRING;}
{STRING}                            {yyval.tokenname=yytext; line=yylineno; return STRING;}
{NAME}                              {yyval.tokenname=yytext; line=yylineno; return NAME;}


^[\t ]* {
    int spaces=0;
    if(top==0) indent[top]=0;
    column=0;
    while(isspace(yytext[spaces])) {
        if(yytext[spaces]=='\t') column+=4;
        else column++;
        spaces++;
    }
    if(column>indent[top]) {
        indent[++top]=column;
        return INDENT;
    }
    else
    {
        while(column<indent[top]) {
            top--;
            if(column!=indent[top]) {
                printf("IndentationError: unindent does not match any outer indentation level\n");
                exit(1);
            }
            return DEDENT;
        }
    }
}


{COMMENT}                   {yyval.tokenname=yytext; line=yylineno; return TYPE_COMMENT;}
{NEWLINE}                   {yyval.tokenname=yytext; line=yylineno; return NEWLINE;}
{WHITESPACE}           
{OTHER}                     

%%

int main()
{
    yyFlexLexer lexer;
    lexer.yylex();
    return 0;
}