#pragma once

#include <string>
#include <vector>
#include <unordered_map>

struct symtable_entry {
  std::string type;
  std::string src_file;
  int lineno;
  int size;
  int offset;
};

struct local_symtable {
  std::vector<std::string> param_types;
  std::string return_type;
  std::unordered_map<std::string, symtable_entry> var_entries; // identifier -> symtable_entry
};

struct global_symtable {
  std::unordered_map<std::string, symtable_entry> var_entries; // identifier -> symtable_entry
  std::unordered_map<std::string, local_symtable *> func_symtable_ptrs; // identifier -> local_symtable *
};

symtable_entry &lookup(const std::string &name);
void insert(const std::string &name, const symtable_entry &entry);
