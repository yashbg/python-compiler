%{
  #include <iostream>
  #include <string>
  #include <vector>
  #include <map>
  #include <unordered_map>
  #include <utility>
  #include <cstring>
  #include <stack>
  #include <cstdlib>
  #include <fstream>
  #include <stack>
  #include <algorithm>
  #include <sstream>
  #include "symtable.h"

  extern int yylex();
  extern int yylineno;
  extern char* yytext;
  extern std::ofstream parser_logfile;

  void yyerror(const char *);

  bool func_scope = false;
  bool class_scope = false;
  global_symtable gsymtable;
  local_symtable *cur_func_symtable_ptr = nullptr;
  class_symtable *cur_class_symtable_ptr = nullptr;

  std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)
  long int temp_count = 1; // counter for temporary variables
  std::string new_temp(); // generate new temporary variable
  std::string current_temp; // current temporary variable

  long int label_count = 1; // counter for labels
  std::string new_label(); // generate new label

  std::string var_type;
  std::string func_param_type;
  std::vector<std::pair<std::string, std::string>> func_params; // (name, type)
  std::string func_return_type;
  std::string current_operator;

  std::string atom_token;
  bool in_var_decl = false;
  int list_len = 0;
  int local_temp_count = 1;
  int start_pos;
  int curr_list_size;

  std::vector<std::string> func_args;

  bool is_valid_type(const std::string &type);
  void check_valid_type(const std::string &type);
  std::string get_type(const std::string &type);
  std::string max_type(const std::string &type1, const std::string &type2);
  bool is_int_literal(const std::string &str);
  bool is_float_literal(const std::string &str);
  std::string get_list_literal_type(const std::string &str);
  int calc_list_len(const std::string &str);

  void type_err_op(const std::string &op, const std::string &arg);
  void check_type_equiv(const std::string &type1, const std::string &type2);
  void check_func_args(const std::string &name);
  void check_method_args(const std::string &class_name, const std::string &method_name);

  int is_digit(char c);

  void gen(const std::string &op, const std::string &arg1, const std::string &arg2, const std::string &result); //gen function for 3AC

  std::string true_label;
  std::string false_label;
  std::string cond_label;
  std::string end_label;
  std::stack<std::string> true_stack;
  std::stack<std::string> false_stack;
  std::stack<std::string> cond_stack;
  std::stack<std::string> end_stack;
  std::stack<std::string> loop_stack;
  std::stack<std::string> loop_stack_false;
  std::string class_name;

  int get_size(const std::string &type);
  int get_list_element_count(char* list);
  std::string get_list_element_datatype(char* list_type);
  int get_list_size(char* list_datatype, char* list);
  void print_curr_3ac_instr(std::vector<std::string> &line_code);
  void generate_3AC_for_list(char* list_datatype, char* list);
  std::string strip_braces(const std::string &str);
  bool is_func(const std::string &name);
  std::string get_func_ret_type(const std::string &name);
  int get_list_width(const std::string &type);

  bool is_class(const std::string &name);

  struct activation_record {
    std::string func_name;
    std::vector<std::string> params;
    std::vector<std::string> locals;
    int return_address;
    int return_value;
    int old_stack_pointer;
    std::vector<int> saved_registers;
  };

  std::stack<activation_record> control_stack;


  void push_activation_record(activation_record ar);
  void pop_activation_record();
%}

%union { char tokenname[1024]; }

%token<tokenname> PLUSEQUAL MINEQUAL STAREQUAL SLASHEQUAL PERCENTEQUAL AMPEREQUAL VBAREQUAL CIRCUMFLEXEQUAL LEFTSHIFTEQUAL
%token<tokenname> RIGHTSHIFTEQUAL DOUBLESTAREQUAL DOUBLESLASHEQUAL DOUBLESLASH DOUBLESTAR INTEGER FLOAT_NUMBER IMAGINARY STRING NONE TRUE FALSE
%token<tokenname> NEWLINE ARROW DEF NAME BREAK CONTINUE RETURN GLOBAL IF WHILE FOR ELSE ELIF INDENT DEDENT
%token<tokenname> AND OR NOT LESSTHAN GREATERTHAN DOUBLEEQUAL GREATERTHANEQUAL LESSTHANEQUAL NOTEQUAL IN LEFTSHIFT RIGHTSHIFT CLASS
%token<tokenname> ',' '.' ';' ':' '(' ')' '[' ']' '=' '+' '-' '~' '*' '/' '%' '^' '&' '|'

%type<tokenname> file_input newline_or_stmt newline_or_stmt_list funcdef arrow_test_opt parameters typedargslist_opt typedargslist tfpdef comma_opt equal_test_opt comma_tfpdef_equal_test_opt_list colon_test_opt
%type<tokenname> semicolon_opt expr_stmt simple_stmt semicolon_small_stmt_list small_stmt stmt expr_stmt_suffix_choices equal_testlist_star_expr_list annassign testlist_star_expr test_or_star_expr comma_test_or_star_expr_list augassign flow_stmt break_stmt continue_stmt return_stmt
%type<tokenname> testlist_opt global_stmt comma_name_list compound_stmt if_stmt while_stmt for_stmt else_colon_suite_opt elif_test_colon_suite_list stmt_list test if_or_test_else_test_opt test_nocond or_test or_and_test_list and_test
%type<tokenname> and_not_test_list not_test comparison comp_op_expr_list comp_op star_expr expr or_xor_expr_list xor_expr xor_and_expr_list and_expr and_shift_expr_list shift_expr ltshift_or_rtshift shift_arith_expr_list arith_expr plus_or_minus
%type<tokenname> plus_or_minus_term_list term star_or_slash_or_percent_or_doubleslash star_or_slash_or_percent_or_doubleslash_factor_list factor plus_or_minus_or_tilde power doublestar_factor_opt atom_expr trailer_list atom string_list testlist_comp_opt testlist_comp comp_for_OR_comma_test_or_star_expr_list_comma_opt
%type<tokenname> trailer arglist_opt subscript subscriptlist comma_subscript_list test_opt exprlist comma_expr_or_star_expr_list expr_or_star_expr testlist
%type<tokenname> comma_test_list classdef parenthesis_arglist_opt_opt arglist comma_argument_list argument suite comp_for_opt comp_iter comp_for comp_if comp_iter_opt

%%

file_input:
  newline_or_stmt_list
  {
    parser_logfile << "newline_or_stmt_list" << std::endl;
  }
;

newline_or_stmt:
  NEWLINE
  {
    parser_logfile << "NEWLINE" << std::endl;
    strcpy($$, $1);
  }
| stmt
  {
    parser_logfile << "| stmt" << std::endl;
    strcpy($$, $1);
  }
;

newline_or_stmt_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| newline_or_stmt_list newline_or_stmt
  {
    parser_logfile << "| newline_or_stmt_list newline_or_stmt" << std::endl;
  }
;

/*
  ARROW : '->'
*/

funcdef:
  DEF NAME parameters arrow_test_opt ':'
  {
    func_scope = true;

    if (class_scope && std::string($2) == "__init__") {
      func_return_type = "None";
    }
    
    add_func($2, func_params, func_return_type, yylineno);
    if (class_scope) {
      cur_func_symtable_ptr = lookup_method(class_name, $2);
    }
    else {
      cur_func_symtable_ptr = lookup_func($2);
    }

    if (class_scope) {
      // add self to method symbol table
      insert_var(func_params[0].first, class_name);
    }

    if (!($2 == "len" || $2 == "range" || $2 == "print")) {
      if(class_scope == true){
        std::string t = class_name + "." + $2;
        gen("", ":", "", t);
      }
      else {
        gen("", ":", "", $2);
      }

      gen("", "", "", "beginfunc");
      
      local_temp_count = 1;
      
      for(int i = 0; i < func_params.size(); i++){
        gen("=", "popparam", "", func_params[i].first);
      }
    }
    // TODO: else
    
    func_params.clear();
  }
  suite
  {
    parser_logfile << "DEF NAME parameters arrow_test_opt ':' suite" << std::endl;

    func_scope = false;
    gen("return", "", "", "");
    gen("", "", "", "endfunc");
  }
