%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
void yyerror(const char *);
extern int yylex();
extern int yylineno;
extern char* yytext;
FILE *output_file;
int line = 1;
void emit_dot_node(const char* node_name, const char* label) {
    fprintf(output_file, "%s [label=\"%s\"];\n", node_name, label);
}
void emit_dot_edge(const char* from, const char* to) {
    fprintf(output_file, "%s -> %s;\n", from, to);
}
%}

%union {char* tokenname;}
%token<tokenname> PLUSEQUAL MINEQUAL STAREQUAL SLASHEQUAL PERCENTEQUAL AMPEREQUAL VBAREQUAL CIRCUMFLEXEQUAL LEFTSHIFTEQUAL
%token<tokenname> RIGHTSHIFTEQUAL DOUBLESTAREQUAL DOUBLESLASHEQUAL DOUBLESLASH DOUBLESTAR NUMBER STRING NONE TRUE FALSE
%token<tokenname> NEWLINE ARROW DEF NAME BREAK CONTINUE RETURN GLOBAL ASSERT IF WHILE FOR ELSE ELIF INDENT DEDENT
%token<tokenname> AND OR NOT LESSTHAN GREATERTHAN DOUBLEEQUAL GREATERTHANEQUAL LESSTHANEQUAL NOTEQUAL IN IS LEFTSHIFT RIGHTSHIFT CLASS
%token<tokenname> ',' '.' ';' ':' '(' ')' '[' ']' '=' '+' '-' '~' '*' '/' '%' '^' '&' '|' 

%%

file_input:
  newline_or_stmt_list NEWLINE
  {

  }
;

newline_or_stmt:
  NEWLINE
  {
    strcpy($$, $1);
  }
| stmt
  {
    strcpy($$, $1);
  }
;

newline_or_stmt_list:
  %empty
  {
    $$[0] = '\0';
  }
| newline_or_stmt_list newline_or_stmt
  {
    emit_dot_edge("Root", $2);
  }
;

/*
  ARROW : '->'
*/

funcdef:
  DEF NAME parameters arrow_test_opt ':' suite
  {
    strcpy($$, "NAME(");
    strcat($$, $2);
    strcat($$, ")");
    node_map[$$]++;
    node_map["DEF"]++;
    

    s1 = "DEF" + to_string(node_map["DEF"]);
    s2 = $$ + to_string(node_map[$$]);
    emit_dot_edge(s1, s2);

    s1 = $$ + to_string(node_map[$$]);
    emit_dot_edge(s1, $3);

    if($4[0] != '\0'){
      node_map["ARROW"]++;
      s1 = "ARROW"+to_string(node_map["ARROW"]);
      s2 = "DEF"+to_string(node_map["DEF"]);
      emit_dot_edge(s1, s2);
    } 

    node_map[":"]++;
    s1 = $5+to_string(node_map[":"]);
    s2 = "ARROW"+to_string(node_map["ARROW"]);
    emit_dot_edge(s1, s2);
    
    emit_dot_edge(s1, $6);

    strcpy($$, $5);
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
  }
;

arrow_test_opt:
  %empty
  {
    $$[0] = '\0';
  }
| ARROW test
  {
    s1 = "ARROW"+to_string(node_map["ARROW"]);
    s2 = $2;
    emit_dot_edge(s1, s2);
  }
;

parameters:
  '(' typedargslist_opt ')'
  {
    node_map["()"]++;
    
    if($2[0] != '\0'){
      s1 = "()"+to_string(node_map["()"]);      
      s2 = $2;      
      emit_dot_edge(s1, s2);
    }
    
    strcpy($$, "()");
    string temp = to_string(node_map["()"]);
    strcat($$, temp.c_str());
  }
;

typedargslist_opt:
  %empty
| typedargslist
;

typedargslist:
  tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list
;

tfpdef:
  NAME colon_test_opt
;

comma_opt:
  %empty
| ','
;

equal_test_opt:
  %empty
| '=' test
;

comma_tfpdef_equal_test_opt_list:
  %empty
| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt
;

colon_test_opt:
  %empty
| ':' test
;

stmt:
  simple_stmt
| compound_stmt
;

semicolon_opt:
  %empty
| ';'
;

simple_stmt:
  small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE
;

semicolon_small_stmt_list:
  %empty
| semicolon_small_stmt_list ';' small_stmt
;

small_stmt: 
  expr_stmt
| flow_stmt
| global_stmt
| assert_stmt
;

expr_stmt:
  testlist_star_expr expr_stmt_suffix_choices
;

expr_stmt_suffix_choices:
  annassign 
| augassign testlist
| equal_testlist_star_expr_list
;

equal_testlist_star_expr_list:
  %empty
