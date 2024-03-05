%{
#include <iostream>
#include <string>
#include <map>
#include <cstring>
#include <cstdlib>
#include <fstream>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern std::ofstream outfile;

void yyerror(const char *);

std::map<std::string, int> node_map;
int line = 1;
std::string s1, s2;

int is_digit(char c) {
  return ((c >= '0') && (c <= '9'));
}

void emit_dot_node(const char* node_name, const char* label) {
  outfile << "\"" << node_name << "\" [label=\"" << label << "\"];" << std::endl;
}

void emit_dot_edge(const char* from, const char* to) {
    if((from[0] == '\0')) return;
    if(to[0] == '\0') return;
    char* fromlabel = (char*)malloc(strlen(from) + 1);  // Allocate memory for fromlabel
    char* tolabel = (char*)malloc(strlen(to) + 1); 
    int i = 0;
    while(from[i] != '\0'){
      fromlabel[i] = from[i];
      i++;
    }
    int j = 0;
    while(to[j] != '\0'){
      tolabel[j] = to[j];
      j++;
    }
    i--;j--;
    while(i>=0 && is_digit(from[i])){
      i--;
    }
    while(j>=0 && is_digit(to[j])){
      j--;
    }
    fromlabel[i+1] = '\0';
    tolabel[j+1] = '\0';
    emit_dot_node(from, fromlabel);
    emit_dot_node(to, tolabel);
    outfile << "\"" << from << "\" -> \"" << to << "\";" << std::endl;
    free(fromlabel);  // Free allocated memory
    free(tolabel);    // Free allocated memory
}
%}

%code requires {
    #include <string>
    #include <iostream>
    #include <cstdlib>
    #include <string>
    #include <map>
    using namespace std;
}

%union {char tokenname[1024];}
%token<tokenname> PLUSEQUAL MINEQUAL STAREQUAL SLASHEQUAL PERCENTEQUAL AMPEREQUAL VBAREQUAL CIRCUMFLEXEQUAL LEFTSHIFTEQUAL
%token<tokenname> RIGHTSHIFTEQUAL DOUBLESTAREQUAL DOUBLESLASHEQUAL DOUBLESLASH DOUBLESTAR NUMBER STRING NONE TRUE FALSE
%token<tokenname> NEWLINE ARROW DEF NAME BREAK CONTINUE RETURN GLOBAL ASSERT IF WHILE FOR ELSE ELIF INDENT DEDENT
%token<tokenname> AND OR NOT LESSTHAN GREATERTHAN DOUBLEEQUAL GREATERTHANEQUAL LESSTHANEQUAL NOTEQUAL IN IS LEFTSHIFT RIGHTSHIFT CLASS
%token<tokenname> ',' '.' ';' ':' '(' ')' '[' ']' '=' '+' '-' '~' '*' '/' '%' '^' '&' '|' 


%type<tokenname> file_input newline_or_stmt newline_or_stmt_list funcdef arrow_test_opt parameters typedargslist_opt typedargslist tfpdef comma_opt equal_test_opt comma_tfpdef_equal_test_opt_list colon_test_opt
%type<tokenname> semicolon_opt expr_stmt simple_stmt semicolon_small_stmt_list small_stmt stmt expr_stmt_suffix_choices equal_testlist_star_expr_list annassign testlist_star_expr test_or_star_expr comma_test_or_star_expr_list augassign flow_stmt break_stmt continue_stmt return_stmt
%type<tokenname> testlist_opt global_stmt comma_name_list assert_stmt comma_test_opt compound_stmt if_stmt while_stmt for_stmt else_colon_suite_opt elif_test_colon_suite_list stmt_list test if_or_test_else_test_opt test_nocond or_test or_and_test_list and_test
%type<tokenname> and_not_test_list not_test comparison comp_op_expr_list comp_op star_expr expr or_xor_expr_list xor_expr xor_and_expr_list and_expr and_shift_expr_list shift_expr ltshift_or_rtshift shift_arith_expr_list arith_expr plus_or_minus
%type<tokenname> plus_or_minus_term_list term star_or_slash_or_percent_or_doubleslash star_or_slash_or_percent_or_doubleslash_factor_list factor plus_or_minus_or_tilde power doublestar_factor_opt atom_expr trailer_list atom string_list testlist_comp_opt testlist_comp comp_for_OR_comma_test_or_star_expr_list_comma_opt
%type<tokenname> trailer arglist_opt subscript subscriptlist comma_subscript_list test_opt exprlist comma_expr_or_star_expr_list expr_or_star_expr testlist
%type<tokenname> comma_test_list classdef parenthesis_arglist_opt_opt arglist comma_argument_list argument suite comp_for_opt comp_iter comp_for comp_if comp_iter_opt
%%

file_input:
  newline_or_stmt_list
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
    $$[0]='\0';
  }