;

arrow_test_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| ARROW test
  {
    parser_logfile << "| ARROW test" << std::endl;

    func_return_type = $2;
  }
;

parameters:
  '(' typedargslist_opt ')'
  {
    parser_logfile << "'(' typedargslist_opt ')'" << std::endl;
    
    strcpy($$, $1);
    strcat($$, $2);
    strcat($$, $3);
  }
;

typedargslist_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| typedargslist
  {
    parser_logfile << "| typedargslist" << std::endl;
    strcpy($$, $1);
  }
;

typedargslist:
  tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list
  {
    parser_logfile << "tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list" << std::endl;

    if($3[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string temp = ",";
      strcpy($$, $1);
      strcat($$, $3);
    }
  }
;

tfpdef:
  NAME colon_test_opt
  {
    strcpy($$, $1);
    if($2[0] != '\0'){
      strcat($$, $2);
    }
    func_params.push_back({$1, func_param_type});
  }
;

comma_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| ','
  {
    parser_logfile << "| ','" << std::endl;
  }
;

equal_test_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| '=' test
  {
    parser_logfile << "| '=' test" << std::endl;
    strcpy($$, $2);
  }
;

comma_tfpdef_equal_test_opt_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt
  {
    parser_logfile << "| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt" << std::endl;

    if($1[0] != '\0'){
      strcpy($$, $1);
    }
    strcpy($$, $2);
    strcat($$, $3);
  }
;

colon_test_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| ':' test
  {
    parser_logfile << "| ':' test" << std::endl;

    strcpy($$, $1);
    strcat($$, $2);
    func_param_type = $2;
  }
;

stmt:
  simple_stmt
  {
    parser_logfile << "simple_stmt" << std::endl;
    strcpy($$, $1);
  }
| compound_stmt
  {
    parser_logfile << "| compound_stmt" << std::endl;
    strcpy($$, $1);
  }
;

semicolon_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| ';'
  {
    parser_logfile << "| ';'" << std::endl;
    strcpy($$, $1);
  }
;

simple_stmt:
  small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE
  {
    parser_logfile << "small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE" << std::endl;
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      strcpy($$, $2);
    }
  }
;

semicolon_small_stmt_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| semicolon_small_stmt_list ';' small_stmt
  {
    parser_logfile << "| semicolon_small_stmt_list ';' small_stmt" << std::endl;
  }
;

small_stmt:
  expr_stmt
  {
    parser_logfile << "expr_stmt" << std::endl;
    strcpy($$, $1);
  }
| flow_stmt
  {
    parser_logfile << "| flow_stmt" << std::endl;
    strcpy($$, $1);
  }
| global_stmt
  {
    parser_logfile << "| global_stmt" << std::endl;
    strcpy($$, $1);
  }
;

expr_stmt:
  testlist_star_expr
  {
    in_var_decl = true;
  }
  annassign
  {
    parser_logfile << "testlist_star_expr annassign" << std::endl;

    // check_redecl($1); // TODO

    if (std::string($1).substr(0, 4) == "self") {
      insert_attr(std::string($1).substr(5), var_type);
    }
    else {
      insert_var($1, var_type);
    }

    list_len = 0;

    if($3[0] != ':') {
      gen("=", $3, "", $1);
    }

    strcpy($$, $3);
  }
| testlist_star_expr augassign testlist
  {
    parser_logfile << "| testlist_star_expr augassign testlist" << std::endl;

    std::string aug_op = $2;
    std::string op = aug_op.substr(0, aug_op.size() - 1);
    std::string arg_type1 = get_type($1);
    std::string arg_type2 = get_type($3);
    if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%" || op == "**" || op == "//") {
      if (!(arg_type1 == "int" || arg_type1 == "float")) {
        type_err_op(aug_op, arg_type1);
      }

      if (!(arg_type2 == "int" || arg_type2 == "float")) {
        type_err_op(aug_op, arg_type2);
      }
    }
    else if (op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>") {
      if (arg_type1 != "int") {
        type_err_op(aug_op, arg_type1);
      }

      if (arg_type2 != "int") {
        type_err_op(aug_op, arg_type2);
      }
    }

    gen(op, $1, $3, $1);

    strcpy($$, $1);
  }
| testlist_star_expr expr_stmt_suffix_choices
  {
    parser_logfile << "| testlist_star_expr expr_stmt_suffix_choices" << std::endl;
    
    if($2[0] != '\0'){
      check_type_equiv(get_type($1), get_type($2));

      gen("=", $2, "", $1);

      strcpy($$, $2);
    }
    else {
      strcpy($$, $1);
    }
  }
;

expr_stmt_suffix_choices:
  equal_testlist_star_expr_list
  {
    parser_logfile << "equal_testlist_star_expr_list" << std::endl;
    strcpy($$, $1);
  }
;

equal_testlist_star_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| equal_testlist_star_expr_list '=' testlist_star_expr
  {
    parser_logfile << "| equal_testlist_star_expr_list '=' testlist_star_expr" << std::endl;
    
    strcpy($$, $3);
  }
;

annassign:
  ':' test
  {
    in_var_decl = false;

    // if (attr_type_rem) {
    //   temp_types[attr_decl] = $2;

    //   attr_type_rem = false;
    // }
  }
  equal_test_opt
  {
    parser_logfile << "':' test equal_test_opt" << std::endl;

    var_type = $2;

    check_valid_type(var_type);

    if($4[0] != '\0'){
      check_type_equiv(var_type, get_type($4));
      std::string temp = var_type.substr(0, 4);
      if(temp == "list" && $4[0] == '['){
        int element_number = get_list_element_count($4);
        int list_size = get_list_size($2, $4);
        curr_list_size = list_size;
        gen("param", std::to_string(list_size), "", "");
        gen("stackpointer", "+4","" , "");
        gen("1", "allocmem", "," , "call");
        gen("stackpointer", "-4","" , "");
        std::string t = new_temp();
        insert_var(t, var_type);
        gen("popparam", "", "", t);
        generate_3AC_for_list($2, $4);

        list_len = calc_list_len($4);

        strcpy($$, t.c_str());

      }
      else{
      strcpy($$, $4);
      }
    }
    else{
      strcpy($$, ":");
    }
  }
;

testlist_star_expr:
  test_or_star_expr comma_test_or_star_expr_list comma_opt
  {
    parser_logfile << "test_or_star_expr comma_test_or_star_expr_list comma_opt" << std::endl;

    std::string temp = $1;
    strcpy($$, temp.c_str());
  }
;

test_or_star_expr:
  test
  {
    parser_logfile << "test" << std::endl;
    strcpy($$, $1);
  }
| star_expr
  {
    parser_logfile << "| star_expr" << std::endl;
    strcpy($$, $1);
  }
;

comma_test_or_star_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_test_or_star_expr_list ',' test_or_star_expr
  {
    parser_logfile << "| comma_test_or_star_expr_list ',' test_or_star_expr" << std::endl;

    if($1[0] == '\0'){
      strcpy($$, $3);
    }
    else{
      std::string temp = $1;
      temp += ",";
      temp += $3;
      strcpy($$, temp.c_str());
    }
  }
;

augassign:
  PLUSEQUAL
  {
    parser_logfile << "PLUSEQUAL" << std::endl;
    strcpy($$, $1);
  }
| MINEQUAL
  {
    parser_logfile << "| MINEQUAL" << std::endl;
    strcpy($$, $1);
  }
