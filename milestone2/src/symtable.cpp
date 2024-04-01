#include <string>
#include <vector>
#include <unordered_map>
#include <utility>
#include "symtable.h"

extern int yylineno;

extern bool func_scope;
extern bool class_scope;
extern global_symtable gsymtable;
extern local_symtable *cur_func_symtable_ptr;
extern class_symtable *cur_class_symtable_ptr;

extern void yyerror(const char *);

extern int get_size(const std::string &type);

void insert_var(const std::string &name, const symtable_entry &entry) {
  // TODO: handle redeclarations
  if (func_scope) {
    cur_func_symtable_ptr->var_entries[name] = entry;
    return;
  }

  if (class_scope) {
    cur_class_symtable_ptr->attr_entries[name] = entry;
    return;
  }

  gsymtable.var_entries[name] = entry;
}

symtable_entry lookup_var(const std::string &name) {
  if (func_scope) {
    auto entry_itr = cur_func_symtable_ptr->var_entries.find(name);
    if (entry_itr != cur_func_symtable_ptr->var_entries.end()) {
      return entry_itr->second;
    }
  }

  if (class_scope) {
    auto entry_itr = cur_class_symtable_ptr->attr_entries.find(name);
    if (entry_itr != cur_class_symtable_ptr->attr_entries.end()) {
      return entry_itr->second;
    }
  }

  auto entry_itr = gsymtable.var_entries.find(name);
  if (entry_itr != gsymtable.var_entries.end()) {
    return entry_itr->second;
  }

  yyerror(("Name error: name '" + name + "' is not defined").c_str());
  return entry_itr->second;
}

void check_redecl(const std::string &name) {
  if (func_scope) {
    auto entry_itr = cur_func_symtable_ptr->var_entries.find(name);
    if (entry_itr != cur_func_symtable_ptr->var_entries.end()) {
      yyerror(("Name error: name '" + name + "' is redeclared").c_str());
      return;
    }
  }

  if (class_scope) {
    auto entry_itr = cur_class_symtable_ptr->attr_entries.find(name);
    if (entry_itr != cur_class_symtable_ptr->attr_entries.end()) {
      yyerror(("Name error: name '" + name + "' is redeclared").c_str());
      return;
    }
  }

  auto entry_itr = gsymtable.var_entries.find(name);
  if (entry_itr != gsymtable.var_entries.end()) {
      yyerror(("Name error: name '" + name + "' is redeclared").c_str());
      return;
  }

}


void add_func(const std::string &name, const std::vector<std::pair<std::string, std::string>> &params, const std::string &return_type, int lineno) {
  local_symtable *func_symtable_ptr = new local_symtable;
  for (auto &param : params) {
    func_symtable_ptr->param_types.push_back(param.second);
    func_symtable_ptr->var_entries[param.first] = {param.second, "", yylineno, get_size(param.second), 0}; // TODO
  }

  func_symtable_ptr->return_type = return_type;
  func_symtable_ptr->lineno = lineno;

  if (class_scope) {
    cur_class_symtable_ptr->method_symtable_ptrs[name] = func_symtable_ptr;
    return;
  }

  gsymtable.func_symtable_ptrs[name] = func_symtable_ptr;
}

local_symtable * lookup_func(const std::string &name) {
  if (class_scope) {
    auto func_symtable_itr = cur_class_symtable_ptr->method_symtable_ptrs.find(name);
    if (func_symtable_itr != cur_class_symtable_ptr->method_symtable_ptrs.end()) {
      return func_symtable_itr->second;
    }
  }

  auto func_symtable_itr = gsymtable.func_symtable_ptrs.find(name);
  if (func_symtable_itr != gsymtable.func_symtable_ptrs.end()) {
    return func_symtable_itr->second;
  }

  yyerror(("Name error: name '" + name + "' is not defined").c_str());
  return func_symtable_itr->second;
}

void add_class(const std::string &name) {
  class_symtable *class_symtable_ptr = new class_symtable;
  gsymtable.class_symtable_ptrs[name] = class_symtable_ptr;
}