| equal_testlist_star_expr_list '=' testlist_star_expr
;

annassign:
  ':' test equal_test_opt
;

testlist_star_expr:
  test_or_star_expr comma_test_or_star_expr_list comma_opt
;

test_or_star_expr:
  test
| star_expr
;

comma_test_or_star_expr_list:
  %empty
| comma_test_or_star_expr_list ',' test_or_star_expr
;

augassign: 
  PLUSEQUAL
| MINEQUAL
| STAREQUAL
| SLASHEQUAL
| PERCENTEQUAL
| AMPEREQUAL
| VBAREQUAL
| CIRCUMFLEXEQUAL
| LEFTSHIFTEQUAL
| RIGHTSHIFTEQUAL
| DOUBLESTAREQUAL
| DOUBLESLASHEQUAL
;

/* For normal and annotated assignments, additional restrictions enforced by the interpreter*/

flow_stmt:
  break_stmt 
| continue_stmt
| return_stmt
;

break_stmt:
  BREAK
;

continue_stmt:
  CONTINUE
;

return_stmt:
  RETURN testlist_opt
;

testlist_opt:
  %empty
| testlist
;

global_stmt:
  GLOBAL NAME comma_name_list
;

comma_name_list:
  %empty
| comma_name_list ',' NAME
;

assert_stmt:
  ASSERT test comma_test_opt
;

comma_test_opt:
  %empty
| ',' test
;

compound_stmt:
  if_stmt
| while_stmt
| for_stmt
| funcdef
| classdef
;

if_stmt:
  IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt
;

while_stmt:
  WHILE test ':' suite else_colon_suite_opt
;
for_stmt:
  FOR exprlist IN testlist ':' suite else_colon_suite_opt
;

else_colon_suite_opt:
  %empty
| ELSE ':' suite
;

elif_test_colon_suite_list:
  %empty
| elif_test_colon_suite_list ELIF test ':' suite
;

/* NB compile.c makes sure that the default except clause is last*/

suite:
  simple_stmt | NEWLINE INDENT stmt stmt_list DEDENT
;

/*
NEWLINE_list:
  %empty
| NEWLINE_list NEWLINE
;
*/

stmt_list:
  %empty
| stmt_list stmt
;

test: 
  or_test if_or_test_else_test_opt
;

if_or_test_else_test_opt:
  %empty
| IF or_test ELSE test
;

test_nocond:
  or_test
;

or_test:
  and_test or_and_test_list
;

or_and_test_list:
  %empty
| or_and_test_list OR and_test
;

and_test:
  not_test and_not_test_list
;

and_not_test_list:
  %empty
| and_not_test_list AND not_test
;

not_test:
  NOT not_test
| comparison
;

comparison:
  expr comp_op_expr_list
;

comp_op_expr_list:
  %empty
| comp_op_expr_list comp_op expr
;

/* <> isn't actually a valid comparison operator in Python. It's here for the
   sake of a __future__ import described in PEP 401 (which really works :-)
*/
comp_op:
  LESSTHAN
| GREATERTHAN
| DOUBLEEQUAL
| GREATERTHANEQUAL
| LESSTHANEQUAL
| NOTEQUAL
| IN   /*-----------------MAY NEED TO remove this and the following comp_op--------------------*/
| NOT IN
| IS
| IS NOT
;

star_expr:
  '*' expr
;

expr:
  xor_expr or_xor_expr_list
;

or_xor_expr_list:
  %empty
| or_xor_expr_list '|' xor_expr
;

xor_expr:
  and_expr xor_and_expr_list
;

xor_and_expr_list:
  %empty
| xor_and_expr_list '^' and_expr
;

and_expr:
  shift_expr and_shift_expr_list
;

and_shift_expr_list:
  %empty
| and_shift_expr_list '&' shift_expr
;

shift_expr:
  arith_expr shift_arith_expr_list
;

ltshift_or_rtshift:
  LEFTSHIFT
| RIGHTSHIFT
;

shift_arith_expr_list:
  %empty
| shift_arith_expr_list ltshift_or_rtshift arith_expr
;

arith_expr:
  term plus_or_minus_term_list
;

plus_or_minus:
  '+'
| '-'
;

plus_or_minus_term_list:
  %empty
| plus_or_minus_term_list plus_or_minus term
;

term:
  factor star_or_slash_or_percent_or_doubleslash_factor_list
;

star_or_slash_or_percent_or_doubleslash:
  '*'
| '/'
| '%'
| DOUBLESLASH
;

star_or_slash_or_percent_or_doubleslash_factor_list:
  %empty
| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor
;

factor:
  plus_or_minus_or_tilde factor
| power
; 

plus_or_minus_or_tilde:
  '+'