| STAREQUAL
  {
    parser_logfile << "| STAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| SLASHEQUAL
  {
    parser_logfile << "| SLASHEQUAL" << std::endl;
    strcpy($$, $1);
  }
| PERCENTEQUAL
  {
    parser_logfile << "| PERCENTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| AMPEREQUAL
  {
    parser_logfile << "| AMPEREQUAL" << std::endl;
    strcpy($$, $1);
  }
| VBAREQUAL
  {
    parser_logfile << "| VBAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| CIRCUMFLEXEQUAL
  {
    parser_logfile << "| CIRCUMFLEXEQUAL" << std::endl;
    strcpy($$, $1);
  }
| LEFTSHIFTEQUAL
  {
    parser_logfile << "| LEFTSHIFTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| RIGHTSHIFTEQUAL
  {
    parser_logfile << "| RIGHTSHIFTEQUAL" << std::endl;
    strcpy($$, $1);
  }
| DOUBLESTAREQUAL
  {
    parser_logfile << "| DOUBLESTAREQUAL" << std::endl;
    strcpy($$, $1);
  }
| DOUBLESLASHEQUAL
  {
    parser_logfile << "| DOUBLESLASHEQUAL" << std::endl;
    strcpy($$, $1);
  }
;

/* For normal and annotated assignments, additional restrictions enforced by the interpreter*/

flow_stmt:
  break_stmt
  {
    parser_logfile << "break_stmt " << std::endl;
    strcpy($$, $1);
  }
| continue_stmt
  {
    parser_logfile << "| continue_stmt" << std::endl;
    strcpy($$, $1);
  }
| return_stmt
  {
    parser_logfile << "| return_stmt" << std::endl;
    strcpy($$, $1);
  }
;

break_stmt:
  BREAK
  {
    parser_logfile << "BREAK" << std::endl;

    gen("", loop_stack_false.top(), "", "goto");
  }
;

continue_stmt:
  CONTINUE
  {
    parser_logfile << "CONTINUE" << std::endl;

    gen("", loop_stack.top(), "", "goto");
  }
;

return_stmt:
  RETURN testlist_opt
  {
    parser_logfile << "RETURN testlist_opt" << std::endl;

    if($2[0] != '\0'){
      gen("push", $2, "", "");
    }
  }
;

testlist_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| testlist
  {
    parser_logfile << "| testlist" << std::endl;
    strcpy($$, $1);
  }
;

global_stmt:
  GLOBAL NAME comma_name_list
  {
    parser_logfile << "GLOBAL NAME comma_name_list" << std::endl;
  }
;

comma_name_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_name_list ',' NAME
  {
    parser_logfile << "| comma_name_list ',' NAME" << std::endl;
  }
;

compound_stmt:
  if_stmt
  {
    parser_logfile << "if_stmt" << std::endl;
    strcpy($$, $1);
  }
| while_stmt
  {
    parser_logfile << "| while_stmt" << std::endl;
    strcpy($$, $1);
  }
| for_stmt
  {
    parser_logfile << "| for_stmt" << std::endl;
    strcpy($$, $1);
  }
| funcdef
  {
    parser_logfile << "| funcdef" << std::endl;
    strcpy($$, $1);
  }
| classdef
  {
    parser_logfile << "| classdef" << std::endl;
    strcpy($$, $1);
  }
;

if_stmt:
  IF 
  {
    cond_label = new_label();
    true_label = new_label();
    false_label = new_label();
    end_label = new_label();
    cond_stack.push(cond_label);
    true_stack.push(true_label);
    false_stack.push(false_label);
    end_stack.push(end_label);
    gen("", ":", "", cond_label);
  }
  test ':'
  {
    gen($3, "goto", true_stack.top(), "if");
    gen("", false_stack.top(), "", "goto");
    gen("", ":", "", true_stack.top());
  }
  suite 
  {
    gen("", end_stack.top(), "", "goto");
    gen("", ":", "", false_stack.top());
  }
  elif_test_colon_suite_list else_colon_suite_opt
  {
    parser_logfile << "IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt" << std::endl;
    
    gen("", ":", "", end_stack.top());  
    end_stack.pop();
    true_stack.pop();
    cond_stack.pop();
    false_stack.pop();
  }
;

while_stmt:
  WHILE 
  {
    cond_label = new_label();
    true_label = new_label();
    false_label = new_label();
    cond_stack.push(cond_label);
    loop_stack.push(cond_label);
    true_stack.push(true_label);
    false_stack.push(false_label);
    loop_stack_false.push(false_label);
    gen("", ":", "", cond_label);
  }
  test ':' 
  {
    gen($3, "goto", true_stack.top(), "if");
    gen("", false_stack.top(), "", "goto");
    gen("", ":", "", true_stack.top());
  }
  suite 
  {
    gen("", cond_stack.top(), "", "goto");
    gen("", ":", "", false_stack.top());
  }
  else_colon_suite_opt
  {
    parser_logfile << "WHILE test ':' suite else_colon_suite_opt" << std::endl;

    true_stack.pop();
    loop_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    loop_stack_false.pop();
  }
;


for_stmt:
  FOR NAME IN NAME '(' arith_expr ')' ':' 
  {
    std::string n2 = $4;
    std::string n1 = $2;
    std::string in = $6;
    if( n2 != "range")
      yyerror("Invalid iterator");
    else {
      cond_label = new_label();
      true_label = new_label();
      false_label = new_label();
      cond_stack.push(cond_label);
      loop_stack.push(cond_label);
      true_stack.push(true_label);
      false_stack.push(false_label);
      loop_stack_false.push(false_label);
      std::string t = n1 + "<" + in;
      gen("", ":", "", cond_label);
      gen(t, "goto", true_label, "if");
      gen("", false_label, "", "goto");
      gen("", ":", "", true_label);
    }
  }
  suite else_colon_suite_opt
  {
    std::string n1 = $2;
    std::string t = new_temp();
    insert_var(t, get_type(n1));
    gen("", n1, "", t);
    gen("+", t, "1", n1);
    gen("", cond_stack.top(), "", "goto");
    gen("", ":", "", false_stack.top());
    true_stack.pop();
    loop_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    loop_stack_false.pop();
  }
  | FOR NAME IN NAME '(' arith_expr ',' arith_expr ')' ':' 
  {
    std::string n2 = $4;
    std::string n1 = $2;
    std::string in1 = $6;
    std::string in2 = $8;
    if( n2 != "range")
      yyerror("Invalid iterator");
    else {
      cond_label = new_label();
      true_label = new_label();
      false_label = new_label();
      cond_stack.push(cond_label);
      loop_stack.push(cond_label);
      true_stack.push(true_label);
      false_stack.push(false_label);
      loop_stack_false.push(false_label);
      gen("", in1, "", n1);
      std::string t = n1 + "<" + in2;
      gen("", ":", "", cond_label);
      gen(t, "goto", true_label, "if");
      gen("", false_label, "", "goto");
      gen("", ":", "", true_label);
    }
  }
  suite else_colon_suite_opt
  {
    parser_logfile << "FOR exprlist IN testlist ':' suite else_colon_suite_opt" << std::endl;

    std::string n1 = $2;
    std::string t = new_temp();
    insert_var(t, get_type(n1));
    gen("", n1, "", t);
    gen("+", t, "1", n1);
    gen("", cond_stack.top(), "", "goto");
    gen("", ":", "", false_stack.top());
    true_stack.pop();
    loop_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    loop_stack_false.pop();
  }
;

else_colon_suite_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| ELSE ':' suite
  {
    parser_logfile << "| ELSE ':' suite" << std::endl;
  }
;

elif_test_colon_suite_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| elif_test_colon_suite_list ELIF 
  {
    cond_label = new_label();
    true_label = new_label();
    false_label = new_label();
    cond_stack.push(cond_label);
    true_stack.push(true_label);
    false_stack.push(false_label);
    gen("", ":", "", cond_label);
  }
  test ':' 
  {
    gen($4, "goto", true_stack.top(), "if");
    gen("", false_stack.top(), "", "goto");
    gen("", ":", "", true_stack.top());
  }
  suite
  {
    parser_logfile << "| elif_test_colon_suite_list ELIF test ':' suite" << std::endl;

    gen("", end_stack.top(), "", "goto"); 
    gen("", ":", "", false_stack.top());
    true_stack.pop();
    cond_stack.pop();
    false_stack.pop();
  }
;

/* NB compile.c makes sure that the default except clause is last*/

suite:
  simple_stmt
  {
    parser_logfile << "simple_stmt" << std::endl;
    strcpy($$, $1);
  }
| NEWLINE INDENT stmt stmt_list DEDENT
  {
    parser_logfile << "| NEWLINE INDENT stmt stmt_list DEDENT" << std::endl;
  }
;

stmt_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| stmt_list stmt
  {
    parser_logfile << "| stmt_list stmt" << std::endl;
  }
;

test:
  or_test if_or_test_else_test_opt
  {
    parser_logfile << "or_test if_or_test_else_test_opt" << std::endl;

    strcpy($$, $1);
  }
;

if_or_test_else_test_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| IF or_test ELSE test
  {
    parser_logfile << "| IF or_test ELSE test" << std::endl;
    strcpy($$, $1);
    strcat($$, $2);
    strcat($$, $3);
    strcat($$, $4);
  }
;

test_nocond:
  or_test
  {
    parser_logfile << "or_test" << std::endl;
    strcpy($$, $1);
  }
;

or_test:
  and_test or_and_test_list
  {
    parser_logfile << "and_test or_and_test_list" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "bool") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "bool") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

or_and_test_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| or_and_test_list OR and_test
  {
    parser_logfile << "| or_and_test_list OR and_test" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "bool") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "bool") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }
  }
