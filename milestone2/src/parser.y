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
  extern std::ofstream outfile;
  extern std::ofstream parser_logfile;

  void yyerror(const char *);

  std::map<std::string, int> node_map;
  int comma_number = 1;
  std::string s1, s2;

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

  int offset = 0; // TODO
  std::string var_type;
  std::string func_param_type;
  std::vector<std::pair<std::string, std::string>> func_params; // (name, type)
  std::string func_return_type;
  std::string current_operator;

  std::unordered_map<std::string, std::string> temp_types; // temp -> type
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

  void emit_dot_node(const char* node_name, const char* label);
  void emit_dot_edge(const char* from, const char* to);

  void gen(const std::string &op, const std::string &arg1, const std::string &arg2, const std::string &result); //gen function for 3AC
  void gen(std::string s); //gen function for goto operations
  void gen(std::string s, int); //gen function for goto operations
  void backpatch(std::vector<std::string> &list, std::string label); //backpatch function for 3AC

  std::map<std::string, std::string> true_list;
  std::map<std::string, std::string> false_list;
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
  std::stack<std::vector<std::string>> code_stack;
  std::string class_name;

  std::string get_sem_val(char *c_str); // get semantic value from AST node
  int get_size(const std::string &type); // returns width for lists
  int get_list_element_count(char* list);
  std::string get_list_element_datatype(char* list_type);
  int get_list_size(char* list_datatype, char* list);
  void print_curr_3ac_instr(std::vector<std::string> &line_code);
  void generate_3AC_for_list(char* list_datatype, char* list);
  std::string strip_braces(const std::string &str);
  std::string get_curr_param_name(char* param_list);
  int get_param_size(std::string datatype, std::string param_name);
  bool is_func(const std::string &name);
  std::string get_ret_type(const std::string &name);

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

  void generate_3AC_for_list_copying(std::string dest, std::string src);
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
    char str[5] = "Root";
    emit_dot_edge(str, $2);
  }
;

/*
  ARROW : '->'
*/