| '-'
| '~'
;

power:
  atom_expr doublestar_factor_opt
;

doublestar_factor_opt:
  %empty
| DOUBLESTAR factor
;

atom_expr:
  atom trailer_list
;

trailer_list:
  %empty
| trailer_list trailer
;

atom:
  '(' testlist_comp_opt ')'
| '[' testlist_comp_opt ']'
| NAME
| NUMBER
| STRING string_list
| NONE 
| TRUE
| FALSE
;

string_list:
  %empty
| string_list STRING
;

testlist_comp_opt:
  %empty
| testlist_comp
;

testlist_comp:
  test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt
;

comp_for_OR_comma_test_or_star_expr_list_comma_opt:
  comp_for
| comma_test_or_star_expr_list comma_opt
;

trailer:
  '(' arglist_opt ')'
  {
    node_map["()"]++;
    string no=to_string(node_map["()"]);
    string s="()"+no;
    emit_dot_node(s, "()");
    if($2!=NULL)
      emit_dot_edge(s, $2);
    strcpy($$, s);
  }
| '[' subscriptlist ']'
{
  node_map["[]"]++;
  string no=to_string(node_map["[]"]);
  string s="[]"+no;
  emit_dot_node(s, "[]");
  if($2!=NULL)
    emit_dot_edge(s, $2);
  strcpy($$, s);
}
| '.' NAME
{
  node_map["."]++;
  string no=to_string(node_map["."]);
  string s="."+no;
  emit_dot_node(s, ".");
  strcpy($$, s);
}
;

arglist_opt:
  %empty
  {
    $$=NULL;
  }
| arglist
{
  $$=$1;
}
;

subscriptlist: 
  subscript comma_subscript_list comma_opt
  {
    if($2==NULL && $3==NULL)
      strcpy($$, $1);
    else if($3==NULL)
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        emit_dot_node(s, ",");
        emit_dot_edge(s, $1);
        emit_dot_edge(s, $2);
        strcpy($$, s);
      }
      else {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        emit_dot_node(s, ",");
        emit_dot_edge(s, $1);
        if($2!=NULL)
          emit_dot_edge(s, $2);
        strcpy($$, s);
      }
  }
;

comma_subscript_list:
  %empty
  {
    $$=NULL;
  }
| comma_subscript_list ',' subscript
{
  node_map[","]++;
  string no=to_string(node_map[","]);
  string s=","+no;
  emit_dot_node(s, ",");
  if($1!=NULL)
    emit_dot_edge(s, $1);
  emit_dot_edge(s, $3);
  $$=s;  
}
;

subscript:
  test
  {
    $$=$1;
  }
| test_opt ':' test_opt
{
  node_map[":"]++;
  string no=to_string(node_map[":"]);
  string s=":"+no;
  emit_dot_node(s, ":");
  if($1!=NULL)
    emit_dot_edge(s, $1);
  if($3!=NULL)
    emit_dot_edge(s, $3);
  $$=s;
}
;

test_opt: 
  %empty
  {
    $$=NULL;
  }
| test
{
  $$=$1;
}
;

exprlist:
  expr_or_star_expr comma_expr_or_star_expr_list comma_opt
  {
    if($2==NULL && $3==NULL)
      strcpy($$, $1);
    else 
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        emit_dot_node(s, ",");
        emit_dot_edge(s, $1);
        strcpy($$, s);
      }
  }
;

comma_expr_or_star_expr_list:
  %empty
  {
    $$=NULL;
  }
| comma_expr_or_star_expr_list ',' expr_or_star_expr
{
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
      emit_dot_node(s, ",");
      if($1!=NULL)
        emit_dot_edge(s, $1);
      emit_dot_edge(s, $2);
      $$=s;
}
;

expr_or_star_expr:
  expr
  {
    strcpy($$, $1);
  }
| star_expr
{
  strcpy($$, $1);
}
;

testlist:
  test comma_test_list comma_opt
  {
    if($2==NULL && $3==NULL)
      strcpy($$, $1);
    else if($3==NULL)
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        emit_dot_node(s, ",");
        emit_dot_edge(s, $1);
        strcpy($$, s);
      }
      else {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        emit_dot_node(s, ",");
        emit_dot_edge(s, $1);
        if($2!=NULL)
          emit_dot_edge(s, $2);
        strcpy($$, s);
      }
  }
;

comma_test_list:
  %empty
  {
    $$=NULL;
  }
| comma_test_list ',' test
{
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
    emit_dot_node(s, ",");
    if($1!=NULL)
      emit_dot_edge(s, $1);
    emit_dot_edge(s, $3);
    strcpy($$, s);
}
;