;

and_test:
  not_test and_not_test_list
  {
    parser_logfile << "not_test and_not_test_list" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "bool") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "bool") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

and_not_test_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| and_not_test_list AND not_test
  {
    parser_logfile << "| and_not_test_list AND not_test" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "bool") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "bool") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }
  }
;

not_test:
  NOT not_test
  {
    parser_logfile << "NOT not_test" << std::endl;
    
    current_operator = $1;

    std::string op = current_operator;
    std::string arg_type = get_type($2);
    if (arg_type != "bool") {
      type_err_op(op, arg_type);
    }
    
    std::string t = new_temp();
    insert_var(t, "bool");
    gen(current_operator, $2, "", t);
    strcpy($$, t.c_str());
  }
| comparison
  {
    parser_logfile << "| comparison" << std::endl;
    strcpy($$, $1);
  }
;

comparison:
  expr comp_op_expr_list
  {
    parser_logfile << "expr comp_op_expr_list" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float" || arg_type1 == "str")) {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (!(arg_type2 == "int" || arg_type2 == "float" || arg_type2 == "str")) {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

comp_op_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_op_expr_list comp_op expr
  {
    parser_logfile << "| comp_op_expr_list comp_op expr" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float" || arg_type1 == "str")) {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (!(arg_type2 == "int" || arg_type2 == "float" || arg_type2 == "str")) {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "bool");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }
  }
;

/* <> isn't actually a valid comparison operator in Python. It's here for the
   sake of a __future__ import described in PEP 401 (which really works :-)
*/
comp_op:
  LESSTHAN
  {
    parser_logfile << "LESSTHAN" << std::endl;
    strcpy($$, "<");
  }
| GREATERTHAN
  {
    parser_logfile << "| GREATERTHAN" << std::endl;
    strcpy($$, ">");
  }
| DOUBLEEQUAL
  {
    parser_logfile << "| DOUBLEEQUAL" << std::endl;
    strcpy($$, "==");
  }
| GREATERTHANEQUAL
  {
    parser_logfile << "| GREATERTHANEQUAL" << std::endl;
    strcpy($$, ">=");
  }
| LESSTHANEQUAL
  {
    parser_logfile << "| LESSTHANEQUAL" << std::endl;
    strcpy($$, "<=");
  }
| NOTEQUAL
  {
    parser_logfile << "| NOTEQUAL" << std::endl;
    strcpy($$, "!=");
  }
| IN   /*-----------------MAY NEED TO remove this and the following comp_op--------------------*/
  {
    parser_logfile << "| IN" << std::endl;
    strcpy($$, "IN");
  }
;

star_expr:
  '*' expr
  {
    parser_logfile << "'*' expr" << std::endl;
    
    std::string t=new_temp();
    insert_var(t, get_type($2));
    gen("*", $2, "", t);
    strcpy($$, t.c_str());
  }
;

expr:
  xor_expr or_xor_expr_list
  {
    parser_logfile << "xor_expr or_xor_expr_list" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

or_xor_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| or_xor_expr_list '|' xor_expr
  {
    parser_logfile << "| or_xor_expr_list '|' xor_expr" << std::endl;

    if($1[0] == '\0'){
      current_operator = "|";
      strcpy($$, $3);
    }
    else{
      std::string op = "|";
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }

      std::string t = new_temp();
      insert_var(t, "int");
      gen("|", $1, $3, t);
      strcpy($$, t.c_str());
    }

    // std::string t=new_temp();
    // gen($2, $3, $1, t);
    // strcpy($$, t.c_str());
  }
;

xor_expr:
  and_expr xor_and_expr_list
  {
    parser_logfile << "and_expr xor_and_expr_list" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

xor_and_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| xor_and_expr_list '^' and_expr
  {
    parser_logfile << "| xor_and_expr_list '^' and_expr" << std::endl;
    
    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }

    // std::string t=new_temp();
    // gen($2, $3, $1, t);
    // strcpy($$, t.c_str());
  }
;

and_expr:
  shift_expr and_shift_expr_list
  {
    parser_logfile << "shift_expr and_shift_expr_list" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

and_shift_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| and_shift_expr_list '&' shift_expr
  {
    parser_logfile << "| and_shift_expr_list '&' shift_expr" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }

      std::string t = new_temp();
      insert_var(t, "int");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }

    // std::string t=new_temp();
    // gen($2, $3, $1, t);
    // strcpy($$, t.c_str());
  }
;

shift_expr:
  arith_expr shift_arith_expr_list
  {
    parser_logfile << "arith_expr shift_arith_expr_list" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

ltshift_or_rtshift:
  LEFTSHIFT
  {
    parser_logfile << "LEFTSHIFT" << std::endl;
    strcpy($$, "<<");;
  }
| RIGHTSHIFT
  {
    parser_logfile << "| RIGHTSHIFT" << std::endl;
    strcpy($$, ">>");
  }
;

shift_arith_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| shift_arith_expr_list ltshift_or_rtshift arith_expr
  {
    parser_logfile << "| shift_arith_expr_list ltshift_or_rtshift arith_expr" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (arg_type1 != "int") {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (arg_type2 != "int") {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }

    // std::string t=new_temp();
    // gen($2, $3, $1, t);
    // strcpy($$, t.c_str());
  }
;

arith_expr:
  term plus_or_minus_term_list
  {
    parser_logfile << "term plus_or_minus_term_list" << std::endl;

    if($2[0] != '\0'){
      std::string op = current_operator;
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float")) {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (!(arg_type2 == "int" || arg_type2 == "float")) {
        type_err_op(op, arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, max_type(arg_type1, arg_type2));
      gen("+" , $1, $2, t);
      
      strcpy($$, t.c_str());
    }
    else{
      strcpy($$, $1);
    }
  }
;

plus_or_minus:
  '+'
  {
    parser_logfile << "'+'" << std::endl;
    strcpy($$, "+");
  }
| '-'
  {
    parser_logfile << "'-'" << std::endl;
    strcpy($$, "-");
  }
;

plus_or_minus_term_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| plus_or_minus_term_list plus_or_minus term
  {
    parser_logfile << "| plus_or_minus_term_list plus_or_minus term" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float")) {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (!(arg_type2 == "int" || arg_type2 == "float")) {
        type_err_op(op, arg_type2);
      }

      std::string t = new_temp();
      insert_var(t, max_type(arg_type1, arg_type2));
      if(current_operator == "-"){
        gen($2, "-" + std::string($1), $3, t);
      }
      else{
        gen($2, $1, $3, t);
      }
      current_operator = "";
      strcpy($$, t.c_str());
    }
  }