| newline_or_stmt_list newline_or_stmt
  {
    char str[5] = "Root";
    emit_dot_edge(str, $2);
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
    emit_dot_edge(s1.c_str(), s2.c_str());

    s1 = $$ + to_string(node_map[$$]);
    emit_dot_edge(s1.c_str(), $3);

    if($4 != NULL){
      node_map["ARROW"]++;
      s1 = "ARROW"+to_string(node_map["ARROW"]);
      s2 = "DEF"+to_string(node_map["DEF"]);
      emit_dot_edge(s1.c_str(), s2.c_str());
    } 

    node_map[":"]++;
    s1 = $5+to_string(node_map[":"]);
    s2 = "ARROW"+to_string(node_map["ARROW"]);
    emit_dot_edge(s1.c_str(), s2.c_str());
    
    emit_dot_edge(s1.c_str(), $6);

    strcpy($$, $5);
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
  }
;

arrow_test_opt:
  %empty
  {
    $$[0]='\0';
  }
| ARROW test
  {
    s1 = "ARROW"+to_string(node_map["ARROW"]);
    s2 = $2;
    emit_dot_edge(s1.c_str(), $2);
  }
;

parameters:
  '(' typedargslist_opt ')'
  {
    node_map["()"]++;
    
    if($2 != NULL){
      s1 = "()"+to_string(node_map["()"]); 
      emit_dot_edge(s1.c_str(), $2);
    }
    
    strcpy($$, "()");
    string temp = to_string(node_map["()"]);
    strcat($$, temp.c_str());
  }
;

typedargslist_opt:
  %empty
  {
    $$[0]='\0';
  }
| typedargslist
  {
    strcpy($$, $1);
  }
;

typedargslist:
  tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list
  {
    if($2 != NULL) {
      node_map["="]++;
      s1 = "=" + to_string(node_map["="]);
      s2 = $1;
      emit_dot_edge(s1.c_str(), s2.c_str());
    }
    
    if($3!=NULL)
    {
      if($2 != NULL){
        s1 = $3;
        s2 = "=" + to_string(node_map["="]);
        emit_dot_edge($3, s2.c_str());
        strcpy($$, $3);
      }
      else{
        emit_dot_edge($3, $1);
        strcpy($$, $2);
      }
    }
    else
    {
      if($2 != NULL){
        strcpy($$, "=");
        string temp = to_string(node_map["="]);
        strcat($$, temp.c_str());
      }
      else{
        strcpy($$, $1);
      }
    }
  }
;

tfpdef:
  NAME colon_test_opt
  {
    strcpy($$, "NAME(");
    strcat($$, $1);
    strcat($$, ")");
    node_map[$$]++;

    if($2 != NULL){
      node_map[":"]++;
      s1 = $2+to_string(node_map[":"]);       
      s2 = $$+to_string(node_map[$$]);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    strcpy($$, $2);    
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
  }
;

comma_opt:
  %empty
  {
    $$[0]='\0';
  }
| ','
  {
    strcpy($$, $1);
  }
;

equal_test_opt:
  %empty
  {
    $$[0]='\0';
  }
| '=' test
  {
    s1 = "="+to_string(node_map["="]);
    emit_dot_edge(s1.c_str(), $2);
  }
;

comma_tfpdef_equal_test_opt_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt
  {
    if($4 != NULL){
      node_map["="]++;
      s1 = "="+to_string(node_map["="]);
      s2 = $3;
      emit_dot_edge(s1.c_str(), $3);
    }

    node_map[","]++;

    if($1!=NULL)
    {
      if($4 != NULL){
        s2 = "="+to_string(node_map["="]);
        emit_dot_edge($1, s2.c_str());
      }
      else{
        emit_dot_edge($1, $3);

      }
      s1 = ","+to_string(node_map[","]);
      emit_dot_edge(s1.c_str(), $1);
      strcpy($$, ",");
      string temp = to_string(node_map[","]);
      strcat($$, temp.c_str());
    }
    else{
      s1 = "," + to_string(node_map[","]);
      if($4 != NULL){
        s2 = "="+to_string(node_map["="]);
      }
      else{
        s2 = $3;
      }
      emit_dot_edge(s1.c_str(), s2.c_str());

      strcpy($$, ",");
      string temp = to_string(node_map[","]);
      strcat($$, temp.c_str());
    }
  }
;

colon_test_opt:
  %empty
  {
    $$[0]='\0';
  }
| ':' test
  {
    s1 = ":"+to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), $2);
  }
;

stmt:
  simple_stmt
  {
    strcpy($$, $1);
  }
| compound_stmt
  {
    strcpy($$, $1);
  }
;

semicolon_opt:
  %empty
  {
    $$[0]='\0';
  }
| ';'
  {
    strcpy($$, $1);
  }
;

simple_stmt:
  small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE
  {
    if($2== NULL){
      strcpy($$, $1);
    }
    else{
      if($2 != NULL){
        node_map[";"]++;
        s1 = ";"+to_string(node_map[";"]);
        emit_dot_edge(s1.c_str(), $1);

        strcpy($$, ";");
        string temp = to_string(node_map[";"]);
        strcat($$, temp.c_str());
      }
    }
  }
;