funcdef:
  DEF NAME parameters arrow_test_opt ':'
  {
    add_func($2, func_params, func_return_type, yylineno);
    func_params.clear();

    if (!($2 == "len" || $2 == "range" || $2 == "print")) {
      cur_func_symtable_ptr = lookup_func($2);
      func_scope = true;
      if(class_scope == true){
        std::string t = class_name + "." + $2;
        gen("", ":", "", t);
      }
      else
      gen("", ":", "", $2);
      gen("", "", "", "beginfunc");
      // if(class_scope == true){
      //   std::string t = new_temp(); // TODO
      //   gen("popparam", "", "", t);
      // }
      local_temp_count = 1;
      local_symtable *func_symtable_ptr = lookup_func($2);
      int num_params = func_symtable_ptr->param_types.size();
      start_pos = 1;
      for(int i = 0; i < num_params; i++){
        std::string t = new_temp(); // TODO: type checking
        gen("=", "popparam", "", t);
        std::string curr_param = get_curr_param_name($3);
        gen("=", t, "", curr_param);
      }
    }
    // TODO: else
  }
  suite
  {
    parser_logfile << "DEF NAME parameters arrow_test_opt ':' suite" << std::endl;
    strcpy($$, "NAME(");
    strcat($$, $2);
    strcat($$, ")");
    node_map[$2]++;
    node_map["DEF"]++;

    s1 = "DEF" + std::to_string(node_map["DEF"]);
    s2 = $$ + std::to_string(node_map[$2]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    s1 = $$ + std::to_string(node_map[$2]);
    emit_dot_edge(s1.c_str(), $3);

    node_map[":"]++;
    s1 = $5+std::to_string(node_map[":"]);
    if($4[0] != '\0'){
      s2 = "DEF"+std::to_string(node_map["DEF"]);
      emit_dot_edge($4, s2.c_str());
      emit_dot_edge(s1.c_str(), $4);
    }
    else {
      s2 = "DEF" + std::to_string(node_map["DEF"]);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    emit_dot_edge(s1.c_str(), $7);

    strcpy($$, $5);
    std::string temp = std::to_string(node_map[":"]);
    strcat($$, temp.c_str());

    func_scope = false;
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
    node_map["->"]++;
    parser_logfile << "| ARROW test" << std::endl;
    s1 = "->"+std::to_string(node_map["->"]);
    s2 = $2;
    emit_dot_edge(s1.c_str(), $2);
    strcpy($$,s1.c_str());

    func_return_type = $2;
  }
;

parameters:
  '(' typedargslist_opt ')'
  {
    parser_logfile << "'(' typedargslist_opt ')'" << std::endl;
    
    node_map["()"]++;

    // if($2[0] != '\0'){
    //   s1 = "()"+std::to_string(node_map["()"]);
    //   emit_dot_edge(s1.c_str(), $2);
    // }

    // strcpy($$, "()");
    // std::string temp = std::to_string(node_map["()"]);
    // strcat($$, temp.c_str());
    
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
    // if($2[0] != '\0') {
    //   s1 = $2;
    //   s2 = $1;
    //   emit_dot_edge(s1.c_str(), s2.c_str());
    // }
 
    // if($3[0]!='\0')
    // {
    //   if($2[0] != '\0'){
    //     s1 = $3;
    //     s2 =$2;
    //     emit_dot_edge($3, s2.c_str());
    //     strcpy($$, $3);
    //   }
    //   else{
    //     emit_dot_edge($3, $1);
    //     strcpy($$, $3);
    //   }
    // }
    // else
    // {
    //   if($2[0] != '\0'){
    //     strcpy($$, $2);
    //   }
    //   else{
    //     strcpy($$, $1);
    //   }
    // }
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
    // node_map[$1]++;
    // s2 = "NAME(";
    // s2 += $1;
    // s2 += ")";
    // s2 += std::to_string(node_map[$1]);
 
    // if($2[0] != '\0'){
    //   parser_logfile << "NAME colon_test_opt" << std::endl;
    //   strcpy($$, ":");
    //   std::string temp = std::to_string(node_map[":"]);
    //   strcat($$, temp.c_str());
 
    //   emit_dot_edge($2, s2.c_str());
    // }
    // else {
    //   strcpy($$, s2.c_str());
    // }
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
    node_map[","]++;
    s1 = "," + std::to_string(node_map[","]);
    strcpy($$, s1.c_str());
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
    //node_map["="]++;
    //s1 = "="+std::to_string(node_map["="]);
    //emit_dot_edge(s1.c_str(), $2);
    //strcpy($$, s1.c_str());
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
    // if($4[0] != '\0'){
    //   s1 = $4;
    //   s2 = $3;
    //   emit_dot_edge(s1.c_str(), $3);
    // }
// 
    // node_map[","]++;
// 
    // if($1[0]!='\0')
    // {
    //   if($4[0] != '\0'){
    //     s2 =$4;
    //     emit_dot_edge($1, s2.c_str());
    //   }
    //   else{
    //     emit_dot_edge($1, $3);
// 
    //   }
    //   s1 = ","+std::to_string(node_map[","]);
    //   emit_dot_edge(s1.c_str(), $1);
    //   strcpy($$, ",");
    //   std::string temp = std::to_string(node_map[","]);
    //   strcat($$, temp.c_str());
    // }
    // else{
    //   s1 = "," + std::to_string(node_map[","]);
    //   if($4[0] != '\0'){
    //     s2 = $4;
    //   }
    //   else{
    //     s2 = $3;
    //   }
    //   emit_dot_edge(s1.c_str(), s2.c_str());
// 
    //   strcpy($$, ",");
    //   std::string temp = std::to_string(node_map[","]);
    //   strcat($$, temp.c_str());
    // }
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
    // node_map[":"]++;
    // s1 = ":"+std::to_string(node_map[":"]);
    // emit_dot_edge(s1.c_str(), $2);
    // strcpy($$, s1.c_str());
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
        emit_dot_edge($2, $1);
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
    if($1[0] != '\0'){
      node_map[";"]++;
      s1 = ";"+std::to_string(node_map[";"]);
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

    check_redecl(get_sem_val($1));
    // emit_dot_edge($3, $1);
    // strcpy($$, $3);

    if (var_type.substr(0, 4) == "list") {
      int list_size = list_len * get_size(var_type);
      if(var_type == "list[str]"){
        list_size = curr_list_size;
      }
      insert_var($1, {var_type, "", yylineno, list_size, list_len, get_size(var_type), offset}); // TODO
      list_len = 0;
    }
    else {
      insert_var($1, {var_type, "", yylineno, get_size(var_type), 0, 0, offset}); // TODO
    }

    if($3[0] != ':') {
      gen("=", $3, "", $1);
    }

    strcpy($$, $3);
  }
| testlist_star_expr augassign testlist
  {
    parser_logfile << "| testlist_star_expr augassign testlist" << std::endl;

    // s1 = $2;
    // emit_dot_edge(s1.c_str(), $3);
    // emit_dot_edge(s1.c_str(), $1);
    // strcpy($$, s1.c_str());

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
    
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else{
    //   s1 = $2;
    //   emit_dot_edge($2, $1);
    //   strcpy($$, $2);
    // }
    
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
    
    // node_map["="]++;
    // s1 = "=" + std::to_string(node_map["="]);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s1.c_str(), $1);
    // }
    // emit_dot_edge(s1.c_str(), $3);
    // strcpy($$, s1.c_str());
    
    strcpy($$, $3);
  }
;

annassign:
  ':' test
  {
    in_var_decl = false;
  }
  equal_test_opt
  {
    parser_logfile << "':' test equal_test_opt" << std::endl;
    //node_map[":"]++;
    //s1 = ":" + std::to_string(node_map[":"]);
    //emit_dot_edge(s1.c_str(), $2);

    //s2 = ":" + std::to_string(node_map[":"]);

    //if($4[0] != '\0'){
    //  emit_dot_edge(s1.c_str(), $4);
    //  strcpy($$, s1.c_str());
    //}
    //else{
    //  strcpy($$, s2.c_str());
    //}

    var_type = $2;

    check_valid_type(var_type);

    if($4[0] != '\0'){
      check_type_equiv(var_type, get_type($4));

      std::string temp = var_type.substr(0, 4);
      if(temp == "list"){
        int element_number = get_list_element_count($4);
        int list_size = get_list_size($2, $4);
        std::string alloc_bytes = "alloc " + std::to_string(list_size);
        curr_list_size = list_size;
        std::string t = new_temp();
        gen("=", alloc_bytes, "", t);
        generate_3AC_for_list($2, $4);

        list_len = calc_list_len($4);

        strcpy($$, t.c_str());

        temp_types[t] = var_type;
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
    //if($2[0] != '\0'){
    //  emit_dot_edge($2, $1);
    //  strcpy($$, $2);
    //}
    //else{
    //  strcpy($$, $1);
    //}

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
    // node_map[","]++;
    // s1 = "," + std::to_string(node_map[","]);
    // emit_dot_edge(s1.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s1.c_str(), $1);
    //   strcpy($$, s1.c_str());
    // }
    // else{
    //   comma_number = node_map[","];
    //   strcpy($$, s1.c_str());
    // }
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
    gen("", loop_stack_false.top(), "", "goto");
    parser_logfile << "BREAK" << std::endl;
    // node_map["BREAK"]++;
    // std::string no=std::to_string(node_map["BREAK"]);
    // std::string s="BREAK"+no;
    // //emit_dot_node(s.c_str(), "BREAK");
    // strcpy($$, s.c_str());
  }
;

continue_stmt:
  CONTINUE
  {
    gen("", loop_stack.top(), "", "goto");
    parser_logfile << "CONTINUE" << std::endl;
    // node_map["CONTINUE"]++;
    // std::string no=std::to_string(node_map["CONTINUE"]);
    // std::string s="CONTINUE"+no;
    // //emit_dot_node(s.c_str(), "CONTINUE");
    // strcpy($$, s.c_str());
  }
;

return_stmt:
  RETURN testlist_opt
  {
    parser_logfile << "RETURN testlist_opt" << std::endl;
    // node_map["RETURN"]++;
    // std::string no=std::to_string(node_map["RETURN"]);
    // std::string s="RETURN"+no;
    // //emit_dot_node(s.c_str(), "RETURN");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);}
    // strcpy($$, s.c_str());
    if($2[0] != '\0'){
      gen("push", $2, "", "");
    }
    gen("return", "", "", "");
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
    node_map["GLOBAL"]++;
    std::string no=std::to_string(node_map["GLOBAL"]);
    std::string s="GLOBAL"+no;
    //emit_dot_node(s.c_str(), "GLOBAL");
    char* s2;
    node_map[$2]++;
    strcpy(s2,"NAME(");
    strcat(s2,$2);
    strcat(s2,")");
    std::string temp = std::to_string(node_map[$2]);
    strcat(s2, temp.c_str());
    emit_dot_edge(s.c_str(), s2);
    if($3[0]!='\0'){
      emit_dot_edge(s.c_str(), $3);}
    strcpy($$, s.c_str());
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
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    char* s2;
    node_map[$3]++;
    strcpy(s2,"NAME(");
    strcat(s2,$3);
    strcat(s2,")");
    std::string temp = std::to_string(node_map[$3]);
    strcat(s2, temp.c_str());
    emit_dot_edge(s.c_str(), s2);
    if($1[0]!='\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    strcpy($$, s.c_str());
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
    gen("", ":", "", end_stack.top());  
    end_stack.pop();
    true_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    parser_logfile << "IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt" << std::endl;
    // node_map["IF"]++;
    // std::string no=std::to_string(node_map["IF"]);
    // std::string s="IF"+no;
    // emit_dot_edge(s.c_str(), $2);
    // node_map[":"]++;
    // std::string no1=std::to_string(node_map[":"]);
    // std::string s1=":"+no1;
    // emit_dot_edge(s1.c_str(), s.c_str());
    // emit_dot_edge(s1.c_str(), $4);
    // strcpy($$, $3);
    // std::string temp = std::to_string(node_map[":"]);
    // strcat($$, temp.c_str());
    // if(($5[0] == '\0') && ($6[0] == '\0')){

    // }
    // else if($5[0] == '\0'){
    //   emit_dot_edge($$, $6);
    // }
    // else if($6[0] == '\0'){
    //   emit_dot_edge($$, $5);
    // }
    // else{
    //   emit_dot_edge($$, $5);
    //   emit_dot_edge($5, $6);
    // }
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
    true_stack.pop();
    loop_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    loop_stack_false.pop();
    parser_logfile << "WHILE test ':' suite else_colon_suite_opt" << std::endl;
    // node_map["WHILE"]++;
    // std::string no=std::to_string(node_map["WHILE"]);
    // std::string s="WHILE"+no;
    // //emit_dot_node(s.c_str(), "WHILE");
    // emit_dot_edge(s.c_str(), $2);
    // if($4[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $4);
    // }
    // node_map[":"]++;
    // std::string no1=std::to_string(node_map[":"]);
    // std::string s1=":"+no1;
    // //emit_dot_node(s1.c_str(), ":");
    // emit_dot_edge(s.c_str(), s1.c_str());
    // strcpy($$, s.c_str());
  }
;


for_stmt:
  FOR NAME IN NAME '(' arith_expr ')' ':' 
  {
    std::string n2 = get_sem_val($4);
    std::string n1 = get_sem_val($2);
    std::string in = get_sem_val($6);
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
    std::string n1 = get_sem_val($2);
    std::string t = new_temp(); // TODO: type checking
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
    std::string n2 = get_sem_val($4);
    std::string n1 = get_sem_val($2);
    std::string in1 = get_sem_val($6);
    std::string in2 = get_sem_val($8);
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
    std::string n1 = get_sem_val($2);
    std::string t = new_temp(); // TODO: type checking
    gen("", n1, "", t);
    gen("+", t, "1", n1);
    gen("", cond_stack.top(), "", "goto");
    gen("", ":", "", false_stack.top());
    true_stack.pop();
    loop_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    loop_stack_false.pop();
    parser_logfile << "FOR exprlist IN testlist ':' suite else_colon_suite_opt" << std::endl;
    // node_map["FOR"]++;
    // std::string no=std::to_string(node_map["FOR"]);
    // std::string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    // emit_dot_edge(s.c_str(), $2);

    // node_map["IN"]++;
    // std::string no1=std::to_string(node_map["IN"]);
    // std::string s1="IN"+no1;
    // //emit_dot_node(s1.c_str(), "IN");
    // emit_dot_edge(s.c_str(), s1.c_str());

    // node_map[":"]++;
    // std::string no2=std::to_string(node_map[":"]);
    // std::string s2=":"+no2;
    // //emit_dot_node(s2.c_str(), ":");
    // emit_dot_edge(s1.c_str(), s2.c_str());
    // emit_dot_edge(s2.c_str(), $4);
    // emit_dot_edge(s2.c_str(), $6);

    // strcpy($$, s.c_str());
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
    // node_map["ELSE"]++;
    // std::string no=std::to_string(node_map["ELSE"]);
    // std::string s="ELSE"+no;
    // node_map[":"]++;
    // std::string no1=std::to_string(node_map[":"]);
    // std::string s1=":"+no1;
    // emit_dot_edge(s1.c_str(), s.c_str());
    // emit_dot_edge(s1.c_str(), $3);
    // strcpy($$, s1.c_str());
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
    gen("", end_stack.top(), "", "goto"); 
    gen("", ":", "", false_stack.top());
    true_stack.pop();
    cond_stack.pop();
    false_stack.pop();
    parser_logfile << "| elif_test_colon_suite_list ELIF test ':' suite" << std::endl;
    // node_map["ELIF"]++;
    // std::string no=std::to_string(node_map["ELIF"]);
    // std::string s="ELIF"+no;
    // node_map[":"]++;
    // std::string no1=std::to_string(node_map[":"]);
    // std::string s1=":"+no1;
    // emit_dot_edge(s.c_str(), s1.c_str());
    // emit_dot_edge(s1.c_str(), $5);
    // emit_dot_edge(s1.c_str(), $3);
    // strcpy($$, s.c_str());
    // if($1[0] != '\0'){
    //   emit_dot_edge(s1.c_str(),$1);
    // }
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
    if($4[0]=='\0'){
      strcpy($$, $3);
    }
    else
    {
      node_map["statements"]++;
      s1 = "statements" + std::to_string(node_map["statements"]);
      emit_dot_edge(s1.c_str(), $3);
      emit_dot_edge(s1.c_str(), $4);
      strcpy($$, s1.c_str());
    }
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
    if($1[0] == '\0'){
      strcpy($$, $2);
    }
    else
    {
      node_map["statements"]++;
      s1 = "statements" + std::to_string(node_map["statements"]);
      emit_dot_edge(s1.c_str(), $1);
      emit_dot_edge(s1.c_str(), $2);
      strcpy($$, s1.c_str());
    }
  }
;

test:
  or_test if_or_test_else_test_opt
  {
    parser_logfile << "or_test if_or_test_else_test_opt" << std::endl;
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    //   {
    //     emit_dot_edge($1,$2);
    //     strcpy($$, $1);
    // }

    std::string temp = $1;
    strcpy($$, temp.c_str());
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    //   {
    //     std::string no=std::to_string(node_map["OR"]);
    //     std::string s="OR"+no;
    //     emit_dot_edge(s.c_str(), $1);
    //     strcpy($$, s.c_str());
    // }
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
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
    // node_map["OR"]++;
    // std::string no=std::to_string(node_map["OR"]);
    // std::string s="OR"+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
    }
  }
;

and_test:
  not_test and_not_test_list
  {
    parser_logfile << "not_test and_not_test_list" << std::endl;
    // if($2[0] == '\0'){
    //   strcpy($$, $1);}
    // else
    //   {
    //     std::string no=std::to_string(node_map["AND"]);
    //     std::string s="AND"+no;
    //     emit_dot_edge(s.c_str(), $1);
    //     strcpy($$, s.c_str());
    // }
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
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
    // node_map["AND"]++;
    // std::string no=std::to_string(node_map["AND"]);
    // std::string s="AND"+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    //   strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
    }
  }
;

not_test:
  NOT not_test
  {
    parser_logfile << "NOT not_test" << std::endl;
    // node_map["NOT"]++;
    // std::string no=std::to_string(node_map["NOT"]);
    // std::string s="NOT"+no;
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    
    current_operator = $1;

    std::string op = current_operator;
    std::string arg_type = get_type($2);
    if (arg_type != "bool") {
      type_err_op(op, arg_type);
    }
    
    std::string t = new_temp();
    gen(current_operator, $2, "", t);
    strcpy($$, t.c_str());

    temp_types[t] = "bool";
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    // {
    //   strcpy($$, "COMP_OP(");
    //   int len = strlen($2), i = len - 1;
    //   while((i >= 0) && (is_digit($2[i]))){
    //     $2[i] = '\0';
    //     i--;
    //   }
    //   strcat($$, $2);
    //   strcat($$, ")");
    //   node_map[$$]++;
    //   std::string no=std::to_string(node_map[$$]);
    //   std::string s=$$+no;
    //   emit_dot_edge(s.c_str(), $1);
    //   strcat($$, no.c_str());
    // }

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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
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
    // node_map[$2]++;
    // std::string s3 = "COMP_OP(";
    // std::string no=std::to_string(node_map[$2]);
    // std::string s2 = $2+no;
    // std::string s=s3 + $2 + ")" + no;
 
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s2.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "bool";
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

    // node_map["*"]++;
    // std::string no=std::to_string(node_map["*"]);
    // std::string s="*"+no;
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    
    std::string t=new_temp();
    gen("*", $2, "", t);
    strcpy($$, t.c_str());

    temp_types[t] = get_type($2);
  }
;

expr:
  xor_expr or_xor_expr_list
  {
    parser_logfile << "xor_expr or_xor_expr_list" << std::endl;
    // if($2[0] == '\0')
    //   strcpy($$, $1);
    // else
    //   {
    //     std::string no=std::to_string(node_map["|"]);
    //     std::string s="|"+no;
    //     emit_dot_edge(s.c_str(), $1);
    //     strcpy($$, s.c_str());
    //   }

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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // node_map["|"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());

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
      gen("|", $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    //   {
    //     std::string no=std::to_string(node_map["^"]);
    //     std::string s="^"+no;
    //     emit_dot_edge(s.c_str(), $1);
    //     strcpy($$, s.c_str());
    // }
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // node_map["^"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());
    
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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    //   {
    //     std::string no=std::to_string(node_map["&"]);
    //     std::string s="&"+no;
    //     emit_dot_edge(s.c_str(), $1);
    //     strcpy($$, s.c_str());
    // }
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // node_map["&"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    //   strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);}
    // else
    //   {
    //       emit_dot_edge($2, $1);
    //       strcpy($$, $2);
    //   }

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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge($2, $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge($2, $1);
    // }
    // strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = "int";
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else
    // {
    //   emit_dot_edge($2, $1);
    //   strcpy($$, $2);
    // }
    

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
      gen(current_operator , $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = max_type(arg_type1, arg_type2);
    }
    else{
      strcpy($$, $1);
    }

    // if($2[0] != '\0'){
    //   std::string t = new_temp();
    //   if(current_operator == "-"){
    //     code_stack.push({"=", "-", "", });
    //   }
    //   code_stack.push({"+", get_sem_val($1), get_sem_val($2), t});
    //   empty_code_stack();
    //   strcpy($$, t.c_str());
    // }
    // else{
    //   strcpy($$, $1);
    // }
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
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // //emit_dot_node(s.c_str(), $2);
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = max_type(arg_type1, arg_type2);
    }

    // std::string t=new_temp();
    // std::string arg1 = get_sem_val($1); 
    // code_stack.push({"+", arg1, get_sem_val($3), t});
    // 
    // std::string t2, t3, curr_temp = t;
    // if(arg1[0] == '-'){
    //   arg1 = remove_leading_minus($1);
    //   t2 = new_temp();
    //   code_stack.pop();
    //   code_stack.push({"-", arg1, "", t});
    //   code_stack.push({get_sem_val($2), t, get_sem_val($3), t2});
    //   curr_temp = "-" + t2;
    // }
    // strcpy($$, curr_temp.c_str()); 
    // if($1[0] == '\0') current_operator = $2;
  }
;

term:
  factor star_or_slash_or_percent_or_doubleslash_factor_list
  {
    parser_logfile << "factor star_or_slash_or_percent_or_doubleslash_factor_list" << std::endl;
    // if($2[0]=='\0'){
    //   strcpy($$, $1);
    // }
    // else{
    // emit_dot_edge($1, $2);
    // strcpy($$, $1);
    // }

    if($2[0] == '\0'){
      strcpy($$, $1);
    }
    else{
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = max_type(arg_type1, arg_type2);
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
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // //emit_dot_node(s.c_str(), $2);
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0]!='\0'){
    //   emit_dot_edge($1, s.c_str());}
    //   strcpy($$, s.c_str());

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
      gen($2, $1, $3, t);
      strcpy($$, t.c_str());

      temp_types[t] = max_type(arg_type1, arg_type2);
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
    
    // node_map[$1]++;
    // std::string no=std::to_string(node_map[$1]);
    // std::string s=$1+no;
    // //emit_dot_node(s.c_str(), $1);
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());

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
    gen($1, $2, "", t);
    strcpy($$, t.c_str());

    temp_types[t] = arg_type;
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
    // if($2[0]=='\0'){
    //   strcpy($$, $1);}
    // else
    //   {
    // emit_dot_edge($1, $2);
    // strcpy($$, $1);
    // }
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
      gen(current_operator, $1, $2, t);
      strcpy($$, t.c_str());

      temp_types[t] = max_type(arg_type1, arg_type2);
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
    // node_map["**"]++;
    // std::string no=std::to_string(node_map["**"]);
    // std::string s="**"+no;
    // //emit_dot_node(s.c_str(), "**");
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    
      current_operator = "**";
      strcpy($$, $2);

    // std::string t=new_temp();
    // gen("**", $2, "", t);
    // strcpy($$, t.c_str());
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
    // if($2[0] != '\0'){
    //   emit_dot_edge($1, $2);
    // }
    // strcpy($$, $1);
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

      symtable_entry entry = lookup_attr($1, std::string($2).substr(1));
      std::string t = new_temp(); //TODO  -- store size of x in self.x
      gen("", std::to_string(entry.size), "", t);
      std::string t2 = new_temp(); // TODO -- store address of x in self.x
      gen("+", "t1", t, t2);
      std::string t3 = "*" + t2;
      strcpy($$, t3.c_str());    // t3 = *(address of self.x)
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
      gen("*", index, std::to_string(entry.list_width), t);
      std::string t2 = new_temp();
      gen("=", (std::string($1) + "[" + t + "]").c_str(), "", t2);
      strcpy($$, t2.c_str());
      //strcpy($$, (std::string($1) + "[" + t + "]").c_str());

      temp_types[t] = "int";
      std::string list_type = get_type($1);
      temp_types[t2] = list_type.substr(5, list_type.size() - 6);
    }
    else if ($2[0] == '(') {
      if (is_class($1)) {
        // class constructor call
        std::string str = $2;
        std::string arglist = str.substr(1, str.length() - 2);
        std::stringstream ss(arglist);
        std::vector<std::string> tokens;
        std::string token;

        // Iterate through each token separated by ',' and store it in the vector
        while (std::getline(ss, token, ',')) {
            tokens.push_back(token);
        }

        int stack_offset = 0;
        for (const auto& t : tokens) {
            int curr_param_size;
            if (is_int_literal(t) || is_float_literal(t) || t[0] == '"') {
              curr_param_size = get_size(get_type(t));
            }
            else {
              symtable_entry sym_entry = lookup_var(t);
              std::string curr_param_type = sym_entry.type;
              curr_param_size = get_param_size(curr_param_type, t);
            }
            stack_offset += curr_param_size;
        }
        std::string t2 = new_temp(); //TODO : type checking
        gen("=", std::to_string(stack_offset), "", t2);
        gen("param", t2, "", "");
        gen("stackpointer", "+" + std::to_string(stack_offset),"" , "");
        gen("1", "allocmem", "," , "call");
        gen("stackpointer", "-" + std::to_string(stack_offset),"" , "");

        for (const auto& t : tokens) {
            int curr_param_size;
            if (is_int_literal(t) || is_float_literal(t) || t[0] == '"') {
              
            }
            else {
              symtable_entry sym_entry = lookup_var(t);
              std::string curr_param_type = sym_entry.type;
              curr_param_size = get_param_size(curr_param_type, t);
              if(curr_param_type.substr(0, 4) == "list"){
                std::string alloc_bytes = "alloc " + std::to_string(sym_entry.size); 
                std::string t1 = new_temp();
                gen("=", alloc_bytes, "", t1);
                generate_3AC_for_list_copying(t1, t);
                gen("=", t1, "", t);
                temp_types[t1] = "[" + curr_param_type + "]";
              }
            }
            gen("param", t, "", "");
        }
        
        gen("stackpointer", "+" + std::to_string(stack_offset),"" , "");
        gen(std::to_string(1 + tokens.size()), std::string($1) + ".__init__", ",", "call");
        gen("stackpointer", "-" + std::to_string(stack_offset),"" , "");

        std::string temp = new_temp();
        gen("popparam","" , "", temp);

        temp_types[temp] = $1;

        // check_method_args($1, "__init__"); // TODO
        func_args.clear();

        strcpy($$, temp.c_str());
      }
      else if (!(str == "len" || str == "range" || str == "print")) {
        // function call
        std::string str = $2;
        std::string arglist = str.substr(1, str.length() - 2);
        std::stringstream ss(arglist);
        std::vector<std::string> tokens;
        std::string token;

        // Iterate through each token separated by ',' and store it in the vector
        while (std::getline(ss, token, ',')) {
            tokens.push_back(token);
        }

        // Print the split strings
        int stack_offset = 0;
        for (const auto& t : tokens) {
            int curr_param_size;
            if (is_int_literal(t) || is_float_literal(t) || t[0] == '"') {
              curr_param_size = get_size(get_type(t));
            }
            else {
              symtable_entry sym_entry = lookup_var(t);
              std::string curr_param_type = sym_entry.type;
              curr_param_size = get_param_size(curr_param_type, t);
              if(curr_param_type.substr(0, 4) == "list"){
                std::string alloc_bytes = "alloc " + std::to_string(sym_entry.size); 
                std::string t1 = new_temp();
                gen("=", alloc_bytes, "", t1);
                generate_3AC_for_list_copying(t1, t);
                gen("=", t1, "", t);
                temp_types[t1] = "[" + curr_param_type + "]";
            }
              stack_offset += curr_param_size;
            }
            gen("param", t, "", "");
        }
        
        gen("stackpointer", "+" + std::to_string(stack_offset),"" , "");
        gen(std::to_string(tokens.size()), $1, ",", "call");
        gen("stackpointer", "-" + std::to_string(stack_offset),"" , "");

        std::string temp = new_temp();
        gen("popparam","" , "", temp);

        temp_types[temp] = get_ret_type($1);

        check_func_args($1);
        func_args.clear();

        strcpy($$, temp.c_str());
      }
      // TODO: else
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
| trailer_list trailer  // TODO, might be needed for class objects
  {
    parser_logfile << "| trailer_list trailer" << std::endl;
    // if ($1[0] == '\0') {
    //   strcpy($$, $2);
    // }
    // else {
    //   emit_dot_edge($1, $2);
    //   strcpy($$, $1);
    // }
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
    
    // node_map["()"]++;
    // std::string no=std::to_string(node_map["()"]);
    // std::string s="()"+no;
    // //emit_dot_node(s.c_str(), "()");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);
    // }
    // strcpy($$, s.c_str());
    
    if (in_var_decl) {
      yyerror(("Type error: invalid type: (" + std::string($2) + ")").c_str());
    }
    
    strcpy($$, $2);
  }
| '[' testlist_comp_opt ']'
  {
    parser_logfile << "'[' testlist_comp_opt ']'" << std::endl;

    // node_map["[]"]++;
    // std::string no=std::to_string(node_map["[]"]);
    // std::string s="[]"+no;
    // emit_dot_node(s.c_str(), "[]");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);
    // }
    // strcpy($$, s.c_str());

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

    // node_map[$1]++;
    // strcpy($$, "NAME(");
    // strcat($$, $1);
    // strcat($$, ")");
    // std::string temp = std::to_string(node_map[$1]);
    // strcat($$, temp.c_str());

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

    // strcpy($$, "INTEGER(");
    // strcat($$, $1);
    // strcat($$, ")");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());
    // //std::string t=new_temp();
    // //gen("=", $1, "", t);
    // //strcpy($$, t.c_str());

    strcpy($$, $1);

    atom_token = "INTEGER";
  }
| FLOAT_NUMBER
  {
    parser_logfile << "FLOAT_NUMBER" << std::endl;

    // strcpy($$, "FLOAT_NUMBER(");
    // strcat($$, $1);
    // strcat($$, ")");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());
    // //std::string t=new_temp();
    // //gen("=", $1, "", t);
    // //strcpy($$, t.c_str());

    strcpy($$, $1);

    atom_token = "FLOAT_NUMBER";
  }
| IMAGINARY
  {
    parser_logfile << "IMAGINARY" << std::endl;

    // strcpy($$, "IMAGINARY(");
    // strcat($$, $1);
    // strcat($$, ")");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());
    // //std::string t=new_temp();
    // //gen("=", $1, "", t);
    // //strcpy($$, t.c_str());

    strcpy($$, $1);

    atom_token = "IMAGINARY";
  }
| STRING string_list
  {
    parser_logfile << "STRING string_list" << std::endl;

    // strcpy($$, "STRING(");

    int len = strlen($1);
    //char* str = new char(len - 1);
    for(int i = 0; i < len - 1; i++){
      $1[i] = $1[i + 1];
    }
    $1[len - 2] = '\0';

    // strcat($$, $1);
    // strcat($$, ")");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());
    // if($2[0] != '\0'){
    //   emit_dot_edge($$, $2);
    // }
    
    strcpy($$, (("\"" + std::string($1) + "\"").c_str()));

    atom_token = "STRING";
  }
| NONE
  {
    parser_logfile << "NONE" << std::endl;
    
    // strcpy($$, "NONE");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());

    strcpy($$, "None");

    atom_token = "NONE";
  }
| TRUE
  {
    parser_logfile << "TRUE" << std::endl;

    // strcpy($$, "TRUE");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());

    strcpy($$, "True");

    atom_token = "TRUE";
  }
| FALSE
  {
    parser_logfile << "FALSE" << std::endl;

    // strcpy($$, "FALSE");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());

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
      std::string temp = std::to_string(node_map[$$]);
      strcat($$, temp.c_str());
      emit_dot_edge($$, $2);
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
    // if($2[0] == '\0'){
    //   strcpy($$, $1);
    // }
    // else{
    //   //emit_dot_edge($1, $2);
    //   //strcpy($$, $1);
    //   s1 = "," + std::to_string(comma_number);
    //   emit_dot_edge(s1.c_str(), $1);
    //   strcpy($$, $2);
    // }

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
    // node_map["()"]++;
    // std::string no=std::to_string(node_map["()"]);
    // std::string s="()"+no;
    // //emit_dot_node(s.c_str(), "()");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);}
    // strcpy($$, s.c_str());

    strcpy($$, ("(" + std::string($2) + ")").c_str());
  }
| '[' subscriptlist ']'
  {
    parser_logfile << "'[' subscriptlist ']'" << std::endl;
    // node_map["[]"]++;
    // std::string no=std::to_string(node_map["[]"]);
    // std::string s="[]"+no;
    // //emit_dot_node(s.c_str(), "[]");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);}
    // strcpy($$, s.c_str());

    strcpy($$, ("[" + std::string($2) + "]").c_str());
  }
| '.' NAME
  {
    parser_logfile << "'.' NAME" << std::endl;
    // node_map["."]++;
    // std::string no=std::to_string(node_map["."]);
    // std::string s="."+no;
    // //emit_dot_node(s.c_str(), ".");
    // strcpy($$, "NAME(");
    // strcat($$, $2);
    // strcat($$, ")");
    // node_map[$2]++;
    // std::string temp = std::to_string(node_map[$2]);
    // strcat($$, temp.c_str());
    // emit_dot_edge(s.c_str(),$$);
    // strcpy($$, s.c_str());
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
      emit_dot_edge($2, $1);
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
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if($1[0]!='\0'){
      emit_dot_edge(s.c_str(), $1);}
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
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
    node_map[":"]++;
    std::string no=std::to_string(node_map[":"]);
    std::string s=":"+no;
    //emit_dot_node(s.c_str(), ":");
    if($1[0]!='\0'){
      emit_dot_edge(s.c_str(), $1);
    }
    if($3[0]!='\0'){
      emit_dot_edge(s.c_str(), $3);
    }
    strcpy($$, s.c_str());
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
    // if($2[0]=='\0'){
    //   strcpy($$, $1);
    // }
    // else{
    //   emit_dot_edge($2, $1);
    //   strcpy($$, $2);
    // }
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
    // node_map[","]++;
    // std::string no=std::to_string(node_map[","]);
    // std::string s=","+no;
    // //emit_dot_node(s.c_str(), ",");
    // if($1[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
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
    // if($2[0]=='\0'){
    //   strcpy($$, $1);
    // }
    // else if($2[0]!='\0'){
    //   emit_dot_edge($2, $1);
    //   strcpy($$, $2);
    // }
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
    // node_map[","]++;
    // std::string no=std::to_string(node_map[","]);
    // std::string s=","+no;
    // //emit_dot_node(s.c_str(), ",");
    // if($1[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // emit_dot_edge(s.c_str(), $3);
    // strcpy($$, s.c_str());
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
    add_class($2);

    cur_class_symtable_ptr = gsymtable.class_symtable_ptrs[$2];
    class_scope = true;
    class_name = $2;
  }
  suite
  {
    parser_logfile << "CLASS NAME parenthesis_arglist_opt_opt ':' suite" << std::endl;
    strcpy($$, "NAME(");
    strcat($$, $2);
    strcat($$, ")");
    node_map[$2]++;
    node_map["CLASS"]++;

    s1 = "CLASS"+std::to_string(node_map["CLASS"]);
    s2 = $$+std::to_string(node_map[$$]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    node_map["()"]++;

    s1 = $$+std::to_string(node_map[$$]);
    s2 = "()"+std::to_string(node_map["()"]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    if($3[0] != '\0'){
      s1 = s2;
      s2 = $3;
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    node_map[":"]++;

    s1 = $4+std::to_string(node_map[":"]);
    s2 = "CLASS"+std::to_string(node_map["CLASS"]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    s2 = $6;
    emit_dot_edge(s1.c_str(), s2.c_str());

    strcpy($$, $4);
    std::string temp = std::to_string(node_map[":"]);
    strcat($$, temp.c_str());

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
    
    // node_map["()"]++;
    // std::string no=std::to_string(node_map["()"]);
    // std::string s="()"+no;
    // //emit_dot_node(s.c_str(), "()");
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    std::string temp = "(" + std::string($2) + ")";
    strcpy($$, temp.c_str());
  }
;

arglist:
  argument comma_argument_list comma_opt
  {
    parser_logfile << "argument comma_argument_list comma_opt" << std::endl;
    // if($2[0]=='\0'){
    //   strcpy($$, $1);}
    // else
    //   {
    //     emit_dot_edge($2, $1);
    //     strcpy($$, $2);
    //   }

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
    // if($3[0]=='\0'){
    //   strcpy($$, $1);
    // }
    // else{
    //   node_map[","]++;
    //   std::string no=std::to_string(node_map[","]);
    //   std::string s=","+no;
    //   //emit_dot_node(s.c_str(), ",");
    //   emit_dot_edge(s.c_str(), $1);
    //   emit_dot_edge(s.c_str(), $3);
    //   strcpy($$, s.c_str());
    // }
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

    // if($2[0]=='\0'){
    //   strcpy($$, $1);}
    // else{
    //   emit_dot_edge($2, $1);
    //   strcpy($$, $2);
    // }

    strcpy($$, $1);

    func_args.push_back($1);
  }
| test '=' test
  {
    parser_logfile << "test '=' test" << std::endl;
    node_map["="]++;
    std::string no=std::to_string(node_map["="]);
    std::string s=$2+no;
    //emit_dot_node(s.c_str(), "=");
    emit_dot_edge(s.c_str(), $1);
    emit_dot_edge(s.c_str(), $3);
    strcpy($$, s.c_str());
  }
| '*' test
  {
    parser_logfile << "'*' test" << std::endl;
    node_map["*"]++;
    std::string no=std::to_string(node_map["*"]);
    std::string s="*"+no;
    //emit_dot_node(s.c_str(), "*");
    emit_dot_edge(s.c_str(), $2);
    strcpy($$, s.c_str());
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
    node_map["FOR"]++;
    std::string no=std::to_string(node_map["FOR"]);
    std::string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    emit_dot_edge(s.c_str(), $2);
    node_map["IN"]++;
    std::string no1=std::to_string(node_map["IN"]);
    std::string s1="IN"+no1;
    //emit_dot_node(s1.c_str(), "IN");
    emit_dot_edge(s.c_str(), s1.c_str());
    if($5[0]!='\0'){
      emit_dot_edge(s.c_str(), $5);
    }
    emit_dot_edge(s1.c_str(), $4);
    strcpy($$, s.c_str());
  }
;

comp_if:
  IF test_nocond comp_iter_opt
  {
    parser_logfile << "IF test_nocond comp_iter_opt" << std::endl;
    node_map["IF"]++;
    std::string no=std::to_string(node_map["IF"]);
    std::string s="IF"+no;
    //emit_dot_node(s.c_str(), "IF");
    emit_dot_edge(s.c_str(), $2);
    if($3[0]!='\0'){
      emit_dot_edge(s.c_str(), $3);
    }
    strcpy($$, s.c_str());
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

// get semantic value from AST node
std::string get_sem_val(char *c_str) {
  std::string str = c_str;
  if (str.substr(0, 4) == "NONE") {
    return "None";
  }

  int start = str.find('(');
  if (start == std::string::npos) {
    return str;
  }

  int end = str.find(')');
  return str.substr(start + 1, end - start - 1);
}

// returns width for lists
int get_size(const std::string &type) {
  if (type == "bool") {
    return 1;
  }

  if(type == "int"){
    return 4;
  }

  if(type == "float"){
    return 4;
  }

  if(type == "double"){
    return 8;
  }
  
  if (type == "str") {
    // TODO
    return 0;
  }

  if (type.substr(0, 4) == "list") {
    return get_size(type.substr(5, type.size() - 6));
  }

  return 4;
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

void gen(std::string s) {
  ac3_code.push_back({s});
  // print_curr_3ac_instr(ac3_code.back());
}

void gen(std::string s1, int new_ln) {
  if(new_ln==0)
  {
    ac3_code[ac3_code.size()-1].push_back(s1);
    return;
  }
  ac3_code.push_back({s1, s2});
  // print_curr_3ac_instr(line_code);
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
    std::string temp =  "t" + std::to_string(temp_count - 1) + "[" + std::to_string(prev) + "]";
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
    return get_ret_type(str);
  }

  if (is_class(str)) {
    return str;
  }

  if (temp_types.find(str) != temp_types.end()) {
    return temp_types[str];
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

  int num_params = func_symtable_ptr->param_types.size();
  if (num_args != num_params) {
    yyerror(("Type error: " + name + "() takes " + std::to_string(num_params) + " positional arguments but " + std::to_string(num_args) + " were given").c_str());
  }

  for (int i = 0; i < num_params; i++) {
    std::string arg_type = get_type(func_args[i]);
    std::string param_type = func_symtable_ptr->param_types[i];
    if (arg_type != param_type) {
      yyerror(("Type mismatch in call to " + name + "(): " + param_type + " required but " + arg_type + " was passed").c_str());
    }
  }
}

void check_method_args(const std::string &class_name, const std::string &method_name) {
  local_symtable *func_symtable_ptr = lookup_method(class_name, method_name);
  int num_args = func_args.size();

  int num_params = func_symtable_ptr->param_types.size();
  if (num_args != num_params) {
    yyerror(("Type error: " + class_name + "." + method_name + "() takes " + std::to_string(num_params) + " positional arguments but " + std::to_string(num_args) + " were given").c_str());
  }

  for (int i = 0; i < num_params; i++) {
    std::string arg_type = get_type(func_args[i]);
    std::string param_type = func_symtable_ptr->param_types[i];
    if (arg_type != param_type) {
      yyerror(("Type mismatch in call to " + class_name + "." + method_name + "(): " + param_type + " required but " + arg_type + " was passed").c_str());
    }
  }
}

std::string get_curr_param_name(char* param_list){
  std::string curr_param_name; 
  int i = start_pos;
  while(i < strlen(param_list)){
    if(param_list[i] == ':') break;
    curr_param_name += param_list[i];
    i++;
  }
  while(i < strlen(param_list)){
    if(param_list[i] == ',') break;
    i++;
  }
  start_pos = i + 1;
  return curr_param_name;
}

int get_param_size(std::string datatype, std::string var_name){
    symtable_entry sym_entry = lookup_var(var_name);
    std::string temp = datatype.substr(0, 4);
    if(temp == "list"){
      return 4;
    }
    else{
      return sym_entry.size;
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

std::string get_ret_type(const std::string &name) {
  return lookup_func(name)->return_type;
}

bool is_class(const std::string &name) {
  return gsymtable.class_symtable_ptrs.find(name) != gsymtable.class_symtable_ptrs.end();
}

void generate_3AC_for_list_copying(std::string dest, std::string src){
    symtable_entry sym_entry = lookup_var(src);
    int len = sym_entry.list_len;
    int width = sym_entry.list_width;
    if(sym_entry.type == "list[str]") width = 1, len = sym_entry.size;
    int curr_pos = 0;
    for(int i = 0; i < len; i++){
      gen("=", src + "[" + std::to_string(curr_pos) + "]", "", dest + "[" + std::to_string(curr_pos) + "]");
      curr_pos += width;
    }
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