;

term:
  factor
  {
    strcpy($$, $1);
  }
  | factor star_or_slash_or_percent_or_doubleslash factor star_or_slash_or_percent_or_doubleslash_factor_list
  {
    parser_logfile << "factor star_or_slash_or_percent_or_doubleslash_factor_list" << std::endl;
    
    std::string op = $2;
    std::string arg_type1 = get_type($1);
    if (!(arg_type1 == "int" || arg_type1 == "float")) {
      type_err_op(op, arg_type1);
    }
    std::string arg_type2 = get_type($3);
    if (!(arg_type2 == "int" || arg_type2 == "float")) {
      type_err_op(op, arg_type2);
    }
    
    std::string t = new_temp();
    insert_var(t, max_type(arg_type1, arg_type2));
    gen(op, $1, $3, t);
    if($4[0] == '\0'){
      strcpy($$, t.c_str());
    }
    else{
      std::string t2 = new_temp();
      insert_var(t2, max_type(get_type(t), get_type($4)));
      gen(current_operator, t, $4, t2);
      strcpy($$, t2.c_str());
    }
  }
;

star_or_slash_or_percent_or_doubleslash:
  '*'
  {
    parser_logfile << "'*'" << std::endl;
    strcpy($$, "*");
  }
| '/'
  {
    parser_logfile << "| '/'" << std::endl;
    strcpy($$, "/");
  }
| '%'
  {
    parser_logfile << "| '%'" << std::endl;
    strcpy($$, "%");
  }
| DOUBLESLASH
  {
    parser_logfile << "| DOUBLESLASH" << std::endl;
    strcpy($$, "//");
  }
;

star_or_slash_or_percent_or_doubleslash_factor_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor
  {
    parser_logfile << "| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor" << std::endl;

    if($1[0] == '\0'){
      current_operator = $2;
      strcpy($$, $3);
    }
    else{
      std::string op = $2;
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float")) {
        type_err_op(op, arg_type1);
      }

      std::string arg_type2 = get_type($3);
      if (!(arg_type2 == "int" || arg_type2 == "float")) {
        type_err_op(op, arg_type2);
      }

      std::string t = new_temp();
      insert_var(t, max_type(arg_type1, arg_type2));
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());
    }

    // std::string t=new_temp();
    // gen($2, $3, $1, t);
    // strcpy($$, t.c_str());
  }
;

factor:
  plus_or_minus_or_tilde factor
  {
    parser_logfile << "plus_or_minus_or_tilde factor" << std::endl;

    std::string op = $1;
    std::string arg_type = get_type($2);
    if (op == "+" || op == "-") {
      if (!(arg_type == "int" || arg_type == "float")) {
        type_err_op(op, arg_type);
      }
    }
    else if (op == "~") {
      if (arg_type != "bool") {
        type_err_op(op, arg_type);
      }
    }

    std::string t = new_temp();
    insert_var(t, arg_type);
    gen($1, $2, "", t);
    strcpy($$, t.c_str());
  }
| power
  {
    parser_logfile << "| power" << std::endl;
    strcpy($$, $1);
  }
;

plus_or_minus_or_tilde:
  '+'
  {
    parser_logfile << "'+'" << std::endl;
    strcpy($$, "+");
  }
| '-'
  {
    parser_logfile << "| '-'" << std::endl;
    strcpy($$, "-");
  }
| '~'
  {
    parser_logfile << "| '~'" << std::endl;
    strcpy($$, "~");
  }
;

power:
  atom_expr doublestar_factor_opt
  {
    parser_logfile << "atom_expr doublestar_factor_opt" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string arg_type1 = get_type($1);
      if (!(arg_type1 == "int" || arg_type1 == "float")) {
        type_err_op("**", arg_type1);
      }

      std::string arg_type2 = get_type($2);
      if (!(arg_type2 == "int" || arg_type2 == "float")) {
        type_err_op("**", arg_type2);
      }
      
      std::string t = new_temp();
      insert_var(t, max_type(arg_type1, arg_type2));
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());
    }
  }
;

doublestar_factor_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| DOUBLESTAR factor
  {
    parser_logfile << "| DOUBLESTAR factor" << std::endl;
    
    current_operator = "**";
    strcpy($$, $2);
  }
;

