#pragma once

#include <string>
#include <vector>

extern std::vector<std::string> x86_code;

void gen_x86_code();
void gen_x86_line_code(const std::vector<std::string> &ac3_line);

std::string get_addr(const std::string &name);
int align_offset(int offset);
void store_args(const std::string &func_name);