semicolon_small_stmt_list:
  %empty
  {
    $$[0]='\0';
  }
| semicolon_small_stmt_list ';' small_stmt
  {
    if($1 != NULL){
      node_map[";"]++;
      s1 = ";"+to_string(node_map[";"]);
      emit_dot_edge(s1.c_str(), $1);
      
      emit_dot_edge(s1.c_str(), $3);
      
      strcpy($$, ";");
      string temp = to_string(node_map[";"]);
      strcat($$, temp.c_str());
    }
    else{
      strcpy($$, $3);
    }
  }
;

small_stmt: 
  expr_stmt
  {
    strcpy($$, $1);
  }
| flow_stmt
  {
    strcpy($$, $1);
  }
| global_stmt
  {
    strcpy($$, $1);
  }
| assert_stmt
  {
    strcpy($$, $1);
  }
;

expr_stmt:
  testlist_star_expr annassign
  {
    emit_dot_edge($2, $1);
    strcpy($$, $2);
  }
  | testlist_star_expr augassign testlist
  {
    node_map[$2]++;
    s1 = $2 + to_string(node_map[$2]);
    emit_dot_edge(s1.c_str(), $3);
    emit_dot_edge(s1.c_str(), $1);
    strcpy($$, $2);
    string temp = to_string(node_map[$2]);
    strcat($$, temp.c_str());
  }
  | testlist_star_expr expr_stmt_suffix_choices
  {
    if($2 == NULL){
      strcpy($$, $1);
    }
    else{
      node_map["="]++;
      s1 = $2 + to_string(node_map["="]);
      emit_dot_edge(s1.c_str(), $1);
      strcpy($$, "=");
      string temp = to_string(node_map["="]);
      strcat($$, temp.c_str());
    }
  }
;

expr_stmt_suffix_choices:
  equal_testlist_star_expr_list
  {
    strcpy($$, $1);
  }
;

equal_testlist_star_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| equal_testlist_star_expr_list '=' testlist_star_expr
  {
    if($1 != NULL){
      node_map["="]++;
      s1 = "=" + to_string(node_map["="]);
      emit_dot_edge(s1.c_str(), $1);
      emit_dot_edge(s1.c_str(), $3);
      strcpy($$, "=");
      string temp = to_string(node_map["="]);
      strcat($$, temp.c_str());
    }
    else{
      strcpy($$, $3);
    }
  }
;

annassign:
  ':' test equal_test_opt
  {
    node_map[":"]++;

    if($3 != NULL){
      node_map["="]++;
      s1 = "="+to_string(node_map["="]);
      s2 = ":" + to_string(node_map[":"]);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }
    s1 = ":" + to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), $2);
    
    string temp;
    if($3!=NULL){
      strcpy($$, "=");
      temp = to_string(node_map["="]);
    }
    else{
      strcpy($$, ":");
      temp = to_string(node_map[":"]);
    }
    strcat($$, temp.c_str());
  }
;

testlist_star_expr:
  test_or_star_expr comma_test_or_star_expr_list comma_opt
  {
    if($2 != NULL){
      s1 = "," + to_string(node_map[","]); 
      emit_dot_edge(s1.c_str(), $1); 
      strcpy($$, ","); 
      string temp = to_string(node_map[","]); 
      strcat($$, temp.c_str()); 
    }
    else{
      strcpy($$, $1);
    }
  }
;

test_or_star_expr:
  test
  {
    strcpy($$, $1);
  }
| star_expr
  {
    strcpy($$, $1);
  }
;

comma_test_or_star_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_test_or_star_expr_list ',' test_or_star_expr
  {
    if($1 != NULL){
      node_map[","]++;
      s1 = "," + to_string(node_map[","]);
      emit_dot_edge(s1.c_str(), $1);
      emit_dot_edge(s1.c_str(), $3);
      strcpy($$, ",");
      string temp = to_string(node_map[","]);
      strcat($$, temp.c_str());
    }
    else{
      strcpy($$, $3);
    }
  }
;

augassign: 
  PLUSEQUAL
  {
    strcpy($$, $1);
  }
| MINEQUAL
  {
    strcpy($$, $1);
  }
| STAREQUAL
  {
    strcpy($$, $1);
  }
| SLASHEQUAL
  {
    strcpy($$, $1);
  }
| PERCENTEQUAL
  {
    strcpy($$, $1);
  }
| AMPEREQUAL
  {
    strcpy($$, $1);
  }
| VBAREQUAL
  {
    strcpy($$, $1);
  }
| CIRCUMFLEXEQUAL
  {
    strcpy($$, $1);
  }
| LEFTSHIFTEQUAL
  {
    strcpy($$, $1);
  }
| RIGHTSHIFTEQUAL
  {
    strcpy($$, $1);
  }
| DOUBLESTAREQUAL
  {
    strcpy($$, $1);
  }
| DOUBLESLASHEQUAL
  {
    strcpy($$, $1);
  }
;

/* For normal and annotated assignments, additional restrictions enforced by the interpreter*/

flow_stmt:
  break_stmt 
  {
    strcpy($$, $1);
  }