atom_expr:
  atom trailer_list
  {
    parser_logfile << "atom trailer_list" << std::endl;
    // handling multidimensional array access
    int running_sum = 0;
    bool found_first_index = false;
    for(int i = 0; i < strlen($2); i++){
      if($2[i] == '[') running_sum++;
      else if($2[i] == ']') running_sum--;
      if(running_sum == 0) found_first_index = true;
      if(found_first_index && (running_sum > 0)){
        yyerror(("Too many indices given for accessing list " + std::string($1)).c_str());
      }
    }
    
    std::string str = $1;
    if(str == "self"){
      if(class_scope == false){
        yyerror("Syntax error: 'self' is only valid inside a class method");
      }
      if(func_scope == false){
        yyerror("Syntax error: 'self' is only valid inside a class method");
      }
      if($2[0] != '.'){
        yyerror("Syntax error: 'self' cannot be indexed");
      }

      // symtable_entry entry = lookup_attr(class_name, std::string($2).substr(1));
      // std::string t = new_temp(); //TODO  -- store size of x in self.x
      // gen("", std::to_string(entry.size), "", t);
      // std::string t2 = new_temp(); // TODO -- store address of x in self.x
      // gen("+", "t1", t, t2);
      // std::string t3 = "*" + t2;
      // strcpy($$, t3.c_str());    // t3 = *(address of self.x)

      // std::string t = new_temp();
      // gen("=", std::string($1) + $2, "", t);

      // attr_decl = t;
      // attr_type_rem = true;

      strcpy($$, (std::string($1) + $2).c_str());
    }
    else if ($2[0] == '\0') {
      // no trailer
      strcpy($$, $1);
    }
    else if (std::string($1) == "list") {
      // list[type]
      check_valid_type(strip_braces($2));

      strcpy($$, (std::string($1) + $2).c_str());
    }
    else if ($2[0] == '[') {
      // array access
      std::string index = strip_braces($2);
      if (is_valid_type($1)) { 
        yyerror("Type error: types are not subscriptable");
      }
      
      symtable_entry entry = lookup_var($1);
      
      std::string list_idx_token = atom_token;
      if (list_idx_token != "NAME") {
        if (list_idx_token != "INTEGER") {
          yyerror(("Type error: list indices must be integers, not " + list_idx_token).c_str());
        }
      }
      else {
        std::string index_type = lookup_var(index).type;
        if (index_type != "int") {
          yyerror(("Type error: list indices must be integers, not " + index_type).c_str());
        }
      }
      
      std::string t = new_temp();
      insert_var(t, "int");
      //if(entry.type.substr(0, 4) ==  "list") gen("*", index, std::to_string(entry.size), t);
      //else 
      gen("*", index, std::to_string(entry.size), t);
      std::string t2 = new_temp();
      std::string list_type = get_type($1);
      insert_var(t2, list_type.substr(5, list_type.size() - 6));
      gen("=", (std::string($1) + "[" + t + "]").c_str(), "", t2);
      strcpy($$, t2.c_str());
      //strcpy($$, (std::string($1) + "[" + t + "]").c_str());
    }
    else if ($2[0] == '(') {
      if (is_class($1)) {
        // class constructor call
        check_method_args($1, "__init__");

        int size = get_class_size($1);
        
        // create new object
        std::string t2 = new_temp();
        insert_var(t2, "int");
        gen("=", std::to_string(size), "", t2);
        gen("param", t2, "", "");
        gen("stackpointer", "+4", "", "");
        gen("1", "allocmem", "," , "call");
        gen("stackpointer", "-4", "", "");
        std::string tempstr = new_temp();
        insert_var(tempstr, $1);
        gen("popparam", "", "", tempstr);

        // pass new object as first argument
        gen("param", tempstr, "", "");

        int stack_offset = get_size($1);
        for (auto &arg : func_args) {
          stack_offset += get_size(get_type(arg));

          gen("param", arg, "", "");
        }
        
        gen("stackpointer", "+" + std::to_string(stack_offset), "", "");
        gen(std::to_string(1 + func_args.size()), std::string($1) + ".__init__", ",", "call");
        gen("stackpointer", "-" + std::to_string(stack_offset), "", "");

        std::string temp = new_temp();
        insert_var(temp, $1);
        gen("popparam","" , "", temp);

        func_args.clear();

        strcpy($$, temp.c_str());
      }
      else if (!(str == "len" || str == "range" || str == "print")) {
        // function call
        check_func_args($1);

        int stack_offset = 0;
        for (auto &arg : func_args) {
          std::string arg_type = get_type(arg);
          stack_offset += get_size(arg_type);

          gen("param", arg, "", "");
        }
        
        gen("stackpointer", "+" + std::to_string(stack_offset), "", "");
        gen(std::to_string(func_args.size()), $1, ",", "call");
        gen("stackpointer", "-" + std::to_string(stack_offset), "", "");

        std::string ret_type = get_func_ret_type($1);
        if (ret_type != "None") {
          std::string temp = new_temp();
          insert_var(temp, ret_type);
          gen("popparam","" , "", temp);

          strcpy($$, temp.c_str());
        }
        else {
          strcpy($$, "None");
        }
        
        func_args.clear();
      }
      else if (str == "len" || str == "print") {
        // TODO: handle len variable (when $2 is not "()")
        if (func_args.size() != 1) {
          yyerror(("Syntax error: " + str + "() takes exactly one argument").c_str());
        }

        std::string arg = func_args[0];
        symtable_entry entry = lookup_var(arg);
        if (str == "len") {
          if (entry.type.substr(0, 4) != "list") {
            yyerror("Type error: argument to len() must be a list");
          }

          // TODO: len of function parameters
          std::string len = std::to_string(entry.list_len);
          std::string t = new_temp();
          insert_var(t, "int");
          gen("=", len, "", t);

          strcpy($$, t.c_str());
        }
        else if (str == "print") {
          gen("param", "\"" + get_type(arg) + "\"", "", "");
          gen("stackpointer", "+8", "", "");
          gen("1", $1, ",", "call");
          gen("stackpointer", "-8", "", "");

          strcpy($$, "print");
        }
        
        func_args.clear();
      }
      // TODO: else
    }
    else if ($2[0] == '.') {
      int paren = std::string($2).find('(');
      if (paren != std::string::npos) {
        // method call
        std::string class_name = lookup_var($1).type;
        std::string method = std::string($2).substr(1, paren - 1);
        check_method_args(class_name, method);

        // pass object as first argument
        gen("param", $1, "", "");

        int stack_offset = get_size(class_name);
        for (auto &arg : func_args) {
          stack_offset += get_size(get_type(arg));

          gen("param", arg, "", "");
        }
        
        gen("stackpointer", "+" + std::to_string(stack_offset), "", "");
        gen(std::to_string(1 + func_args.size()), class_name + "." + method, ",", "call");
        gen("stackpointer", "-" + std::to_string(stack_offset), "", "");

        std::string ret_type = get_type(std::string($1) + $2);
        if(ret_type != "None"){
          std::string temp = new_temp();
          insert_var(temp, ret_type);
          gen("popparam","" , "", temp);

          strcpy($$, temp.c_str());
        }
        else {
          strcpy($$, "None");
        }

        func_args.clear();
      }
      else {
        // object attribute access
        strcpy($$, (std::string($1) + $2).c_str());
      }
    }
    else {
      strcpy($$, $1);
      strcat($$, $2);
    }
  }
;

trailer_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| trailer_list trailer
  {
    parser_logfile << "| trailer_list trailer" << std::endl;
    
    if($1[0] == '\0') strcpy($$, $2);
    else{
      strcpy($$, $1);
      strcat($$, $2);
    }
  }
;

atom:
  '(' testlist_comp_opt ')'
  {
    parser_logfile << "'(' testlist_comp_opt ')'" << std::endl;
    
    if (in_var_decl) {
      yyerror(("Type error: invalid type: (" + std::string($2) + ")").c_str());
    }
    
    strcpy($$, $2);
  }
| '[' testlist_comp_opt ']'
  {
    parser_logfile << "'[' testlist_comp_opt ']'" << std::endl;

    if (in_var_decl) {
      check_valid_type($2);
    }
    
    std::string temp = "[";
    temp += $2;
    temp += "]";
    strcpy($$, temp.c_str());
  }
| NAME
  {
    parser_logfile << "NAME" << std::endl;

    strcpy($$, $1);

    if (is_valid_type($1)) {
      atom_token = "TYPE";
    }
    else {
      atom_token = "NAME";
    }
  }
| INTEGER
  {
    parser_logfile << "INTEGER" << std::endl;

    strcpy($$, $1);

    atom_token = "INTEGER";
  }
| FLOAT_NUMBER
  {
    parser_logfile << "FLOAT_NUMBER" << std::endl;

    strcpy($$, $1);

    atom_token = "FLOAT_NUMBER";
  }
| IMAGINARY
  {
    parser_logfile << "IMAGINARY" << std::endl;

    strcpy($$, $1);

    atom_token = "IMAGINARY";
  }
| STRING string_list
  {
    parser_logfile << "STRING string_list" << std::endl;

    int len = strlen($1);
    for(int i = 0; i < len - 1; i++){
      $1[i] = $1[i + 1];
    }
    $1[len - 2] = '\0';
    
    strcpy($$, (("\"" + std::string($1) + "\"").c_str()));

    atom_token = "STRING";
  }
| NONE
  {
    parser_logfile << "NONE" << std::endl;

    strcpy($$, "None");

    atom_token = "NONE";
  }
| TRUE
  {
    parser_logfile << "TRUE" << std::endl;

    strcpy($$, "True");

    atom_token = "TRUE";
  }
| FALSE
  {
    parser_logfile << "FALSE" << std::endl;

    strcpy($$, "False");

    atom_token = "FALSE";
  }
;

string_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| string_list STRING
  {
    parser_logfile << "| string_list STRING" << std::endl;
    if($1[0]=='\0'){
      strcpy($$,$2);}
    else{
      strcpy($$, $1);
    }
  }
;

testlist_comp_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| testlist_comp
  {
    parser_logfile << "| testlist_comp" << std::endl;
    strcpy($$,$1);
  }
;

testlist_comp:
  test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt
  {
    parser_logfile << "test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string temp = $1;
      temp += ",";
      temp += $2;
      strcpy($$, temp.c_str());
    }
  }
;

comp_for_OR_comma_test_or_star_expr_list_comma_opt:
  comp_for
  {
    parser_logfile << "comp_for" << std::endl;
    strcpy($$, $1);
  }
| comma_test_or_star_expr_list comma_opt
  {
    parser_logfile << "| comma_test_or_star_expr_list comma_opt" << std::endl;
    strcpy($$, $1);
  }
