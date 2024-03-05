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
    std::cout << "newline_or_stmt_list" << std::endl;
  }
;

newline_or_stmt:
  NEWLINE
  {
    std::cout << "NEWLINE" << std::endl;
    strcpy($$, $1);
  }
| stmt
  {
    std::cout << "| stmt" << std::endl;
    strcpy($$, $1);
  }
;

newline_or_stmt_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| newline_or_stmt_list newline_or_stmt
  {
    std::cout << "| newline_or_stmt_list newline_or_stmt" << std::endl;
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
    std::cout << "DEF NAME parameters arrow_test_opt ':' suite" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ARROW test
  {
    std::cout << "| ARROW test" << std::endl;
    s1 = "ARROW"+to_string(node_map["ARROW"]);
    s2 = $2;
    emit_dot_edge(s1.c_str(), $2);
  }
;

parameters:
  '(' typedargslist_opt ')'
  {
    std::cout << "'(' typedargslist_opt ')'" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| typedargslist
  {
    std::cout << "| typedargslist" << std::endl;
    strcpy($$, $1);
  }
;

typedargslist:
  tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list
  {
    std::cout << "tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list" << std::endl;
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
    std::cout << "NAME colon_test_opt" << std::endl;
    strcpy($$, "NAME(");
    strcat($$, $1);
    strcat($$, ")");
    node_map[$1]++;
    s2 = $$+to_string(node_map[$$]);

    if($2 != NULL){      
      emit_dot_edge(s2.c_str(), $2);
    }
    strcpy($$, s2.c_str());
  }
;

comma_opt:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ','
  {
    std::cout << "| ','" << std::endl;
    strcpy($$, $1);
  }
;

equal_test_opt:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| '=' test
  {
    std::cout << "| '=' test" << std::endl;
    node_map["="]++;
    s1 = "="+to_string(node_map["="]);
    emit_dot_edge(s1.c_str(), $2);
  }
;

comma_tfpdef_equal_test_opt_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt
  {
    std::cout << "| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ':' test
  {
    std::cout << "| ':' test" << std::endl;
    s1 = ":"+to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), $2);
  }
;

stmt:
  simple_stmt
  {
    std::cout << "simple_stmt" << std::endl;
    strcpy($$, $1);
  }
| compound_stmt
  {
    std::cout << "| compound_stmt" << std::endl;
    strcpy($$, $1);
  }
;

semicolon_opt:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ';'
  {
    std::cout << "| ';'" << std::endl;
    strcpy($$, $1);
  }
;

simple_stmt:
  small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE
  {
    std::cout << "small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
        emit_dot_edge($2, $1);
        strcpy($$, $2);
    }
  }
;

semicolon_small_stmt_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| semicolon_small_stmt_list ';' small_stmt
  {
    std::cout << "| semicolon_small_stmt_list ';' small_stmt" << std::endl;
    if($1[0] != '\0'){
      node_map[";"]++;
      s1 = ";"+to_string(node_map[";"]);
      emit_dot_edge(s1.c_str(), $1);
      emit_dot_edge(s1.c_str(), $3);
      strcpy($$, s1.c_str());
    }
    else{
      strcpy($$, $3);
    }
  }
;

small_stmt: 
  expr_stmt
  {
    std::cout << "expr_stmt" << std::endl;
    strcpy($$, $1);
  }
| flow_stmt
  {
    std::cout << "| flow_stmt" << std::endl;
    strcpy($$, $1);
  }
| global_stmt
  {
    std::cout << "| global_stmt" << std::endl;
    strcpy($$, $1);
  }
| assert_stmt
  {
    std::cout << "| assert_stmt" << std::endl;
    strcpy($$, $1);
  }
;