| continue_stmt
{
  strcpy($$, $1);
}
| return_stmt
{
  strcpy($$, $1);
}
;

break_stmt:
  BREAK
  {
    node_map["BREAK"]++;
    string no=to_string(node_map["BREAK"]);
    string s="BREAK"+no;
    //emit_dot_node(s.c_str(), "BREAK");
    strcpy($$, s.c_str());  
  }
;

continue_stmt:
  CONTINUE
  {
    node_map["CONTINUE"]++;
    string no=to_string(node_map["CONTINUE"]);
    string s="CONTINUE"+no;
    //emit_dot_node(s.c_str(), "CONTINUE");
    strcpy($$, s.c_str());
  }
;

return_stmt:
  RETURN testlist_opt
  {
    node_map["RETURN"]++;
    string no=to_string(node_map["RETURN"]);
    string s="RETURN"+no;
    //emit_dot_node(s.c_str(), "RETURN");
    if($2!=NULL){
      emit_dot_edge(s.c_str(), $2);}
    strcpy($$, s.c_str());
  }
;

testlist_opt:
  %empty
  {
    $$[0]='\0';
  }
| testlist
{
  strcpy($$, $1);
}
;

global_stmt:
  GLOBAL NAME comma_name_list
  {
    node_map["GLOBAL"]++;
    string no=to_string(node_map["GLOBAL"]);
    string s="GLOBAL"+no;
    //emit_dot_node(s.c_str(), "GLOBAL");
    char* s2;
    strcpy(s2,"NAME(");
    strcat(s2,$2);
    strcat(s2,")");
    emit_dot_edge(s.c_str(), s2);
    if($3!=NULL){
      emit_dot_edge(s.c_str(), $3);}
    strcpy($$, s.c_str());
  }
;