classdef:
  CLASS NAME parenthesis_arglist_opt_opt ':' suite
  {
    strcpy($$, "NAME(");
    strcat($$, $2);
    strcat($$, ")");
    node_map[$$]++;
    node_map["CLASS"]++;

    s1 = "CLASS"+to_string(node_map["CLASS"]);
    s2 = $$+to_string(node_map[$$]);
    emit_dot_edge(s1, s2);

    node_map["()"]++;

    s1 = $$+to_string(node_map[$$]);
    s2 = "()"+to_string(node_map["()"]);
    emit_dot_edge(s1, s2);
    
    if($3[0] != '\0'){
      s1 = s2;
      s2 = $3;
      emit_dot_edge(s1, s2);
    }
    
    node_map[":"]++;

    s1 = $6+to_string(node_map[":"]);
    s2 = "CLASS"+to_string(node_map["CLASS"]);
    emit_dot_edge(s1, s2);

    s2 = $5;
    emit_dot_edge(s1, s2);

    strcpy($$, $6);
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
  }
;

parenthesis_arglist_opt_opt:
  %empty
  {
    $$=NULL;
  
  }
| '(' arglist_opt ')'
{
  node_map["()"]++;
  string no=to_string(node_map["()"]);
  string s="()"+no;
  emit_dot_node(s, "()");
  emit_dot_edge(s, $2);
  strcpy($$, s);
}
;

arglist:
  argument 
  {
    strcpy($$, $1);
  }
|  argument comma_argument_list  comma_opt
{
  if($3==NULL)
    strcpy($$, $1);
  else
    {
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
    emit_dot_node(s, ",");
    emit_dot_edge(s, $1);
    emit_dot_edge(s, $3);
    strcpy($$, s);
    }
}
;

comma_argument_list:
  %empty
  {
    $$=NULL;
  }
| comma_argument_list ',' argument
{
  if($3==NULL)
    strcpy($$, $1);
  else
    {
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
    emit_dot_node(s, ",");
    emit_dot_edge(s, $1);
    emit_dot_edge(s, $3);
    strcpy($$, s);
    }
}
;

/* The reason that keywords are test nodes instead of NAME is that using NAME */
/* results in an ambiguity. ast.c makes sure it's a NAME.*/
/* "test '=' test" is really "keyword '=' test", but we have no such token.*/
/* These need to be in a single rule to avoid grammar that is ambiguous*/
/* to our LL(1) parser. Even though 'test' includes '*expr' in star_expr,*/
/* we explicitly match '*' here, too, to give it proper precedence.*/
/* Illegal combinations and orderings are blocked in ast.c:*/
/* multiple (test comp_for) arguments are blocked; keyword unpackings*/
/* that precede iterable unpackings are blocked; etc.*/

argument:
  test comp_for_opt
  {
    if($2==NULL)
      strcpy($$, $1);
    else
      {
    emit_dot_node("argument", "Argument with Comprehension");
    emit_dot_edge("argument", $1);
    emit_dot_edge("argument", $2);
    }
  }
| test '=' test
  {
    node_map["="]++;
    string no=to_string(node_map["="]);
    string s=$2+no;
    emit_dot_node(s, "=");
    emit_dot_edge(s, $1);
    emit_dot_edge(s, $3);
    strcpy($$, s);
  }
| '*' test
  {
    node_map["*"]++;
    string no=to_string(node_map["*"]);
    string s="*"+no;
    emit_dot_node(s, "*");
    emit_dot_edge(s, $2);
    strcpy($$, s);
  }
;

comp_for_opt:
  %empty
| comp_for
;

comp_iter:
  comp_for
| comp_if
;

comp_for:
  FOR exprlist IN or_test comp_iter_opt
;

comp_if:
  IF test_nocond comp_iter_opt
;

comp_iter_opt:
  %empty
| comp_iter
;

/* not used in grammar, but may appear in "node" passed from Parser to Compiler */
/*
encoding_decl: NAME
*/


%%

void yyerror(const char* s) {
  fprintf(stderr, "Parse error: %s at line number %d\n", s, line);
  exit(1);
}

int main(int argc, char** argv) {
  if (argc != 3) {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    // Open input file
    FILE * input_file = fopen(argv[1], "r");
    if (input_file == NULL) {
        perror("Error opening input file");
        return 1;
    }

    // Open output file
    output_file = fopen(argv[2], "w");
    if (output_file == NULL) {
        perror("Error opening output file");
        fclose(input_file); // Close the input file before exiting
        return 1;
    }
  
    fprintf(output_file, "digraph G {\n");

    yyin = input_file;
    yyparse();

    fprintf(output_file, "}\n");

    fclose(input_file);
    fclose(output_file);
    return 0;
}
