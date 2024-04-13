#include <string>
#include "utils.h"

int is_digit(char c) {
  return c >= '0' && c <= '9';
}

bool is_int_literal(const std::string &str) {
  for (auto c : str) {
    if (!is_digit(c)) {
      return false;
    }
  }

  return true;
}