;

trailer:
  '(' arglist_opt ')'
  {
    parser_logfile << "'(' arglist_opt ')'" << std::endl;

    strcpy($$, ("(" + std::string($2) + ")").c_str());
  }
| '[' subscriptlist ']'
  {
    parser_logfile << "'[' subscriptlist ']'" << std::endl;

    strcpy($$, ("[" + std::string($2) + "]").c_str());
  }
| '.' NAME
  {
    parser_logfile << "'.' NAME" << std::endl;
    
    strcpy($$, $1);
    strcat($$, $2);
  }
;

arglist_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| arglist
  {
    parser_logfile << "| arglist" << std::endl;
    strcpy($$,$1);
  }
;

subscriptlist:
  subscript comma_subscript_list comma_opt
  {
    parser_logfile << "subscript comma_subscript_list comma_opt" << std::endl;
    if($2[0]=='\0'){
      strcpy($$, $1);
    }
    else {
      strcpy($$, $2);
    }
  }
;

comma_subscript_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_subscript_list ',' subscript
  {
    parser_logfile << "| comma_subscript_list ',' subscript" << std::endl;
  }
;

subscript:
  test
  {
    parser_logfile << "test" << std::endl;
    strcpy($$,$1);
  }
| test_opt ':' test_opt
  {
    parser_logfile << "| test_opt ':' test_opt" << std::endl;
  }
;

test_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| test
  {
    parser_logfile << "| test" << std::endl;
    strcpy($$,$1);
  }
;

exprlist:
  expr_or_star_expr comma_expr_or_star_expr_list comma_opt
  {
    parser_logfile << "expr_or_star_expr comma_expr_or_star_expr_list comma_opt" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string temp = std::string($1) + "," + std::string($2);
      strcpy($$, temp.c_str());
    }
  }
;

comma_expr_or_star_expr_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_expr_or_star_expr_list ',' expr_or_star_expr
  {
    parser_logfile << "| comma_expr_or_star_expr_list ',' expr_or_star_expr" << std::endl;
    
    if($1[0] == '\0'){
      strcpy($$, $3);
    }
    else{
      std::string temp = std::string($1) + "," + std::string($3);
      strcpy($$, temp.c_str());
    }
  }
;

expr_or_star_expr:
  expr
  {
    parser_logfile << "expr" << std::endl;
    strcpy($$, $1);
  }
| star_expr
  {
    parser_logfile << "star_expr" << std::endl;
    strcpy($$, $1);
  }
;

testlist:
  test comma_test_list comma_opt
  {
    parser_logfile << "test comma_test_list comma_opt" << std::endl;
    
    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string temp = std::string($1) + "," + std::string($2);
      strcpy($$, temp.c_str());
    }
  }
;

comma_test_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_test_list ',' test
  {
    parser_logfile << "| comma_test_list ',' test" << std::endl;
    
    if($1[0] == '\0') strcpy($$, $3);
    else{
      std::string temp = std::string($1) + "," + std::string($3);
      strcpy($$, temp.c_str());
    }
  }
;

classdef:
  CLASS NAME parenthesis_arglist_opt_opt ':'
  {
    class_symtable *parent_symtable_ptr = nullptr;
    if (!func_args.empty()) {
      parent_symtable_ptr = lookup_class(func_args[0]);
    }

    func_args.clear();

    add_class($2, parent_symtable_ptr);

    cur_class_symtable_ptr = gsymtable.class_symtable_ptrs[$2];
    class_scope = true;
    class_name = $2;
  }
  suite
  {
    parser_logfile << "CLASS NAME parenthesis_arglist_opt_opt ':' suite" << std::endl;

    class_scope = false;
  }
;

parenthesis_arglist_opt_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| '(' arglist_opt ')'
  {
    parser_logfile << "'(' arglist_opt ')'" << std::endl;
    
    std::string temp = "(" + std::string($2) + ")";
    strcpy($$, temp.c_str());
  }
;

arglist:
  argument comma_argument_list comma_opt
  {
    parser_logfile << "argument comma_argument_list comma_opt" << std::endl;

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
      std::string temp = std::string($1) + "," + std::string($2);
      strcpy($$, temp.c_str());
    }
  }
;

