#include <string>
#include <vector>
#include "codegen.h"

extern std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)

std::vector<std::string> x86_code;

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
    // result = arg1
  }
  else if (result == "goto") {
    // goto arg1
  }
  else if (arg1 == "goto") {
    // result op goto arg2
  }
  else if (arg1 == ":" && op.empty()) {
    // result:
  }
  else if (result == "beginfunc" || result == "endfunc") {
    // beginfunc | endfunc
  }
  else if (op == "push") {
    // push arg1
  }
  else if (op == "return") {
    // return
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
