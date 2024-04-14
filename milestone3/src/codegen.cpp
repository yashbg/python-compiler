#include <string>
#include <vector>
#include <stack>
#include "codegen.h"
#include "symtable.h"
#include "utils.h"

extern std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)

std::vector<std::string> x86_code;
std::vector<std::string> arg_regs = {"%edi", "%esi", "%edx", "%ecx", "%r8d", "%r9d"};

std::string cur_label;

std::stack<std::string> arg_stack;

void gen_x86_code() {
  for (const auto &ac3_line : ac3_code) {
    gen_x86_line_code(ac3_line);
  }
}

void gen_x86_line_code(const std::vector<std::string> &ac3_line) {
  std::string op = ac3_line[0];
  std::string arg1 = ac3_line[1];
  std::string arg2 = ac3_line[2];
  std::string result = ac3_line[3];

  if (op == "=" && arg1 != "popparam") {
    // result = arg1
    std::string arg1_addr = get_addr(arg1);
    std::string result_addr = get_addr(result);

    x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
    x86_code.push_back("\tmovl\t%eax, " + result_addr);
    return;
  }

  if (result == "goto") {
    // goto arg1
    x86_code.push_back("\tjmp\t" + arg1);
    return;
  }

  if (arg1 == "goto") {
    // result op goto arg2
    return;
  }
  
  if (arg1 == ":" && op.empty()) {
    // result:
    cur_label = result;

    x86_code.push_back(result + ":");
    return;
  }
  
  if (result == "beginfunc") {
    // beginfunc
    func_scope = true;
    std::string func_name = cur_label;
    cur_func_symtable_ptr = lookup_func(func_name);

    x86_code.push_back("\tpushq\t%rbp");
    x86_code.push_back("\tmovq\t%rsp, %rbp");

    int offset = align_offset(cur_func_symtable_ptr->offset);
    if (offset) {
      x86_code.push_back("\tsubq\t$" + std::to_string(offset) + ", %rsp");
    }

    store_args(func_name);
    return;
  }
  
  if (result == "endfunc") {
    // endfunc
    func_scope = false;
    return;
  }
  
  if (op == "push") {
    // push arg1
    std::string arg1_addr = get_addr(arg1);

    x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
    return;
  }
  
  if (op == "return") {
    // return
    x86_code.push_back("\tleave");
    x86_code.push_back("\tret");
    return;
  }
  
  if (op == "popparam") {
    // result = popparam
    x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
    return;
  }
  
  if (op == "param") {
    // param arg1
    arg_stack.push(arg1);
    return;
  }
  
  if (result == "call") {
    // call arg1, op
    int num_args = std::stoi(op);
    pass_args(num_args);

    x86_code.push_back("\tcall\t" + arg1);

    int num_regs = arg_regs.size();
    if (num_args > num_regs) {
      int size = 8 * (num_args - num_regs);
      x86_code.push_back("\taddq\t$" + std::to_string(size) + ", %rsp");
    }

    return;
  }
  
  if (arg2.empty()) {
    // result = op arg1
    if(op == "-"){
      x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
      x86_code.push_back("\tnegl\t%eax");
      x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      return;
    }
    if(op == "not"){
      x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
      x86_code.push_back("\tcmpl\t$0, %eax");
      x86_code.push_back("\tsete\t%al");
      x86_code.push_back("\tmovzbl\t%al, %eax");
      x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      return;
    }
    if(op == "~"){
      x86_code.push_back("\tmovl\t" + get_addr(arg1) + ", %eax");
      x86_code.push_back("\tnotl\t%eax");
      x86_code.push_back("\tmovl\t%eax, " + get_addr(result));
      return;
    }
    return;
  }

  // result = arg1 op arg2
}

std::string get_addr(const std::string &name) {
  if (is_int_literal(name)) {
    return "$" + name;
  }
  if(name == "True"){
    return "$1";
  }
  if(name == "False"){
    return "$0";
  }
  return "";
  // symtable_entry entry = lookup_var(name);
  // int offset = entry.offset + entry.size;
  // return "-" + std::to_string(offset) + "(%rbp)";
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
  int num_regs = arg_regs.size();
  for (int i = 0; i < num_args; i++) {
    std::string param = func_symtable_ptr->params[i].first;
    if (i < num_regs) {
      x86_code.push_back("\tmovl\t" + arg_regs[i] + ", " + get_addr(param));
      continue;
    }

    int offset = 16 + 8 * (i - num_regs);
    x86_code.push_back("\tmovl\t" + std::to_string(offset) + "(%rbp), " + get_addr(param));
  }
}

void pass_args(int num_args) {
  int num_regs = arg_regs.size();
  if (num_args > num_regs) {
    for (int i = 0; i < num_args - num_regs; i++) {
      std::string arg = arg_stack.top();
      x86_code.push_back("\tpushq\t" + get_addr(arg));
      arg_stack.pop();
    }

    num_args = num_regs;
  }
  
  for (int i = 0; i < num_args; i++) {
    std::string arg = arg_stack.top();
    std::string arg_reg = arg_regs[num_regs - i - 1];
    x86_code.push_back("\tmovl\t" + get_addr(arg) + ", " + arg_reg);
    arg_stack.pop();
  }
}
