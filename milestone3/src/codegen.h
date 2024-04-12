#pragma once

#include <string>
#include <vector>

extern std::vector<std::string> x86_code;

void gen_x86_code();
void gen_x86_line_code(const std::vector<std::string> &ac3_line);