comma_name_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_name_list ',' NAME
{
  node_map[","]++;
  string no=to_string(node_map[","]);
  string s=","+no;
  //emit_dot_node(s.c_str(), ",");
  char* s2;
  strcpy(s2,"NAME(");
  strcat(s2,$3);
  strcat(s2,")");
  emit_dot_edge(s.c_str(), s2);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

assert_stmt:
  ASSERT test comma_test_opt
  {
    node_map["ASSERT"]++;
    string no=to_string(node_map["ASSERT"]);
    string s="ASSERT"+no;
    //emit_dot_node(s.c_str(), "ASSERT");
    emit_dot_edge(s.c_str(), $2);
    if($3!=NULL){
      emit_dot_edge(s.c_str(), $3);}
    strcpy($$, s.c_str());
  }
;

comma_test_opt:
  %empty
  {
    $$[0]='\0';
  }
| ',' test
{
  node_map[","]++;
  string no=to_string(node_map[","]);
  string s=","+no;
  //emit_dot_node(s.c_str(), ",");
  emit_dot_edge(s.c_str(), $2);
  strcpy($$, s.c_str());
}
;

compound_stmt:
  if_stmt
  {
    strcpy($$, $1);
  }
| while_stmt
{
  strcpy($$, $1);
}
| for_stmt
{
  strcpy($$, $1);
}
| funcdef
{
  strcpy($$, $1);
}
| classdef
{
  strcpy($$, $1);
}
;

if_stmt:
  IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt
{
  node_map["IF"]++;
  string no=to_string(node_map["IF"]);
  string s="IF"+no;
  //emit_dot_node(s.c_str(), "IF");
  if($5!=NULL){
    emit_dot_edge(s.c_str(), $5);
  }
  if($6!=NULL){
    emit_dot_edge(s.c_str(), $6);
  }
  node_map[":"]++;
  string no1=to_string(node_map[":"]);
  string s1=":"+no1;
  //emit_dot_node(s1.c_str(), ":");
  emit_dot_edge(s.c_str(), s1.c_str());
  emit_dot_edge(s1.c_str(), $2);
  emit_dot_edge(s1.c_str(), $4);
  strcpy($$, s.c_str());

}
;

while_stmt:
  WHILE test ':' suite else_colon_suite_opt
  {
    node_map["WHILE"]++;
    string no=to_string(node_map["WHILE"]);
    string s="WHILE"+no;
    //emit_dot_node(s.c_str(), "WHILE");
    emit_dot_edge(s.c_str(), $2);
    if($4!=NULL){
      emit_dot_edge(s.c_str(), $4);
    }
    node_map[":"]++;
    string no1=to_string(node_map[":"]);
    string s1=":"+no1;
    //emit_dot_node(s1.c_str(), ":");
    emit_dot_edge(s.c_str(), s1.c_str());
    strcpy($$, s.c_str());
  }
;
for_stmt:
  FOR exprlist IN testlist ':' suite else_colon_suite_opt
  {
    node_map["FOR"]++;
    string no=to_string(node_map["FOR"]);
    string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    emit_dot_edge(s.c_str(), $2);

    node_map["IN"]++;
    string no1=to_string(node_map["IN"]);
    string s1="IN"+no1;
    //emit_dot_node(s1.c_str(), "IN");
    emit_dot_edge(s.c_str(), s1.c_str());

    node_map[":"]++;
    string no2=to_string(node_map[":"]);
    string s2=":"+no2;
    //emit_dot_node(s2.c_str(), ":");
    emit_dot_edge(s1.c_str(), s2.c_str());
    emit_dot_edge(s2.c_str(), $4);
    emit_dot_edge(s2.c_str(), $6);

    strcpy($$, s.c_str());
  }
;

else_colon_suite_opt:
  %empty
  {
    $$[0]='\0';
  }
| ELSE ':' suite
{
  node_map["ELSE"]++;
  string no=to_string(node_map["ELSE"]);
  string s="ELSE"+no;
  //emit_dot_node(s.c_str(), "ELSE");
  if($3!=NULL){
    emit_dot_edge(s.c_str(), $3);}
  node_map[":"]++;
  string no1=to_string(node_map[":"]);
  string s1=":"+no1;
  //emit_dot_node(s1.c_str(), ":");
  emit_dot_edge(s.c_str(), s1.c_str());
  strcpy($$, s.c_str());
}
;

elif_test_colon_suite_list:
  %empty
  {
    $$[0]='\0';
  }
| elif_test_colon_suite_list ELIF test ':' suite
{
  node_map["ELIF"]++;
  string no=to_string(node_map["ELIF"]);
  string s="ELIF"+no;
  //emit_dot_node(s.c_str(), "ELIF");
  emit_dot_edge(s.c_str(), $3);
  if($5!=NULL){
    emit_dot_edge(s.c_str(), $5);}
  node_map[":"]++;
  string no1=to_string(node_map[":"]);
  string s1=":"+no1;
  //emit_dot_node(s1.c_str(), ":");
  emit_dot_edge(s.c_str(), s1.c_str());
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
   strcpy($$, s.c_str());
}
;

/* NB compile.c makes sure that the default except clause is last*/

suite:
  simple_stmt 
{
  strcpy($$, $1);
}
| NEWLINE INDENT stmt stmt_list DEDENT
{
  if($4==NULL){
    strcpy($$, $3);}
  else
    {
    emit_dot_edge($3, $4);
    strcpy($$, $3);
    }
}
;

/*
NEWLINE_list:
  %empty
| NEWLINE_list NEWLINE
;
*/

stmt_list:
  %empty
  {
    $$[0]='\0';
  }
| stmt_list stmt
{
  if($1==NULL){
    strcpy($$, $2);}
  else
    {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
}
;

test: 
  or_test if_or_test_else_test_opt
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

if_or_test_else_test_opt:
  %empty
  {
    $$[0]='\0';
  }
| IF or_test ELSE test
{
  node_map["IF-ELSE"]++;
  string no=to_string(node_map["IF-ELSE"]);
  string s="IF-ELSE"+no;
  //emit_dot_node(s.c_str(), "IF-ELSE");
  emit_dot_edge(s.c_str(), $2);
  emit_dot_edge(s.c_str(), $4);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

test_nocond:
  or_test
  {
    strcpy($$, $1);
  }
;

or_test:
  and_test or_and_test_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

or_and_test_list:
  %empty
  {
    $$[0]='\0';
  }
| or_and_test_list OR and_test
{
  node_map["OR"]++;
  string no=to_string(node_map["OR"]); 
  string s="OR"+no;
  //emit_dot_node(s.c_str(), "OR");
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

and_test:
  not_test and_not_test_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($2, $1);
    strcpy($$, $2);
    }
  }
;

and_not_test_list:
  %empty
  {
    $$[0]='\0';
  }
| and_not_test_list AND not_test
{
  node_map["AND"]++;  
  string no=to_string(node_map["AND"]); 
  string s="AND"+no;
  //emit_dot_node(s.c_str(), "AND");
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

not_test:
  NOT not_test
  {
    node_map["NOT"]++;
    string no=to_string(node_map["NOT"]);
    string s="NOT"+no;
    //emit_dot_node(s.c_str(), "NOT");
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
| comparison
{
  strcpy($$, $1);
}
;

comparison:
  expr comp_op_expr_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  
  }
;

comp_op_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| comp_op_expr_list comp_op expr
{
  node_map[$2]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

/* <> isn't actually a valid comparison operator in Python. It's here for the
   sake of a __future__ import described in PEP 401 (which really works :-)
*/
comp_op:
  LESSTHAN
  {
    strcpy($$, "<");
  }
| GREATERTHAN
{
    strcpy($$, ">");
}
| DOUBLEEQUAL
{
    strcpy($$, "==");
}
| GREATERTHANEQUAL
{
    strcpy($$, ">=");
}
| LESSTHANEQUAL
{
    strcpy($$, "<=");
}
| NOTEQUAL
{
    strcpy($$, "!=");
}
| IN   /*-----------------MAY NEED TO remove this and the following comp_op--------------------*/
{
    strcpy($$, "IN");
}
| NOT IN
{
    strcpy($$, "NOT IN");
}
| IS
{
    strcpy($$, "IS");
}
| IS NOT
{
    strcpy($$, "IS NOT");
}
;

star_expr:
  '*' expr
  {
    node_map["*"]++;
    string no=to_string(node_map["*"]);
    string s="*"+no;
    //emit_dot_node(s.c_str(), "*");
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
;

expr:
  xor_expr or_xor_expr_list
  {
    if($2==NULL)
      strcpy($$, $1);
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

or_xor_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| or_xor_expr_list '|' xor_expr
{
  node_map["|"]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  //emit_dot_node(s.c_str(), "|");
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

xor_expr:
  and_expr xor_and_expr_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

xor_and_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| xor_and_expr_list '^' and_expr
{
  node_map["^"]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  //emit_dot_node(s.c_str(), "^");
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());
}
;

and_expr:
  shift_expr and_shift_expr_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

and_shift_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| and_shift_expr_list '&' shift_expr
{
  node_map["&"]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  //emit_dot_node(s.c_str(), "&");
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
    strcpy($$, s.c_str());

}
;

shift_expr:
  arith_expr shift_arith_expr_list 
{
  if($2==NULL){
     strcpy($$, $1);}
  else
    {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
}
;

ltshift_or_rtshift:
  LEFTSHIFT
  {
    strcpy($$, "<<");;
  }
| RIGHTSHIFT
{
    strcpy($$, ">>");
  }
;

shift_arith_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| shift_arith_expr_list ltshift_or_rtshift arith_expr
{
  node_map[$2]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  emit_dot_edge($2, $3);
  if($1!=NULL){
    emit_dot_edge($1, s.c_str());
  }
    strcpy($$, s.c_str());
}
;

arith_expr:
  term plus_or_minus_term_list
  {
    if($2==NULL){
      strcpy($$, $1);
    }
    else
      {
    emit_dot_edge($2, $1);
    strcpy($$, $2);
    }
  }
;

plus_or_minus:
  '+'
  {
    strcpy($$, "+");
  }
| '-'
  {
    strcpy($$, "-");
  } 
;

plus_or_minus_term_list:
  %empty
  {
    $$[0]='\0';
  }
| plus_or_minus_term_list plus_or_minus term
{
  node_map[$2]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  //emit_dot_node(s.c_str(), $2);
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge($1, s.c_str());}
    strcpy($$, s.c_str());
}
;

term:
  factor star_or_slash_or_percent_or_doubleslash_factor_list
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

star_or_slash_or_percent_or_doubleslash:
  '*'
  {
    strcpy($$, "*");
  }
| '/'
  {
    strcpy($$, "/");
  }
| '%'
  {
    strcpy($$, "%");
  }
| DOUBLESLASH
  {
    strcpy($$, "//");
  }
;

star_or_slash_or_percent_or_doubleslash_factor_list:
  %empty
  {
    $$[0]='\0';
  }
| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor
{
  node_map[$2]++;
  string no=to_string(node_map[$2]);
  string s=$2+no;
  //emit_dot_node(s.c_str(), $2);
  emit_dot_edge(s.c_str(), $3);
  if($1!=NULL){
    emit_dot_edge($1, s.c_str());}
    strcpy($$, s.c_str());
}
;

factor:
  plus_or_minus_or_tilde factor
  {
    node_map[$1]++;
    string no=to_string(node_map[$1]);
    string s=$1+no;
    //emit_dot_node(s.c_str(), $1);
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
| power
{
  strcpy($$, $1);
}
; 

plus_or_minus_or_tilde:
  '+'
  {
    strcpy($$, "+");
  }
| '-'
  {
    strcpy($$, "-");
  }
| '~'
  {
    strcpy($$, "~");
  }
;

power:
  atom_expr doublestar_factor_opt
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

doublestar_factor_opt:
  %empty
  {
    $$[0]='\0';
  }
| DOUBLESTAR factor
{
  node_map["**"]++;
  string no=to_string(node_map["**"]);
  string s="**"+no;
  //emit_dot_node(s.c_str(), "**");
  emit_dot_edge(s.c_str(), $2);
  strcpy($$, s.c_str());
}
;

atom_expr:
  atom trailer_list
  {
    strcpy($$, $1);
  }
;

trailer_list:
  %empty
  {
    $$[0]='\0';
  }
| trailer_list trailer
{
  if($1==NULL){
    strcpy($$, $2);}
  else
    {
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
}
;

atom:
  '(' testlist_comp_opt ')'
  {
    node_map["()"]++;
    string no=to_string(node_map["()"]);
    string s="()"+no;
    //emit_dot_node(s.c_str(), "()");
    if($2!=NULL){
      emit_dot_edge(s.c_str(), $2);}
    strcpy($$, s.c_str());
  }
| '[' testlist_comp_opt ']'
{
  node_map["[]"]++;
  string no=to_string(node_map["[]"]);
  string s="[]"+no;
  //emit_dot_node(s.c_str(), "[]");
  if($2!=NULL){
    emit_dot_edge(s.c_str(), $2);}
  strcpy($$, s.c_str());
}
| NAME
{
            // 
  strcpy($$, "NAME(");
  strcat($$, $1); 
  strcat($$, ")");
  node_map[$$]++;
  string temp = to_string(node_map[$$]);
  strcat($$, temp.c_str());
}
| NUMBER
{
  strcpy($$, "NUMBER(");
  strcat($$, $1);
  strcat($$, ")");
  node_map[$$]++;
  string temp = to_string(node_map[$$]);
  strcat($$, temp.c_str());
}
| STRING string_list
{
  if($2==NULL){
    strcpy($$,$1);}
  else
    {
    strcpy($$, "STRING("); 
    strcat($$, $1);
    strcat($$, ")");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
    emit_dot_edge($$, $2);
    }

}
| NONE 
{
  strcpy($$, "NONE");
  node_map[$$]++;
  string temp = to_string(node_map[$$]);
  strcat($$, temp.c_str());
}
| TRUE
{
  strcpy($$, "TRUE");
  node_map[$$]++;
  string temp = to_string(node_map[$$]);
  strcat($$, temp.c_str());
}
| FALSE
{
  strcpy($$, "FALSE");
  node_map[$$]++;
  string temp = to_string(node_map[$$]);
  strcat($$, temp.c_str());
}
;

string_list:
  %empty
  {
    $$[0]='\0';
  }
| string_list STRING
{
  if($1==NULL){
    strcpy($$,$2);}
  else
    {
    strcpy($$, "STRING("); 
    strcat($$, $2);
    strcat($$, ")");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
    emit_dot_edge($$, $2);
    strcpy($$, $1);
    }

}
;

testlist_comp_opt:
  %empty
  {
    $$[0]='\0';
  }
| testlist_comp
{
  strcpy($$,$1);
}
;

testlist_comp:
  test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt
  {
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
      emit_dot_edge($1, $2);
      strcpy($$, $1);
      }
  }
;

comp_for_OR_comma_test_or_star_expr_list_comma_opt:
  comp_for
  {
    strcpy($$, $1);
  }
| comma_test_or_star_expr_list comma_opt
{
  if($2==NULL){
    strcpy($$, $1);
  }
  else{
    node_map[","]++;
    string no=to_string(node_map[","]);
    string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    emit_dot_edge(s.c_str(), $1);
    strcpy($$, s.c_str());
  }

}
;

trailer:
  '(' arglist_opt ')'
  {
    node_map["()"]++;
    string no=to_string(node_map["()"]);
    string s="()"+no;
    //emit_dot_node(s.c_str(), "()");
    if($2!=NULL){
      emit_dot_edge(s.c_str(), $2);}
    strcpy($$, s.c_str());
  }
| '[' subscriptlist ']'
{
  node_map["[]"]++;
  string no=to_string(node_map["[]"]);
  string s="[]"+no;
  //emit_dot_node(s.c_str(), "[]");
  if($2!=NULL){
    emit_dot_edge(s.c_str(), $2);}
  strcpy($$, s.c_str());
}
| '.' NAME
{
  node_map["."]++;
  string no=to_string(node_map["."]);
  string s="."+no;
  //emit_dot_node(s.c_str(), ".");
  strcpy($$, "NAME(");
  strcat($$, $1); 
  strcat($$, ")");
  node_map[$$]++;
  emit_dot_edge(s.c_str(), $$);
  strcpy($$, s.c_str());
}
;

arglist_opt:
  %empty
  {
    $$[0]='\0';
  }
| arglist
{
  strcpy($$,$1);
}
;

subscriptlist: 
  subscript comma_subscript_list comma_opt
  {
    if($2==NULL && $3==NULL){
      strcpy($$, $1);}
    else if($3==NULL)
      {
        emit_dot_edge($2,$1);
        strcpy($$, $2);
      }
      else {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        //emit_dot_node(s.c_str(), ",");
        emit_dot_edge(s.c_str(), $1);
        if($2!=NULL){
          emit_dot_edge(s.c_str(), $2);}
        strcpy($$, s.c_str());
      }
  }
;

comma_subscript_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_subscript_list ',' subscript
{
  node_map[","]++;
  string no=to_string(node_map[","]);
  string s=","+no;
  //emit_dot_node(s.c_str(), ",");
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
  emit_dot_edge(s.c_str(), $3);
  strcpy($$, s.c_str());
}
;

subscript:
  test
  {
    strcpy($$,$1);
  }
| test_opt ':' test_opt
{
  node_map[":"]++;
  string no=to_string(node_map[":"]);
  string s=":"+no;
  //emit_dot_node(s.c_str(), ":");
  if($1!=NULL){
    emit_dot_edge(s.c_str(), $1);}
  if($3!=NULL){
    emit_dot_edge(s.c_str(), $3);}
    strcpy($$, s.c_str());
}
;

test_opt: 
  %empty
  {
    $$[0]='\0';
  }
| test
{
  strcpy($$,$1);
}
;

exprlist:
  expr_or_star_expr comma_expr_or_star_expr_list comma_opt
  {
    if($2==NULL && $3==NULL){
      strcpy($$, $1);}
    else 
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        //emit_dot_node(s.c_str(), ",");
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
      }
  }
;

comma_expr_or_star_expr_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_expr_or_star_expr_list ',' expr_or_star_expr
{
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
      //emit_dot_node(s.c_str(), ",");
      if($1!=NULL){
        emit_dot_edge(s.c_str(), $1);}
      emit_dot_edge(s.c_str(), $2);
      strcpy($$, s.c_str());
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
    if($2==NULL && $3==NULL){
      strcpy($$, $1);}
    else if($3==NULL)
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        //emit_dot_node(s.c_str(), ",");
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
      }
      else {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        //emit_dot_node(s.c_str(), ",");
        emit_dot_edge(s.c_str(), $1);
        if($2!=NULL){
          emit_dot_edge(s.c_str(), $2);}
        strcpy($$, s.c_str());
      }
  }
;

comma_test_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_test_list ',' test
{
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if($1!=NULL){
      emit_dot_edge(s.c_str(), $1);}
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
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
    emit_dot_edge(s1.c_str(), s2.c_str());

    node_map["()"]++;

    s1 = $$+to_string(node_map[$$]);
    s2 = "()"+to_string(node_map["()"]);
    emit_dot_edge(s1.c_str(), s2.c_str());
    
    if($3 != NULL){
      s1 = s2;
      s2 = $3;
      emit_dot_edge(s1.c_str(), s2.c_str());
    }
    
    node_map[":"]++;

    s1 = $4+to_string(node_map[":"]);
    s2 = "CLASS"+to_string(node_map["CLASS"]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    s2 = $5;
    emit_dot_edge(s1.c_str(), s2.c_str());

    strcpy($$, $4);
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
  }
;

parenthesis_arglist_opt_opt:
  %empty
  {
    $$[0]='\0';
  
  }
| '(' arglist_opt ')'
{
  node_map["()"]++;
  string no=to_string(node_map["()"]);
  string s="()"+no;
  //emit_dot_node(s.c_str(), "()");
  emit_dot_edge(s.c_str(), $2);
  strcpy($$, s.c_str());
}
;

arglist:
 argument comma_argument_list  comma_opt
{
    if($2==NULL && $3==NULL){
      strcpy($$, $1);}
    else if($3==NULL)
      {
        node_map[","]++;
        string no=to_string(node_map[","]);
        string s=","+no;
        //emit_dot_node(s.c_str(), ",");
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
      }
      else {
        strcpy($$, $1);
      }
  }
;

comma_argument_list:
  %empty
  {
    $$[0]='\0';
  }
| comma_argument_list ',' argument
{
  if($3==NULL){
    strcpy($$, $1);}
  else
    {
      node_map[","]++;
      string no=to_string(node_map[","]);
      string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    emit_dot_edge(s.c_str(), $1);
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
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
    if($2==NULL){
      strcpy($$, $1);}
    else
      {
    emit_dot_edge("argument", "Argument with Comprehension");
    emit_dot_edge("argument", $1);
    emit_dot_edge("argument", $2);
    }
  }
| test '=' test
  {
    node_map["="]++;
    string no=to_string(node_map["="]);
    string s=$2+no;
    //emit_dot_node(s.c_str(), "=");
    emit_dot_edge(s.c_str(), $1);
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
  }
| '*' test
  {
    node_map["*"]++;
    string no=to_string(node_map["*"]);
    string s="*"+no;
    //emit_dot_node(s.c_str(), "*");
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
;

comp_for_opt:
  %empty
  {
    $$[0]='\0';
  }
| comp_for
{
  strcpy($$,$1);
}
;

comp_iter:
  comp_for
  {
    strcpy($$,$1);
  }
| comp_if
{
  strcpy($$,$1);
}
;

comp_for:
  FOR exprlist IN or_test comp_iter_opt
  {
    node_map["FOR"]++;
    string no=to_string(node_map["FOR"]);
    string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    emit_dot_edge(s.c_str(), $2);
    node_map["IN"]++;
    string no1=to_string(node_map["IN"]);
    string s1="IN"+no1;
    //emit_dot_node(s1.c_str(), "IN");
    emit_dot_edge(s.c_str(), s1.c_str());
    if($5!=NULL){
      emit_dot_edge(s.c_str(), $5);}
    emit_dot_edge(s1.c_str(), $4);
    strcpy($$, s.c_str());
  }
;

comp_if:
  IF test_nocond comp_iter_opt
  {
    node_map["IF"]++;
    string no=to_string(node_map["IF"]);
    string s="IF"+no;
    //emit_dot_node(s.c_str(), "IF");
    emit_dot_edge(s.c_str(), $2);
    if($3!=NULL){
      emit_dot_edge(s.c_str(), $3);}
    strcpy($$, s.c_str());
  }
;

comp_iter_opt:
  %empty
  {
    $$[0]='\0';
  }
| comp_iter
{
  strcpy($$,$1);
}
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