expr_stmt:
  testlist_star_expr annassign
  {
    std::cout << "testlist_star_expr annassign" << std::endl;
    emit_dot_edge($2, $1);
    strcpy($$, $2);
  }
  | testlist_star_expr augassign testlist
  {
    std::cout << "| testlist_star_expr augassign testlist" << std::endl;
    node_map[$2]++;
    s1 = $2 + to_string(node_map[$2]);
    emit_dot_edge(s1.c_str(), $3);
    emit_dot_edge(s1.c_str(), $1);
    strcpy($$, s1.c_str());
  }
  | testlist_star_expr expr_stmt_suffix_choices
  {
    std::cout << "| testlist_star_expr expr_stmt_suffix_choices" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      s1 = $2 + to_string(node_map["="]);
      emit_dot_edge(s1.c_str(), $1);
      strcpy($$, s1.c_str());
    }
  }
;

expr_stmt_suffix_choices:
  equal_testlist_star_expr_list
  {
    std::cout << "equal_testlist_star_expr_list" << std::endl;
    strcpy($$, $1);
  }
;

equal_testlist_star_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| equal_testlist_star_expr_list '=' testlist_star_expr
  {
    std::cout << "| equal_testlist_star_expr_list '=' testlist_star_expr" << std::endl;
    node_map["="]++;
    s1 = "=" + to_string(node_map["="]);
    if($1[0] != '\0'){
      emit_dot_edge(s1.c_str(), $1);
    }
    emit_dot_edge(s1.c_str(), $3);
    strcpy($$, s1.c_str());
  }
;

annassign:
  ':' test equal_test_opt
  {
    std::cout << "':' test equal_test_opt" << std::endl;
    node_map[":"]++;
    s1 = ":" + to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), $2);

    s2 = ":" + to_string(node_map[":"]);
    
    if($3[0] != '\0'){
      s1 = "="+to_string(node_map["="]);
      emit_dot_edge(s1.c_str(), s2.c_str());
      strcpy($$, s1.c_str());
    }
    else{
      strcpy($$, s2.c_str());
    }
  }
;

testlist_star_expr:
  test_or_star_expr comma_test_or_star_expr_list comma_opt
  {
    std::cout << "test_or_star_expr comma_test_or_star_expr_list comma_opt" << std::endl;
    if($2[0] != '\0'){
      s1 = "," + to_string(node_map[","]); 
      emit_dot_edge(s1.c_str(), $1); 
      strcpy($$, s1.c_str()); 
    }
    else{
      strcpy($$, $1);
    }
  }
;

test_or_star_expr:
  test
  {
    std::cout << "test" << std::endl;
    strcpy($$, $1);
  }
| star_expr
  {
    std::cout << "| star_expr" << std::endl;
    strcpy($$, $1);
  }
;

comma_test_or_star_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_test_or_star_expr_list ',' test_or_star_expr
  {
    std::cout << "| comma_test_or_star_expr_list ',' test_or_star_expr" << std::endl;
    node_map[","]++;
    s1 = "," + to_string(node_map[","]);
    emit_dot_edge(s1.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s1.c_str(), $1);
      strcpy($$, s1.c_str());
    }
    else{
      strcpy($$, $3);
    }
  }
;

augassign: 
  PLUSEQUAL
  {
    std::cout << "PLUSEQUAL" << std::endl;
    strcpy($$, $1);
  }
| MINEQUAL
  {
    std::cout << "| MINEQUAL" << std::endl;
    strcpy($$, $1);
  }
