#include <string>
#include <vector>
#include "codegen.h"
#include "symtable.h"
#include "utils.h"

extern std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)

std::vector<std::string> x86_code;

std::string cur_label;

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

  if (op == "=") {
    if (arg1 == "popparam") {
      // result = popparam
    }
    else {
      // result = arg1
      std::string arg1_addr = get_addr(arg1);
      std::string result_addr = get_addr(result);

      x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
      x86_code.push_back("\tmovl\t%eax, " + result_addr);
    }
  }
  else if (result == "goto") {
    // goto arg1
    x86_code.push_back("\tjmp\t" + arg1);
  }
  else if (arg1 == "goto") {
    // result op goto arg2
  }
  else if (arg1 == ":" && op.empty()) {
    // result:
    cur_label = result;

    x86_code.push_back(result + ":");
  }
  else if (result == "beginfunc") {
    // beginfunc
    func_scope = true;
    cur_func_symtable_ptr = lookup_func(cur_label);

    x86_code.push_back("\tpushq\t%rbp");
    x86_code.push_back("\tmovq\t%rsp, %rbp");
  }
  else if (result == "endfunc") {
    // endfunc
    func_scope = false;
  }
  else if (op == "push") {
    // push arg1
    std::string arg1_addr = get_addr(arg1);

    x86_code.push_back("\tmovl\t" + arg1_addr + ", " + "%eax");
  }
  else if (op == "return") {
    // return
    x86_code.push_back("\tleave");
    x86_code.push_back("\tret");
  }
  else if (op.substr(0, 8) == "popparam") {
    // result = popparam
  }
  else if (op == "stackpointer") {
    // stackpointer arg1
  }
  else if (op.substr(0, 5) == "param") {
    // param arg1
  }
  else if (result == "call") {
    // call arg1 arg2 op
  }
  else if (op.empty() && arg2.empty()) {
    // result = arg1
  }
  else if (arg2.empty()) {
    // result = op arg1
  }
  else {
    // result = arg1 op arg2
  }
}

std::string get_addr(const std::string &name) {
  if (is_int_literal(name)) {
    return "$" + name;
  }

  int offset = lookup_var(name).offset;
  return "-" + std::to_string(4 + offset) + "(%rbp)";
}
