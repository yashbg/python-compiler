#include <string>
#include <vector>
#include <unordered_map>
#include <utility>
#include "symtable.h"

extern int yylineno;

extern bool global_scope;
extern global_symtable gsymtable;
extern local_symtable *cur_symtable_ptr;

extern void yyerror(const char *);

extern int get_size(const std::string &type);

void insert_var(const std::string &name, const symtable_entry &entry) {
  // TODO: handle redeclarations
  if (global_scope) {
    gsymtable.var_entries[name] = entry;
    return;
  }

  cur_symtable_ptr->var_entries[name] = entry;
}

symtable_entry lookup_var(const std::string &name) {
  if (global_scope) {
    auto entry_itr = gsymtable.var_entries.find(name);
    if (entry_itr == gsymtable.var_entries.end()) {
      yyerror(("Name error: name '" + name + "' is not defined").c_str());
    }

    return entry_itr->second;
  }

  // name resolution
  auto entry_itr = cur_symtable_ptr->var_entries.find(name);
  if (entry_itr == cur_symtable_ptr->var_entries.end()) {
    auto entry_itr = gsymtable.var_entries.find(name);
    if (entry_itr == gsymtable.var_entries.end()) {
      yyerror(("Name error: name '" + name + "' is not defined").c_str());
    }

    return entry_itr->second;
  }

  return entry_itr->second;
}

void add_func(const std::string &name, const std::vector<std::pair<std::string, std::string>> &params, const std::string &return_type) {
  local_symtable *func_symtable_ptr = new local_symtable;
  for (auto &param : params) {
    func_symtable_ptr->param_types.push_back(param.second);
    func_symtable_ptr->var_entries[param.first] = {param.second, "", yylineno, get_size(param.second), 0}; // TODO
  }

  func_symtable_ptr->return_type = return_type;
  gsymtable.func_symtable_ptrs[name] = func_symtable_ptr;
}

local_symtable * lookup_func(const std::string &name) {
  auto func_symtable_itr = gsymtable.func_symtable_ptrs.find(name);
  if (func_symtable_itr == gsymtable.func_symtable_ptrs.end()) {
    yyerror(("Name error: name '" + name + "' is not defined").c_str());
  }

  return func_symtable_itr->second;
}