comma_argument_list:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comma_argument_list ',' argument
  {
    parser_logfile << "| comma_argument_list ',' argument" << std::endl;
    
    if($1[0] == '\0') strcpy($$, $3);
    else{
      std::string temp = std::string($1) + "," + std::string($3);
      strcpy($$, temp.c_str());
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
    parser_logfile << "test comp_for_opt" << std::endl;

    strcpy($$, $1);

    func_args.push_back($1);
  }
| test '=' test
  {
    parser_logfile << "test '=' test" << std::endl;
  }
| '*' test
  {
    parser_logfile << "'*' test" << std::endl;
  }
;

comp_for_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_for
  {
    parser_logfile << "| comp_for" << std::endl;
    strcpy($$,$1);
  }
;

comp_iter:
  comp_for
  {
    parser_logfile << "comp_for" << std::endl;
    strcpy($$,$1);
  }
| comp_if
  {
    parser_logfile << "| comp_if" << std::endl;
    strcpy($$,$1);
  }
;

comp_for:
  FOR exprlist IN or_test comp_iter_opt
  {
    parser_logfile << "FOR exprlist IN or_test comp_iter_opt" << std::endl;
  }
;

comp_if:
  IF test_nocond comp_iter_opt
  {
    parser_logfile << "IF test_nocond comp_iter_opt" << std::endl;
  }
;

comp_iter_opt:
  %empty
  {
    parser_logfile << "%empty" << std::endl;
    $$[0]='\0';
  }
| comp_iter
  {
    parser_logfile << "| comp_iter" << std::endl;
    strcpy($$,$1);
  }
;

/* not used in grammar, but may appear in "node" passed from Parser to Compiler */
/*
encoding_decl: NAME
*/

%%

void yyerror(const char *s) {
  std::cerr << "Error on line " << yylineno << ", token(" << yytext << "): " << s << std::endl;
  exit(1);
}

int is_digit(char c) {
  return ((c >= '0') && (c <= '9'));
}

int get_size(const std::string &type) {
  if (type == "bool") {
    return 1;
  }

  if (type == "int"){
    return 4;
  }

  if (type == "float"){
    return 4;
  }
  
  if (type == "str") {
    return 8;
  }

  if (type.substr(0, 4) == "list") {
    return 8;
  }

  if (is_class(type)) {
    return 8;
  }

  return 8;
}

void print_curr_3ac_instr(std::vector<std::string> &line_code) {
  if (line_code[0] == "=") {
    std::cout << line_code[3] << " = "
              << line_code[1] << std::endl;
  }
  else if (line_code[2].empty()) {
    std::cout << line_code[3] << " = "
              << line_code[0] << " "
              << line_code[1] << std::endl;
  }
  else {
    std::cout << line_code[3] << " = "
              << line_code[1] << " "
              << line_code[0] << " "
              << line_code[2] << std::endl;
  }
}

void gen(const std::string &op, const std::string &arg1, const std::string &arg2, const std::string &result) {
  ac3_code.push_back({op, arg1, arg2, result});
  // print_curr_3ac_instr(ac3_code.back());
}

std::string new_temp() {
  if(func_scope){
    std::string temp = "t" + std::to_string(local_temp_count);
    local_temp_count++;
    current_temp = temp;
    return temp;
  }
  std::string temp = "t" + std::to_string(temp_count);
  temp_count++;
  current_temp = temp;
  return temp;
}

std::string new_label() {
  std::string label = "L" + std::to_string(label_count);
  label_count++;
  return label;
}

int get_list_element_count(char* list){
  int elems = 1;
  for(int i = 0; i < strlen(list); i++){
    if(list[i] == ',') elems++;
  }
  return elems;
}

std::string get_list_element_datatype(char* list_type){
  std::string list_elem_type;
  for(int i = 5; i < strlen(list_type) - 1; i++){
    list_elem_type += list_type[i];
  }
  return list_elem_type;
}

int get_list_size(char* list_datatype, char* list){
    std::string list_elem_type = get_list_element_datatype(list_datatype);
    int element_number = get_list_element_count(list), list_size; 
    if(list_elem_type == "str"){
      list_size = strlen(list) - 2 - (element_number - 1) - 2 * element_number;
    }
    else{
      list_size = get_size(list_elem_type) * element_number;
    }
    return list_size;
}

void generate_3AC_for_list(char* list_datatype, char* list){
  std::string list_elem_type = get_list_element_datatype(list_datatype);
  int element_number = get_list_element_count(list);
  int prev = 0, i = 1;
  while(i < strlen(list) - 1){
    std::string curr_elem;
    while((i < strlen(list) - 1) && list[i] != ','){
      curr_elem += list[i];
      i++;
    }
    std::string temp =  "t" + std::to_string(local_temp_count - 1) + "[" + std::to_string(prev) + "]";
    gen("=", curr_elem, "", temp);
    if(list_elem_type == "str"){
      prev = prev + curr_elem.size() - 2;
    }
    else{
      prev = prev + get_size(list_elem_type);
    }
    i++;
  }
}

std::string strip_braces(const std::string &str) {
  return str.substr(1, str.size() - 2);
}

bool is_valid_type(const std::string &type) {
  if (type == "list") {
    return false;
  }
  
  if (type.substr(0, 4) == "list") {
    return is_valid_type(type.substr(5, type.size() - 6));
  }

  if (is_class(type)) {
    return true;
  }

  return type == "int" || type == "float" || type == "str" || type == "bool";
}

void check_valid_type(const std::string &type) {
  if (is_valid_type(type)) {
    return;
  }

  yyerror(("Type error: invalid type: " + type).c_str());
}

std::string get_type(const std::string &str) {
  if (str == "None") {
    return "None";
  }

  if (str == "True" || str == "False") {
    return "bool";
  }
  
  if (is_int_literal(str)) {
    return "int";
  }

  if (is_float_literal(str)) {
    return "float";
  }

  if (is_valid_type(str)) {
    return str;
  }

  if (str[0] == '[') {
    return get_list_literal_type(str);
  }

  if (str[0] == '"') {
    return "str";
  }

  if (is_func(str)) {
    return get_func_ret_type(str);
  }

  if (is_class(str)) {
    return str;
  }

  int dot = str.find('.');
  if (dot != std::string::npos) {
    int paren = str.find('(');
    if(paren != std::string::npos) {
      std::string method = str.substr(dot + 1, paren - dot - 1);
      if (str.substr(0, 4) == "self") {
        return lookup_method(class_name, method)->return_type;
      }

      std::string class_name = lookup_var(str.substr(0, dot)).type;
      return lookup_method(class_name, method)->return_type;
    }

    std::string attr = str.substr(dot + 1);
    if (str.substr(0, 4) == "self") {
      return lookup_attr(class_name, attr).type;
    }

    std::string class_name = lookup_var(str.substr(0, dot)).type;
    return lookup_attr(class_name, attr).type;
  }

  return lookup_var(str).type;
}

std::string max_type(const std::string &type1, const std::string &type2) {
  if (type1 == "float" || type2 == "float") {
    return "float";
  }

  if (type1 == "int" || type2 == "int") {
    return "int";
  }

  if (type1 == "bool" || type2 == "bool") {
    return "bool";
  }

  std::cout << "Can't calculate max type: " << type1 << " " << type2 << std::endl;
  return type1;
}

bool is_int_literal(const std::string &str) {
  for (auto c : str) {
    if (!is_digit(c)) {
      return false;
    }
  }

  return true;
}

bool is_float_literal(const std::string &str) {
  int dot = str.find('.');
  if (dot == std::string::npos || dot == 0 || dot == str.size() - 1) {
    return false;
  }

  return is_int_literal(str.substr(0, dot)) && is_int_literal(str.substr(dot + 1, str.size() - dot - 1));
}

void type_err_op(const std::string &op, const std::string &arg) {
  yyerror(("Incompatible operator " + op +  " with operand of type " + arg).c_str());
}

void check_type_equiv(const std::string &type1, const std::string &type2) {
  if (type1 != type2) {
    yyerror(("Type mismatch: " + type1 + " and " + type2).c_str());
  }
}

std::string get_list_literal_type(const std::string &str) {
  std::string vals = str.substr(1, str.size() - 2);
  int comma = vals.find(',');
  std::string val;
  if (comma == std::string::npos) {
    val = vals;
  }
  else {
    val = vals.substr(0, comma);
  }

  if (is_int_literal(val)) {
    return "list[int]";
  }
  
  if (is_float_literal(val)) {
    return "list[float]";
  }

  return "list[" + get_type(val) + "]";
}

int calc_list_len(const std::string &str) {
  // not for lists of type list[str]
  return std::count(str.begin(), str.end(), ',') + 1;
}

void check_func_args(const std::string &name) {
  if (name == "len" || name == "range" || name == "print") {
    return;
  }

  local_symtable *func_symtable_ptr = lookup_func(name);
  int num_args = func_args.size();

  int num_params = func_symtable_ptr->params.size();
  if (num_args != num_params) {
    yyerror(("Type error: " + name + "() takes " + std::to_string(num_params) + " positional arguments but " + std::to_string(num_args) + " were given").c_str());
  }

  for (int i = 0; i < num_params; i++) {
    std::string arg_type = get_type(func_args[i]);
    std::string param_type = func_symtable_ptr->params[i].second;
    if (arg_type != param_type) {
      yyerror(("Type mismatch in call to " + name + "(): " + param_type + " required but " + arg_type + " was passed").c_str());
    }
  }
}

void check_method_args(const std::string &class_name, const std::string &method_name) {
  local_symtable *func_symtable_ptr = lookup_method(class_name, method_name);
  int num_args = func_args.size();
  
  int num_params = func_symtable_ptr->params.size();
  if (num_args + 1 != num_params) {
    yyerror(("Type error: " + class_name + "." + method_name + "() takes " + std::to_string(num_params - 1) + " positional arguments but " + std::to_string(num_args) + " were given").c_str());
  }

  for (int i = 1; i < num_params; i++) {
    std::string arg_type = get_type(func_args[i - 1]);
    std::string param_type = func_symtable_ptr->params[i].second;
    if (arg_type != param_type) {
      yyerror(("Type mismatch in call to " + class_name + "." + method_name + "(): " + param_type + " required but " + arg_type + " was passed").c_str());
    }
  }
}

bool is_func(const std::string &name) {
  if (class_scope) {
    auto func_symtable_itr = cur_class_symtable_ptr->method_symtable_ptrs.find(name);
    if (func_symtable_itr != cur_class_symtable_ptr->method_symtable_ptrs.end()) {
      return true;
    }
  }

  auto func_symtable_itr = gsymtable.func_symtable_ptrs.find(name);
  if (func_symtable_itr != gsymtable.func_symtable_ptrs.end()) {
    return true;
  }

  return false;
}

std::string get_func_ret_type(const std::string &name) {
  return lookup_func(name)->return_type;
}

int get_list_width(const std::string &type) {
  return get_size(type.substr(5, type.size() - 6));
}

bool is_class(const std::string &name) {
  return gsymtable.class_symtable_ptrs.find(name) != gsymtable.class_symtable_ptrs.end();
}

void push_activation_record(activation_record ar){
  control_stack.push(ar);
}

void pop_activation_record(){
  if (control_stack.empty()) {
        std::cerr << "Error: Attempting to pop an empty stack!" << std::endl;
        return;
    }
  control_stack.pop();
}