| STAREQUAL
  {
    std::cout << "| STAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| SLASHEQUAL
  {
    std::cout << "| SLASHEQUAL" << std::endl;
    strcpy($$, $1);
  }
| PERCENTEQUAL
  {
    std::cout << "| PERCENTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| AMPEREQUAL
  {
    std::cout << "| AMPEREQUAL" << std::endl;
    strcpy($$, $1);
  }
| VBAREQUAL
  {
    std::cout << "| VBAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| CIRCUMFLEXEQUAL
  {
    std::cout << "| CIRCUMFLEXEQUAL" << std::endl;
    strcpy($$, $1);
  }
| LEFTSHIFTEQUAL
  {
    std::cout << "| LEFTSHIFTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| RIGHTSHIFTEQUAL
  {
    std::cout << "| RIGHTSHIFTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| DOUBLESTAREQUAL
  {
    std::cout << "| DOUBLESTAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| DOUBLESLASHEQUAL
  {
    std::cout << "| DOUBLESLASHEQUAL" << std::endl;
    strcpy($$, $1);
  }
;

/* For normal and annotated assignments, additional restrictions enforced by the interpreter*/

flow_stmt:
  break_stmt 
  {
    std::cout << "break_stmt " << std::endl;
    strcpy($$, $1);
  }
| continue_stmt
  {
    std::cout << "| continue_stmt" << std::endl;
    strcpy($$, $1);
  }
| return_stmt
  {
    std::cout << "| return_stmt" << std::endl;
    strcpy($$, $1);
  }
;

break_stmt:
  BREAK
  {
    std::cout << "BREAK" << std::endl;
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
    std::cout << "CONTINUE" << std::endl;
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
    std::cout << "RETURN testlist_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| testlist
  {
    std::cout << "| testlist" << std::endl;
    strcpy($$, $1);
  }
;

global_stmt:
  GLOBAL NAME comma_name_list
  {
    std::cout << "GLOBAL NAME comma_name_list" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_name_list ',' NAME
  {
    std::cout << "| comma_name_list ',' NAME" << std::endl;
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
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s.c_str());
  }
;

assert_stmt:
  ASSERT test comma_test_opt
  {
    std::cout << "ASSERT test comma_test_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ',' test
  {
    std::cout << "| ',' test" << std::endl;
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
    std::cout << "if_stmt" << std::endl;
    strcpy($$, $1);
  }
| while_stmt
  {
    std::cout << "| while_stmt" << std::endl;
    strcpy($$, $1);
  }
| for_stmt
  {
    std::cout << "| for_stmt" << std::endl;
    strcpy($$, $1);
  }
| funcdef
  {
    std::cout << "| funcdef" << std::endl;
    strcpy($$, $1);
  }
| classdef
  {
    std::cout << "| classdef" << std::endl;
    strcpy($$, $1);
  }
;

if_stmt:
  IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt
  {
    std::cout << "IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt" << std::endl;
    node_map["IF"]++;
    string no=to_string(node_map["IF"]);
    string s="IF"+no;
    emit_dot_edge(s.c_str(), $2);
    node_map[":"]++;
    string no1=to_string(node_map[":"]);
    string s1=":"+no1;
    emit_dot_edge(s1.c_str(), s.c_str());
    emit_dot_edge(s1.c_str(), $4);
    strcpy($$, $3);
    string temp = to_string(node_map[":"]);
    strcat($$, temp.c_str());
    if(($5[0] == '\0') && ($6[0] == '\0')){

    }
    else if($5[0] == '\0'){
      emit_dot_edge($$, $6);
    }
    else if($6[0] == '\0'){
      emit_dot_edge($$, $5);
    }
    else{
      emit_dot_edge($$, $5);
      emit_dot_edge($5, $6);
    }
  }
;

while_stmt:
  WHILE test ':' suite else_colon_suite_opt
  {
    std::cout << "WHILE test ':' suite else_colon_suite_opt" << std::endl;
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
    std::cout << "FOR exprlist IN testlist ':' suite else_colon_suite_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| ELSE ':' suite
  {
    std::cout << "| ELSE ':' suite" << std::endl;
    node_map["ELSE"]++;
    string no=to_string(node_map["ELSE"]);
    string s="ELSE"+no;
    node_map[":"]++;
    string no1=to_string(node_map[":"]);
    string s1=":"+no1;
    emit_dot_edge(s1.c_str(), s.c_str());
    emit_dot_edge(s1.c_str(), $3);
    strcpy($$, s1.c_str());
  }
;

elif_test_colon_suite_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| elif_test_colon_suite_list ELIF test ':' suite
  {
    std::cout << "| elif_test_colon_suite_list ELIF test ':' suite" << std::endl;
    node_map["ELIF"]++;
    string no=to_string(node_map["ELIF"]);
    string s="ELIF"+no;
    emit_dot_edge(s.c_str(), $3);
    node_map[":"]++;
    string no1=to_string(node_map[":"]);
    string s1=":"+no1;
    emit_dot_edge(s1.c_str(), s.c_str());
    emit_dot_edge(s1.c_str(), $5);
    strcpy($$, s1.c_str());
    if($1[0] != '\0'){
      emit_dot_edge($$, s1.c_str());
    }
  }
;

/* NB compile.c makes sure that the default except clause is last*/

suite:
  simple_stmt 
  {
    std::cout << "simple_stmt" << std::endl;
    strcpy($$, $1);
  }
| NEWLINE INDENT stmt stmt_list DEDENT
  {
    std::cout << "| NEWLINE INDENT stmt stmt_list DEDENT" << std::endl;
    if($4==NULL){
      strcpy($$, $3);
    }
    else
    {
      emit_dot_edge($3, $4);
      strcpy($$, $3);
    }
  }
;

stmt_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| stmt_list stmt
  {
    std::cout << "| stmt_list stmt" << std::endl;
    if($1[0] == '\0'){
      strcpy($$, $2);
    }
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
    std::cout << "or_test if_or_test_else_test_opt" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else
      {
        strcpy($$, $1);
        strcat($$, $2);
    }
  }
;

if_or_test_else_test_opt:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| IF or_test ELSE test
  {
    std::cout << "| IF or_test ELSE test" << std::endl;
    strcpy($$, $1);
    strcat($$, $2);
    strcat($$, $3);
    strcat($$, $4);
  }
;

test_nocond:
  or_test
  {
    std::cout << "or_test" << std::endl;
    strcpy($$, $1);
  }
;

or_test:
  and_test or_and_test_list
  {
    std::cout << "and_test or_and_test_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else
      {
        string no=to_string(node_map["OR"]);
        string s="OR"+no;
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
    }
  }
;

or_and_test_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| or_and_test_list OR and_test
  {
    std::cout << "| or_and_test_list OR and_test" << std::endl;
    node_map["OR"]++;
    string no=to_string(node_map["OR"]); 
    string s="OR"+no;
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s.c_str());
  }
;

and_test:
  not_test and_not_test_list
  {
    std::cout << "not_test and_not_test_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);}
    else
      {
        string no=to_string(node_map["AND"]);
        string s="AND"+no;
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
    }
  }
;

and_not_test_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| and_not_test_list AND not_test
  {
    std::cout << "| and_not_test_list AND not_test" << std::endl;
    node_map["AND"]++;  
    string no=to_string(node_map["AND"]); 
    string s="AND"+no;
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
      strcpy($$, s.c_str());
  }
;

not_test:
  NOT not_test
  {
    std::cout << "NOT not_test" << std::endl;
    node_map["NOT"]++;
    string no=to_string(node_map["NOT"]);
    string s="NOT"+no;
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
| comparison
  {
    std::cout << "| comparison" << std::endl;
    strcpy($$, $1);
  }
;

comparison:
  expr comp_op_expr_list
  {
    std::cout << "expr comp_op_expr_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else
    {
      strcpy($$, "COMP_OP(");
      int len = strlen($2), i = len - 1;
      while((i >= 0) && (is_digit($2[i]))){
        $2[i] = '\0';
        i--;
      }
      strcat($$, $2);
      strcat($$, ")");
      node_map[$$]++;
      string no=to_string(node_map[$$]);
      string s=$$+no;
      emit_dot_edge(s.c_str(), $1);
      strcat($$, no.c_str());
    }
  }
;

comp_op_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_op_expr_list comp_op expr
  {
    std::cout << "| comp_op_expr_list comp_op expr" << std::endl;
    node_map[$2]++;
    string s3 = "COMP_OP(";
    string no=to_string(node_map[$2]);
    string s2 = $2+no;
    string s=s3 + $2 + ")" + no;
    
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s2.c_str());
  }
;

/* <> isn't actually a valid comparison operator in Python. It's here for the
   sake of a __future__ import described in PEP 401 (which really works :-)
*/
comp_op:
  LESSTHAN
  {
    std::cout << "LESSTHAN" << std::endl;
    strcpy($$, "<");
  }
| GREATERTHAN
  {
    std::cout << "| GREATERTHAN" << std::endl;
    strcpy($$, ">");
  }
| DOUBLEEQUAL
  {
    std::cout << "| DOUBLEEQUAL" << std::endl;
    strcpy($$, "==");
  }
| GREATERTHANEQUAL
  {
    std::cout << "| GREATERTHANEQUAL" << std::endl;
    strcpy($$, ">=");
  }
| LESSTHANEQUAL
  {
    std::cout << "| LESSTHANEQUAL" << std::endl;
    strcpy($$, "<=");
  }
| NOTEQUAL
  {
    std::cout << "| NOTEQUAL" << std::endl;
    strcpy($$, "!=");
  }
| IN   /*-----------------MAY NEED TO remove this and the following comp_op--------------------*/
  {
    std::cout << "| IN" << std::endl;
    strcpy($$, "IN");
  }
| NOT IN
  {
    std::cout << "| NOT IN" << std::endl;
    strcpy($$, "NOT IN");
  }
| IS
  {
    std::cout << "| IS" << std::endl;
    strcpy($$, "IS");
  }
| IS NOT
  {
    std::cout << "| IS NOT" << std::endl;
    strcpy($$, "IS NOT");
  }
;

star_expr:
  '*' expr
  {
    std::cout << "'*' expr" << std::endl;
    node_map["*"]++;
    string no=to_string(node_map["*"]);
    string s="*"+no;
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
;

expr:
  xor_expr or_xor_expr_list
  {
    std::cout << "xor_expr or_xor_expr_list" << std::endl;
    if($2[0] == '\0')
      strcpy($$, $1);
    else
      {
        string no=to_string(node_map["|"]);
        string s="|"+no;
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
    }
  }
;


or_xor_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| or_xor_expr_list '|' xor_expr
  {
    std::cout << "| or_xor_expr_list '|' xor_expr" << std::endl;
    node_map["|"]++;
    string no=to_string(node_map[$2]);
    string s=$2+no;
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s.c_str());
  }
;

xor_expr:
  and_expr xor_and_expr_list
  {
    std::cout << "and_expr xor_and_expr_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else
      {
        string no=to_string(node_map["^"]);
        string s="^"+no;
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
    }
  }
;

xor_and_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| xor_and_expr_list '^' and_expr
  {
    std::cout << "| xor_and_expr_list '^' and_expr" << std::endl;
    node_map["^"]++;
    string no=to_string(node_map[$2]);
    string s=$2+no;
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s.c_str());
  }
;

and_expr:
  shift_expr and_shift_expr_list
  {
    std::cout << "shift_expr and_shift_expr_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else
      {
        string no=to_string(node_map["&"]);
        string s="&"+no;
        emit_dot_edge(s.c_str(), $1);
        strcpy($$, s.c_str());
    }
  }
;

and_shift_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| and_shift_expr_list '&' shift_expr
  {
    std::cout << "| and_shift_expr_list '&' shift_expr" << std::endl;
    node_map["&"]++;
    string no=to_string(node_map[$2]);
    string s=$2+no;
    emit_dot_edge(s.c_str(), $3);
    if($1[0] != '\0'){
      emit_dot_edge(s.c_str(), $1);
    }
      strcpy($$, s.c_str());
  }
;

shift_expr:
  arith_expr shift_arith_expr_list 
  {
    std::cout << "arith_expr shift_arith_expr_list" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);}
    else
      {
          emit_dot_edge($2, $1);
          strcpy($$, $2);
      }
  }
;

ltshift_or_rtshift:
  LEFTSHIFT
  {
    std::cout << "LEFTSHIFT" << std::endl;
    strcpy($$, "<<");;
  }
| RIGHTSHIFT
  {
    std::cout << "| RIGHTSHIFT" << std::endl;
    strcpy($$, ">>");
  }
;

shift_arith_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| shift_arith_expr_list ltshift_or_rtshift arith_expr
  {
    std::cout << "| shift_arith_expr_list ltshift_or_rtshift arith_expr" << std::endl;
    node_map[$2]++;
    string no=to_string(node_map[$2]);
    string s=$2+no;
    emit_dot_edge($2, $3);
    if($1[0] != '\0'){
      emit_dot_edge($2, $1);
    }
    strcpy($$, s.c_str());
  }
;

arith_expr:
  term plus_or_minus_term_list
  {
    std::cout << "term plus_or_minus_term_list" << std::endl;
    if($2[0] == '\0'){
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
    std::cout << "'+'" << std::endl;
    strcpy($$, "+");
  }
| '-'
  {
    std::cout << "'-'" << std::endl;
    strcpy($$, "-");
  } 
;

plus_or_minus_term_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| plus_or_minus_term_list plus_or_minus term
  {
    std::cout << "| plus_or_minus_term_list plus_or_minus term" << std::endl;
    node_map[$2]++;
    string no=to_string(node_map[$2]);
    string s=$2+no;
    //emit_dot_node(s.c_str(), $2);
    emit_dot_edge(s.c_str(), $3);
    if($1!=NULL){
      emit_dot_edge($1, s.c_str());
    }
    strcpy($$, s.c_str());
  }
;

term:
  factor star_or_slash_or_percent_or_doubleslash_factor_list
  {
    std::cout << "factor star_or_slash_or_percent_or_doubleslash_factor_list" << std::endl;
    if($2==NULL){
      strcpy($$, $1);
    }
    else{
    emit_dot_edge($1, $2);
    strcpy($$, $1);
    }
  }
;

star_or_slash_or_percent_or_doubleslash:
  '*'
  {
    std::cout << "'*'" << std::endl;
    strcpy($$, "*");
  }
| '/'
  {
    std::cout << "| '/'" << std::endl;
    strcpy($$, "/");
  }
| '%'
  {
    std::cout << "| '%'" << std::endl;
    strcpy($$, "%");
  }
| DOUBLESLASH
  {
    std::cout << "| DOUBLESLASH" << std::endl;
    strcpy($$, "//");
  }
;

star_or_slash_or_percent_or_doubleslash_factor_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor
  {
    std::cout << "| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor" << std::endl;
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
    std::cout << "plus_or_minus_or_tilde factor" << std::endl;
    node_map[$1]++;
    string no=to_string(node_map[$1]);
    string s=$1+no;
    //emit_dot_node(s.c_str(), $1);
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
| power
  {
    std::cout << "| power" << std::endl;
    strcpy($$, $1);
  }
; 

plus_or_minus_or_tilde:
  '+'
  {
    std::cout << "'+'" << std::endl;
    strcpy($$, "+");
  }
| '-'
  {
    std::cout << "| '-'" << std::endl;
    strcpy($$, "-");
  }
| '~'
  {
    std::cout << "| '~'" << std::endl;
    strcpy($$, "~");
  }
;

power:
  atom_expr doublestar_factor_opt
  {
    std::cout << "atom_expr doublestar_factor_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| DOUBLESTAR factor
  {
    std::cout << "| DOUBLESTAR factor" << std::endl;
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
    std::cout << "atom trailer_list" << std::endl;
    if($2[0] != '\0'){
      emit_dot_edge($1, $2);
    }
    strcpy($$, $1);
  }
;

trailer_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| trailer_list trailer
  {
    std::cout << "| trailer_list trailer" << std::endl;
    if($1[0] == '\0'){
      strcpy($$, $2);
    }
    else
      {
      emit_dot_edge($1, $2);
      strcpy($$, $2);
      }
  }
;

atom:
  '(' testlist_comp_opt ')'
  {
    std::cout << "'(' testlist_comp_opt ')'" << std::endl;
    node_map["()"]++;
    string no=to_string(node_map["()"]);
    string s="()"+no;
    //emit_dot_node(s.c_str(), "()");
    if($2[0]!='\0'){
      emit_dot_edge(s.c_str(), $2);
    }
    strcpy($$, s.c_str());
  }
| '[' testlist_comp_opt ']'
  {
    std::cout << "'[' testlist_comp_opt ']'" << std::endl;
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
    std::cout << "NAME" << std::endl;
    node_map[$$]++;
    strcpy($$, "NAME(");
    strcat($$, $1); 
    strcat($$, ")");
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
  }
| NUMBER
  {
    std::cout << "NUMBER" << std::endl;
    strcpy($$, "NUMBER(");
    strcat($$, $1);
    strcat($$, ")");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
  }
| STRING string_list
  {
    std::cout << "STRING string_list" << std::endl;
    strcpy($$, "STRING("); 
    int len = strlen($1);
    //char* str = new char(len - 1);
    for(int i = 0; i < len - 1; i++){
      $1[i] = $1[i + 1];
    }
    $1[len - 2] = '\0';
    strcat($$, $1);
    strcat($$, ")");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
    if($2[0] != '\0'){
      emit_dot_edge($$, $2);
    }
  }
| NONE 
  {
    std::cout << "NONE" << std::endl;
    strcpy($$, "NONE");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
  }
| TRUE
  {
    std::cout << "TRUE" << std::endl;
    strcpy($$, "TRUE");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
  }
| FALSE
  {
    std::cout << "FALSE" << std::endl;
    strcpy($$, "FALSE");
    node_map[$$]++;
    string temp = to_string(node_map[$$]);
    strcat($$, temp.c_str());
  }
;

string_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| string_list STRING
  {
    std::cout << "| string_list STRING" << std::endl;
    if($1==NULL){
      strcpy($$,$2);}
    else{
      strcpy($$, "STRING("); 
      int len = strlen($2);
      //char* str = new char(len - 1);
      for(int i = 0; i < len - 1; i++){
          $2[i] = $2[i+1];
      }
      $2[len - 2] = '\0';
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| testlist_comp
  {
    std::cout << "| testlist_comp" << std::endl;
    strcpy($$,$1);
  }
;

testlist_comp:
  test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt
  {
    std::cout << "test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      emit_dot_edge($1, $2);
      strcpy($$, $1);
    }
  }
;

comp_for_OR_comma_test_or_star_expr_list_comma_opt:
  comp_for
  {
    std::cout << "comp_for" << std::endl;
    strcpy($$, $1);
  }
| comma_test_or_star_expr_list comma_opt
  {
    std::cout << "| comma_test_or_star_expr_list comma_opt" << std::endl;
    if($2[0] == '\0'){
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
    std::cout << "'(' arglist_opt ')'" << std::endl;
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
    std::cout << "'[' subscriptlist ']'" << std::endl;
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
    std::cout << "'. NAME'" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| arglist
  {
    std::cout << "| arglist" << std::endl;
    strcpy($$,$1);
  }
;

subscriptlist: 
  subscript comma_subscript_list comma_opt
  {
    std::cout << "subscript comma_subscript_list comma_opt" << std::endl;
    if($2==NULL && $3==NULL){
      strcpy($$, $1);
    }
    else if($3==NULL){
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
        emit_dot_edge(s.c_str(), $2);
      }
      strcpy($$, s.c_str());
    }
  }
;

comma_subscript_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_subscript_list ',' subscript
  {
    std::cout << "| comma_subscript_list ',' subscript" << std::endl;
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
    std::cout << "test" << std::endl;
    strcpy($$,$1);
  }
| test_opt ':' test_opt
  {
    std::cout << "| test_opt ':' test_opt" << std::endl;
    node_map[":"]++;
    string no=to_string(node_map[":"]);
    string s=":"+no;
    //emit_dot_node(s.c_str(), ":");
    if($1!=NULL){
      emit_dot_edge(s.c_str(), $1);
    }
    if($3!=NULL){
      emit_dot_edge(s.c_str(), $3);
    }
    strcpy($$, s.c_str());
  }
;

test_opt: 
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| test
  {
    std::cout << "| test" << std::endl;
    strcpy($$,$1);
  }
;

exprlist:
  expr_or_star_expr comma_expr_or_star_expr_list comma_opt
  {
    std::cout << "expr_or_star_expr comma_expr_or_star_expr_list comma_opt" << std::endl;
    if($2==NULL && $3==NULL){
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

comma_expr_or_star_expr_list:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_expr_or_star_expr_list ',' expr_or_star_expr
  {
    std::cout << "| comma_expr_or_star_expr_list ',' expr_or_star_expr" << std::endl;
    node_map[","]++;
    string no=to_string(node_map[","]);
    string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if($1!=NULL){
      emit_dot_edge(s.c_str(), $1);
    }
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
  }
;

expr_or_star_expr:
  expr
  {
    std::cout << "expr" << std::endl;
    strcpy($$, $1);
  }
| star_expr
  {
    std::cout << "star_expr" << std::endl;
    strcpy($$, $1);
  }
;

testlist:
  test comma_test_list comma_opt
  {
    std::cout << "test comma_test_list comma_opt" << std::endl;
    if($2==NULL && $3==NULL){
      strcpy($$, $1);
    }
    else if($3==NULL){
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_test_list ',' test
  {
    std::cout << "| comma_test_list ',' test" << std::endl;
    node_map[","]++;
    string no=to_string(node_map[","]);
    string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if($1!=NULL){
      emit_dot_edge(s.c_str(), $1);
    }
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
  }
;

classdef:
  CLASS NAME parenthesis_arglist_opt_opt ':' suite
  {
    std::cout << "CLASS NAME parenthesis_arglist_opt_opt ':' suite" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| '(' arglist_opt ')'
  {
    std::cout << "'(' arglist_opt ')'" << std::endl;
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
    std::cout << "argument comma_argument_list  comma_opt" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_argument_list ',' argument
  {
    std::cout << "| comma_argument_list ',' argument" << std::endl;
    if($3==NULL){
      strcpy($$, $1);}
    else{
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
    std::cout << "test comp_for_opt" << std::endl;
    if($2==NULL){
      strcpy($$, $1);}
    else{
      emit_dot_edge($2, $1);
      strcpy($$, $2);
    }
  }
| test '=' test
  {
    std::cout << "test '=' test" << std::endl;
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
    std::cout << "'*' test" << std::endl;
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
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_for
  {
    std::cout << "| comp_for" << std::endl;
    strcpy($$,$1);
  }
;

comp_iter:
  comp_for
  {
    std::cout << "comp_for" << std::endl;
    strcpy($$,$1);
  }
| comp_if
  {
    std::cout << "| comp_if" << std::endl;
    strcpy($$,$1);
  }
;

comp_for:
  FOR exprlist IN or_test comp_iter_opt
  {
    std::cout << "FOR exprlist IN or_test comp_iter_opt" << std::endl;
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
      emit_dot_edge(s.c_str(), $5);
    }
    emit_dot_edge(s1.c_str(), $4);
    strcpy($$, s.c_str());
  }
;

comp_if:
  IF test_nocond comp_iter_opt
  {
    std::cout << "IF test_nocond comp_iter_opt" << std::endl;
    node_map["IF"]++;
    string no=to_string(node_map["IF"]);
    string s="IF"+no;
    //emit_dot_node(s.c_str(), "IF");
    emit_dot_edge(s.c_str(), $2);
    if($3!=NULL){
      emit_dot_edge(s.c_str(), $3);
    }
    strcpy($$, s.c_str());
  }
;

comp_iter_opt:
  %empty
  {
    std::cout << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_iter
  {
    std::cout << "| comp_iter" << std::endl;
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
