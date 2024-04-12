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
}
