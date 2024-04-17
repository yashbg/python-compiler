#include <string>
#include <vector>
#include <stack>
#include "codegen.h"
#include "symtable.h"
#include "utils.h"

extern std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)

extern std::string get_3ac_str(const std::vector<std::string> &ac3_line);
extern std::string get_type(const std::string &str);
extern int get_size(const std::string &type);

std::vector<std::string> x86_code;
std::vector<std::string> long_arg_regs = {"%edi", "%esi", "%edx", "%ecx", "%r8d", "%r9d"};
std::vector<std::string> quad_arg_regs = {"%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"};
std::vector<std::string> byte_arg_regs = {"%dil", "%sil", "%dl", "%cl", "%r8b", "%r9b"};

std::string cur_label;
std::string cur_func_name;

std::stack<std::string> arg_stack;

void gen_x86_code() {
  x86_code.push_back("\t.section\t.rodata");

  for (auto &label : str_literal_labels) {
    x86_code.push_back(label.second + ":");
    x86_code.push_back("\t.string\t" + label.first);
  }

  x86_code.push_back("");

  x86_code.push_back("\t.text");
  x86_code.push_back("");
  for (const auto &ac3_line : ac3_code) {
    gen_x86_line_code(ac3_line);
  }
}

void gen_x86_line_code(const std::vector<std::string> &ac3_line) {
  std::string op = ac3_line[0];
  std::string arg1 = ac3_line[1];
  std::string arg2 = ac3_line[2];
  std::string result = ac3_line[3];

  if (op == "=") {
    // result = arg1
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    std::string arg1_addr = get_addr(arg1);
    std::string result_addr = get_addr(result);

    int size = get_size(get_type(result));
    if (size == 8) {
      x86_code.push_back("\tmovq\t" + arg1_addr + ", " + "%rax");
      x86_code.push_back("\tmovq\t%rax, " + result_addr);
      x86_code.push_back("");
      return;
    }
    if (size == 1) {
      x86_code.push_back("\tmovb\t" + arg1_addr + ", " + "%al");
      x86_code.push_back("\tmovb\t%al, " + result_addr);
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
    x86_code.push_back("\tmovl\t%eax, " + result_addr);
    x86_code.push_back("");
    return;
  }

  if (result == "goto") {
    // goto arg1
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tjmp\t" + arg1);
    x86_code.push_back("");
    return;
  }

  if (arg1 == "goto") {
    // if op goto arg2
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    int operator_pos = op.find("<");
    if(operator_pos != std::string::npos){
      std::string lhs = op.substr(0, operator_pos);
      std::string rhs = op.substr(operator_pos + 1);
      x86_code.push_back("\tmovl\t" + get_addr(lhs) + ", %eax");
      x86_code.push_back("\tcmpl\t" + get_addr(rhs) + ", %eax");
      x86_code.push_back("\tjl\t" + arg2);
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovb\t" + get_addr(op) + ", %al");
    x86_code.push_back("\tcmpb\t$0, %al");
    x86_code.push_back("\tjg\t" + arg2);
    x86_code.push_back("");
    return;
  }
  
  if (arg1 == ":" && op.empty()) {
    // result:
    cur_label = result;

    bool func = false;
    int dot = result.find('.');
    if (dot != std::string::npos) {
      std::string class_name = result.substr(0, dot);
      if (is_class(class_name)) {
        func = true;
      }
    }

    if (func || is_func(result)) {
      cur_func_name = result;
      
      x86_code.push_back("\t.globl\t" + result);
      x86_code.push_back("\t.type\t" + result + ", @function");
    }

    x86_code.push_back(result + ":");
    return;
  }
  
  if (result == "beginfunc") {
    // beginfunc
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    func_scope = true;
    std::string func_name = cur_label;
    cur_func_symtable_ptr = lookup_func(func_name);

    int dot = func_name.find('.');
    if (dot != std::string::npos) {
      std::string str = func_name.substr(0, dot);
      if (is_class(str)) {
        class_name = str;
        class_scope = true;
        cur_class_symtable_ptr = lookup_class(class_name);
      }
    }

    x86_code.push_back("\tpushq\t%rbp");
    x86_code.push_back("\tmovq\t%rsp, %rbp");

    int offset = align_offset(cur_func_symtable_ptr->offset);
    if (offset) {
      x86_code.push_back("\tsubq\t$" + std::to_string(offset) + ", %rsp");
    }

    store_args(func_name);
    x86_code.push_back("");
    return;
  }
  
  if (result == "endfunc") {
    // endfunc
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    func_scope = false;
    class_scope = false;

    x86_code.push_back("\t.size\t" + cur_func_name + ", .-" + cur_func_name);
    x86_code.push_back("");

    cur_func_name.clear();
    return;
  }
  
  if (op == "push") {
    // push arg1
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    std::string arg1_addr = get_addr(arg1);

    int size = get_size(get_type(arg1));
    if (size == 8) {
      x86_code.push_back("\tmovq\t" + arg1_addr + ", " + "%rax");
      x86_code.push_back("");
      return;
    }

    if (size == 1) {
      x86_code.push_back("\tmovb\t" + arg1_addr + ", " + "%al");
      x86_code.push_back("");
      return;
    }

    x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
    x86_code.push_back("");
    return;
  }
  
  if (op == "return") {
    // return
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tleave");
    x86_code.push_back("\tret");
    x86_code.push_back("");
    return;
  }
  
  if (op == "popparam" && arg1 == "return_val") {
    // result = popparam
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));

    int size = get_size(get_type(result));
    if (size == 8) {
      x86_code.push_back("\tmovq\t%rax, " + get_addr(result));
      x86_code.push_back("");
      return;
    }

    if (size == 1) {
      x86_code.push_back("\tmovb\t%al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }

    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  
  if (op == "param") {
    // param arg1
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));

    arg_stack.push(arg1);
    return;
  }
  
  if (result == "call") {
    // call arg1, op
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));

    if (arg1 == "print") {
      std::string arg = arg_stack.top();

      if (get_type(arg) == "str") {
        arg1 = "puts@PLT";
        
        x86_code.push_back("\tmovq\t" + get_addr(arg) + ", %rdi");
      }
      else if (get_type(arg) == "bool") {
        arg1 = "puts@PLT";
        
        if(arg == "0") x86_code.push_back("\tmovq\t$" + str_literal_labels["\"True\""] + ", %rdi");
        else x86_code.push_back("\tmovq\t$" + str_literal_labels["\"False\""] + ", %rdi");
      }
      else {
        arg1 = "printf@PLT";
        
        x86_code.push_back("\tmovl\t" + get_addr(arg) + ", %esi");
        x86_code.push_back("\tmovq\t$" + str_literal_labels["\"%d\\n\""] + ", %rdi");
        x86_code.push_back("\tmovl\t$0, %eax");
      }

      arg_stack.pop();

      x86_code.push_back("\tcall\t" + arg1);
      x86_code.push_back("");
      return;
    }

    if (arg1 == "allocmem") {
      arg1 = "malloc@PLT";
    }

    int num_args = std::stoi(op);
    pass_args(num_args);

    x86_code.push_back("\tcall\t" + arg1);

    int num_regs = long_arg_regs.size();
    if (num_args > num_regs) {
      int size = 8 * (num_args - num_regs);
      x86_code.push_back("\taddq\t$" + std::to_string(size) + ", %rsp");
    }

    x86_code.push_back("");
    return;
  }
  
  if (arg2.empty()) {
    // result = op arg1
    if(op == "-"){
      x86_code.push_back("\t# " + get_3ac_str(ac3_line));
      x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
      x86_code.push_back("\tnegl\t%eax");
      x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    if(op == "not"){
      x86_code.push_back("\t# " + get_3ac_str(ac3_line));
      x86_code.push_back("\tmovb\t" + get_addr(arg1) + ", %al");
      x86_code.push_back("\tcmpb\t$0, %al");
      x86_code.push_back("\tsete\t%al");
      x86_code.push_back("\tmovb\t%al, " + get_addr(result));
      // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    if(op == "~"){
      x86_code.push_back("\t# " + get_3ac_str(ac3_line));
      x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
      x86_code.push_back("\tnotl\t%eax");
      x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    return;
  }

  // result = arg1 op arg2
  if(op == "+"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\taddl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "-"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tsubl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "*"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\timull\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "/"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %ebx");
    x86_code.push_back("\tcltd");
    x86_code.push_back("\tidivl\t%ebx");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "**"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t$1 , %eax");
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %edx");
    std::string newlabel1 = new_label();
    x86_code.push_back(newlabel1 + ":");
    x86_code.push_back("\tcmpl\t$0, %edx");
    std::string newlabel2 = new_label();
    x86_code.push_back("\tje\t" + newlabel2);
    x86_code.push_back("\timull\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tdecl\t%edx");
    x86_code.push_back("\tjmp\t" + newlabel1);
    x86_code.push_back(newlabel2 + ":");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "%"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %ebx");
    x86_code.push_back("\tcltd");
    x86_code.push_back("\tidivl\t%ebx");
    x86_code.push_back("\tmovl\t%edx, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "&"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tandl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "|"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\torl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "^"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\txorl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "and"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    std::string newlabel1 = new_label();
    x86_code.push_back("\tcmpb\t$0, " + get_addr(arg1));
    x86_code.push_back("\tje\t" + newlabel1);
    x86_code.push_back("\tcmpb\t$0, " + get_addr(arg2)); 
    x86_code.push_back("\tje\t" + newlabel1);
    x86_code.push_back("\tmovl\t$1, %eax");
    std::string newlabel2 = new_label();
    x86_code.push_back("\tjmp\t" + newlabel2);
    x86_code.push_back(newlabel1 + ":");
    x86_code.push_back("\tmovl\t$0, %eax");
    x86_code.push_back(newlabel2 + ":");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "or"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    std::string newlabel1 = new_label();
    x86_code.push_back("\tcmpb\t$0, " + get_addr(arg1));
    x86_code.push_back("\tjne\t" + newlabel1);
    x86_code.push_back("\tcmpb\t$0, " + get_addr(arg2)); 
    std::string newlabel2 = new_label();
    x86_code.push_back("\tje\t" + newlabel2);
    x86_code.push_back(newlabel1 + ":");
    x86_code.push_back("\tmovl\t$1, %eax");
    std::string newlabel3 = new_label();
    x86_code.push_back("\tjmp\t" + newlabel3);
    x86_code.push_back(newlabel2 + ":");
    x86_code.push_back("\tmovl\t$0, %eax");
    x86_code.push_back(newlabel3 + ":");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "=="){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tmovq\t" + get_addr(arg1) + ", %rax");
      x86_code.push_back("\tmovq\t" + get_addr(arg2) + ", %rdx");
      x86_code.push_back("\tcmpq\t%rdx, %rax");
      x86_code.push_back("\tsete\t%al");
      x86_code.push_back("\tmovb\t%al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsete\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "!="){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tmovq\t" + get_addr(arg1) + ", %rax");
      x86_code.push_back("\tmovq\t" + get_addr(arg2) + ", %rdx");
      x86_code.push_back("\tcmpq\t%rdx, %rax");
      x86_code.push_back("\tsetne\t%al");
      x86_code.push_back("\tmovb\t%al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsetne\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovzbl\t%al, %eax");
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "<"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tleaq\t" + get_addr(arg1) + ", %rdx");
      x86_code.push_back("\tleaq\t" + get_addr(arg2) + ", %rax");
      x86_code.push_back("\tmovq\t%rax, %rsi");
      x86_code.push_back("\tmovq\t%rdx, %rdi");
      x86_code.push_back("\tcall\tstrcmp@PLT");
      x86_code.push_back("\ttestl\t %eax, %eax");
      x86_code.push_back("\tsetl\t %al");
      x86_code.push_back("\tmovb\t %al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsetl\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovzbl\t%al, %eax");
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    // x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == ">"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tleaq\t" + get_addr(arg1) + ", %rdx");
      x86_code.push_back("\tleaq\t" + get_addr(arg2) + ", %rax");
      x86_code.push_back("\tmovq\t%rax, %rsi");
      x86_code.push_back("\tmovq\t%rdx, %rdi");
      x86_code.push_back("\tcall\t strcmp@PLT");
      x86_code.push_back("\ttestl\t %eax, %eax");
      x86_code.push_back("\tsetg\t %al");
      x86_code.push_back("\tmovb\t %al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsetg\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovzbl\t%al, %eax");
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    // x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "<="){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tleaq\t" + get_addr(arg1) + ", %rdx");
      x86_code.push_back("\tleaq\t" + get_addr(arg2) + ", %rax");
      x86_code.push_back("\tmovq\t%rax, %rsi");
      x86_code.push_back("\tmovq\t%rdx, %rdi");
      x86_code.push_back("\tcall\t strcmp@PLT");
      x86_code.push_back("\ttestl\t %eax, %eax");
      x86_code.push_back("\tsetle\t %al");
      x86_code.push_back("\tmovb\t %al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsetle\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovzbl\t%al, %eax");
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    // x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == ">="){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    if(get_type(arg1) == "str"){
      x86_code.push_back("\tleaq\t" + get_addr(arg1) + ", %rdx");
      x86_code.push_back("\tleaq\t" + get_addr(arg2) + ", %rax");
      x86_code.push_back("\tmovq\t%rax, %rsi");
      x86_code.push_back("\tmovq\t%rdx, %rdi");
      x86_code.push_back("\tcall\t strcmp@PLT");
      x86_code.push_back("\ttestl\t %eax, %eax");
      x86_code.push_back("\tsetge\t %al");
      x86_code.push_back("\tmovb\t %al, " + get_addr(result));
      x86_code.push_back("");
      return;
    }
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tcmpl\t" + get_addr(arg2) + ", %eax");
    x86_code.push_back("\tsetge\t%al");
    x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    // x86_code.push_back("\tmovzbl\t%al, %eax");
    // x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    // x86_code.push_back("\tmovb\t%al, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "<<"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %eax"); 
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %edx");
    x86_code.push_back("\tmovl\t%eax, %ecx");
    x86_code.push_back("\tsall\t%cl, %edx");
    x86_code.push_back("\tmovl\t%edx, %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == ">>"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %eax"); 
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %edx");
    x86_code.push_back("\tmovl\t%eax, %ecx");
    x86_code.push_back("\tsarl\t%cl, %edx");
    x86_code.push_back("\tmovl\t%edx, %eax");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
  if(op == "//"){
    x86_code.push_back("\t# " + get_3ac_str(ac3_line));
    x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
    x86_code.push_back("\tmovl\t" + get_addr(arg2) + ", %ebx");
    x86_code.push_back("\tcltd");
    x86_code.push_back("\tidivl\t%ebx");
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    x86_code.push_back("");
    return;
  }
}

std::string get_addr(const std::string &name) {
  if (is_int_literal(name)) {
    return "$" + name;
  }

  if (name == "True") {
    return "$1";
  }

  if (name == "False") {
    return "$0";
  }

  if (name[0] == '"') {
    return "$" + str_literal_labels[name];
  }

  int brace = name.find('[');
  if (brace != std::string::npos) {
    // array access
    std::string arr = name.substr(0, brace);
    std::string offset = name.substr(brace + 1, name.size() - brace - 2);
    std::string arr_addr = get_addr(arr);
    if (is_int_literal(offset)) {
      x86_code.push_back("\tmovq\t" + arr_addr + ", %r10");
      x86_code.push_back("\tleaq\t" + offset + "(%r10), %r11");
      x86_code.push_back("");
      return "(%r11)";
    }

    std::string offset_addr = get_addr(offset);
    x86_code.push_back("\tmovl\t" + offset_addr + ", %r10d");
    x86_code.push_back("\tmovslq %r10d, %r10");
    x86_code.push_back("\tmovq\t%r10, %r11");
    x86_code.push_back("\tmovq\t" + arr_addr + ", %r10");
    x86_code.push_back("\taddq\t%r10, %r11");
    x86_code.push_back("");
    return "(%r11)";
  }

  int dot = name.find('.');
  if (dot != std::string::npos) {
    // object attribute access
    std::string obj = name.substr(0, dot);
    std::string attr = name.substr(dot + 1);
    std::string obj_addr = get_addr(obj);

    std::string class_name = lookup_var(obj).type;
    int offset = lookup_attr(class_name, attr).offset;

    x86_code.push_back("\tmovq\t" + obj_addr + ", %r10");
    x86_code.push_back("\tleaq\t" + std::to_string(offset) + "(%r10), %r11");
    x86_code.push_back("");
    return "(%r11)";
  }
  
  symtable_entry entry = lookup_var(name);
  int offset = entry.offset + entry.size;
  return "-" + std::to_string(offset) + "(%rbp)";
}

int align_offset(int offset) {
  int rem = offset % 16;
  if (rem) {
    offset += 16 - rem;
  }

  return offset;
}

void store_args(const std::string &func_name) {
  local_symtable *func_symtable_ptr = lookup_func(func_name);
  int num_args = func_symtable_ptr->params.size();
  int num_regs = long_arg_regs.size();
  for (int i = 0; i < num_args; i++) {
    std::string param = func_symtable_ptr->params[i].first;
    int size = get_size(get_type(param));
    if (i < num_regs) {
      if (size == 8) {
        x86_code.push_back("\tmovq\t" + quad_arg_regs[i] + ", " + get_addr(param));
        continue;
      }
      if (size == 1) {
        x86_code.push_back("\tmovb\t" + byte_arg_regs[i] + ", " + get_addr(param));
        continue;
      }
      x86_code.push_back("\tmovl\t" + long_arg_regs[i] + ", " + get_addr(param));
      continue;
    }

    int offset = 16 + 8 * (i - num_regs);
    if (size == 8) {
      x86_code.push_back("\tmovq\t" + std::to_string(offset) + "(%rbp), " + get_addr(param));
      continue;
    }
    if (size == 1) {
      x86_code.push_back("\tmovb\t" + std::to_string(offset) + "(%rbp), " + get_addr(param));
      continue;
    }
    x86_code.push_back("\tmovl\t" + std::to_string(offset) + "(%rbp), " + get_addr(param));
  }
}

void pass_args(int num_args) {
  int num_regs = long_arg_regs.size();
  if (num_args > num_regs) {
    // TODO: stack frame alignment?
    for (int i = 0; i < num_args - num_regs; i++) {
      std::string arg = arg_stack.top();
      x86_code.push_back("\tpushq\t" + get_addr(arg));
      arg_stack.pop();
    }

    num_args = num_regs;
  }

  for (int i = 0; i < num_args; i++) {
    std::string arg = arg_stack.top();

    int size = get_size(get_type(arg));
    if (size == 8) {
      std::string arg_reg = quad_arg_regs[num_args - i - 1];
      x86_code.push_back("\tmovq\t" + get_addr(arg) + ", " + arg_reg);
      arg_stack.pop();
      continue;
    }
    if (size == 1) {
      std::string arg_reg = byte_arg_regs[num_args - i - 1];
      x86_code.push_back("\tmovb\t" + get_addr(arg) + ", " + arg_reg);
      arg_stack.pop();
      continue;
    }
    std::string arg_reg = long_arg_regs[num_args - i - 1];
    x86_code.push_back("\tmovl\t" + get_addr(arg) + ", " + arg_reg);
    arg_stack.pop();
  }
}
