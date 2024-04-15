#pragma once

#include <string>
#include <vector>
#include <unordered_map>

struct symtable_entry {
  std::string type;
  int lineno; // TODO
  int size;
  int list_len;
  int list_width;
  int offset;
};

struct local_symtable {
  std::vector<std::pair<std::string, std::string>> params; // (name, type)
  std::string return_type;
  std::unordered_map<std::string, symtable_entry> var_entries; // identifier -> symtable_entry
  int lineno; // TODO
  int offset = 0;
};

struct class_symtable {
  class_symtable *parent_symtable_ptr;
  std::unordered_map<std::string, symtable_entry> attr_entries; // identifier -> symtable_entry
  std::unordered_map<std::string, local_symtable *> method_symtable_ptrs; // identifier -> local_symtable *
  int offset = 0;
};

// TODO: add keywords
struct global_symtable {
  std::unordered_map<std::string, symtable_entry> var_entries; // identifier -> symtable_entry
  std::unordered_map<std::string, local_symtable *> func_symtable_ptrs; // identifier -> local_symtable *
  std::unordered_map<std::string, class_symtable *> class_symtable_ptrs; // identifier -> class_symtable *
  int offset = 0;
};

extern global_symtable gsymtable;
extern local_symtable *cur_func_symtable_ptr;
extern class_symtable *cur_class_symtable_ptr;
extern bool func_scope;
extern bool class_scope;

void insert_var(const std::string &name, const std::string &type);
symtable_entry lookup_var(const std::string &name);

void insert_attr(const std::string &name, const std::string &type);
symtable_entry lookup_attr(const std::string &class_name, const std::string &attr_name);

void check_redecl(const std::string &name);

void add_func(const std::string &name, const std::vector<std::pair<std::string, std::string>> &params, const std::string &return_type, int lineno);
local_symtable * lookup_func(const std::string &name);

void add_class(const std::string &name, class_symtable *parent_symtable_ptr);
class_symtable * lookup_class(const std::string &name);
local_symtable * lookup_method(const std::string &class_name, const std::string &method_name);

int get_class_size(const std::string &name);
bool is_func(const std::string &name);
