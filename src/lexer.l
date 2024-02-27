%option noyywrap
%option yylineno
%option case-insensitive

%{
    #include <stdio.h>
    #include <string>
    // #define YY_DECL int yylex()
    #include "parser.tab.h"
    #include <bits/stdc++.h>
    using namespace std;
    extern int line;
%}
DIGIT               [0-9]
LETTER              [_a-zA-Z]        
WHITESPACE          " "|"\t"|"\f"
NEWLINE             "\n"
KEYWORD             "False" | "await" | "else" | "import" | "pass" | "None" | "break" | "except" | "in" | "raise" | "True" | "class" | "finally" | "is" | "return" | "and" | "continue" | "for" | "lambda" | "try" |"as" | "def" | "from" | "nonlocal" | "while" | "assert" | "del" | "global" | "not" | "with" | "async" | "elif" | "if" | "or" | "yield"
DELIMITERS          "(" | ")" | "[" | "]" | "{" | "}" | "," | ":" | "." | ";" | "@" | "=" | "->" | "+=" | "-=" | "*=" | "/=" | "//=" | "%=" | "@=" | "&=" | "|=" | "^=" | ">>=" | "<<=" | "**="
OPERATORS           "+" | "-" | "*" | "**" | "/" | "//" | "%" | "@" | "<<" | ">>" | "&" | "|" | "^" | "~" | ":=" | "<" | ">" | "<=" | ">=" | "==" | "!="

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


"+="            {yyval.tokenname=yytext; line=yylineno; return PLUSEQUAL;}
"-="             {yyval.tokenname=yytext; line=yylineno; return MINEQUAL;}
"*="            {yyval.tokenname=yytext; line=yylineno; return STAREQUAL;}
"@="              {yyval.tokenname=yytext; line=yylineno; return ATEQUAL;}
"/="           {yyval.tokenname=yytext; line=yylineno; return SLASHEQUAL;}
"%="         {yyval.tokenname=yytext; line=yylineno; return PERCENTEQUAL;}
"&="           {yyval.tokenname=yytext; line=yylineno; return AMPEREQUAL;}
"|="            {yyval.tokenname=yytext; line=yylineno; return VBAREQUAL;}
"^="      {yyval.tokenname=yytext; line=yylineno; return CIRCUMFLEXEQUAL;}
"<<="       {yyval.tokenname=yytext; line=yylineno; return LEFTSHIFTEQUAL;}
">>="      {yyval.tokenname=yytext; line=yylineno; return RIGHTSHIFTEQUAL;}
"**="      {yyval.tokenname=yytext; line=yylineno; return DOUBLESTAREQUAL;}
"//="     {yyval.tokenname=yytext; line=yylineno; return DOUBLESLASHEQUAL;}
"\("              {yyval.tokenname=yytext; line=yylineno; return '(';}
"\)"              {yyval.tokenname=yytext; line=yylineno; return ')';}
"\["              {yyval.tokenname=yytext; line=yylineno; return '[';}
"\]"              {yyval.tokenname=yytext; line=yylineno; return ']';}
"\{"              {yyval.tokenname=yytext; line=yylineno; return '{';}
"\}"              {yyval.tokenname=yytext; line=yylineno; return '\}';}
","              {yyval.tokenname=yytext; line=yylineno; return ',';}
":"              {yyval.tokenname=yytext; line=yylineno; return ':';}
"."              {yyval.tokenname=yytext; line=yylineno; return '.';}
";"              {yyval.tokenname=yytext; line=yylineno; return ';';}
"@"              {yyval.tokenname=yytext; line=yylineno; return "@";}
"="              {yyval.tokenname=yytext; line=yylineno; return '=';}
"->"            {yyval.tokenname=yytext; line=yylineno; return ARROW;}


{WHITESPACE}            
{OTHER}                 {yylval.tokenname=yytext; line=yylineno; return OTHER;}

%%

int main()
{
    yyFlexLexer lexer;
    lexer.yylex();
    return 0;
}