#include <string>
#include <vector>
#include <unordered_map>
#include <utility>
#include "symtable.h"

extern int yylineno;

extern bool func_scope;
extern bool class_scope;
extern class_symtable *cur_class_symtable_ptr;

extern int list_len;

extern void yyerror(const char *);

extern int get_size(const std::string &type);
extern int get_list_width(const std::string &type);

global_symtable gsymtable;
local_symtable *cur_func_symtable_ptr = nullptr;
class_symtable *cur_class_symtable_ptr = nullptr;
bool func_scope = false;
bool class_scope = false;

void insert_var(const std::string &name, const std::string &type) {
  // TODO: handle redeclarations
  int size = get_size(type);
  symtable_entry entry;
  if (type.substr(0, 4) == "list") {
    entry = {type, yylineno, size, list_len, get_list_width(type), 0};
  }
  else {
    entry = {type, yylineno, size, 0, 0, 0};
  }

  if (func_scope) {
    entry.offset = cur_func_symtable_ptr->offset;
    cur_func_symtable_ptr->offset += size;

    cur_func_symtable_ptr->var_entries[name] = entry;
    return;
  }

  entry.offset = gsymtable.offset;
  gsymtable.offset += size;

  gsymtable.var_entries[name] = entry;
}

symtable_entry lookup_var(const std::string &name) {
  int dot = name.find('.');
  if (dot != std::string::npos) {
    std::string obj_name = name.substr(0, dot);
    std::string class_name = lookup_var(obj_name).type;
    std::string attr_name = name.substr(dot + 1);
    return lookup_attr(class_name, attr_name);
  }

  if (func_scope) {
    auto entry_itr = cur_func_symtable_ptr->var_entries.find(name);
    if (entry_itr != cur_func_symtable_ptr->var_entries.end()) {
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

void insert_attr(const std::string &name, const std::string &type) {
  int size = get_size(type);
  symtable_entry entry;
  if (type.substr(0, 4) == "list") {
    entry = {type, yylineno, size, list_len, get_list_width(type), 0};
  }
  else {
    entry = {type, yylineno, size, 0, 0, 0};
  }

  // inheritance
  int ancestors_size = 0;
  class_symtable *parent_symtable_ptr = cur_class_symtable_ptr->parent_symtable_ptr;
  while (parent_symtable_ptr) {
    ancestors_size += parent_symtable_ptr->offset;
    
    parent_symtable_ptr = parent_symtable_ptr->parent_symtable_ptr;
  }

  entry.offset = ancestors_size + cur_class_symtable_ptr->offset;
  cur_class_symtable_ptr->offset += size;

  cur_class_symtable_ptr->attr_entries[name] = entry;
}

symtable_entry lookup_attr(const std::string &class_name, const std::string &attr_name) {
  class_symtable *class_symtable_ptr = lookup_class(class_name);
  auto entry_itr = class_symtable_ptr->attr_entries.find(attr_name);
  if (entry_itr != class_symtable_ptr->attr_entries.end()) {
    return entry_itr->second;
  }

  // inheritance
  class_symtable *parent_symtable_ptr = class_symtable_ptr->parent_symtable_ptr;
  while (parent_symtable_ptr) {
    entry_itr = parent_symtable_ptr->attr_entries.find(attr_name);
    if (entry_itr != parent_symtable_ptr->attr_entries.end()) {
      return entry_itr->second;
    }
    
    parent_symtable_ptr = parent_symtable_ptr->parent_symtable_ptr;
  }

  yyerror(("Attribute error: '" + class_name + "' class has no attribute '" + attr_name + "'").c_str());
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
    func_symtable_ptr->params.push_back(param);

    int size = get_size(param.second);
    symtable_entry entry;
    if (param.second.substr(0, 4) == "list") {
      entry = {param.second, yylineno, size, list_len, get_list_width(param.second), 0};
    }
    else {
      entry = {param.second, yylineno, size, 0, 0, 0};
    }

    entry.offset = func_symtable_ptr->offset;
    func_symtable_ptr->offset += size;

    func_symtable_ptr->var_entries[param.first] = entry;
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
  int dot = name.find('.');
  if (dot != std::string::npos) {
    std::string obj_name = name.substr(0, dot);
    std::string class_name;
    if (is_class(obj_name)) {
      class_name = obj_name;
    }
    else {
      class_name = lookup_var(obj_name).type;
    }

    std::string method_name = name.substr(dot + 1);
    return lookup_method(class_name, method_name);
  }

  auto func_symtable_itr = gsymtable.func_symtable_ptrs.find(name);
  if (func_symtable_itr != gsymtable.func_symtable_ptrs.end()) {
    return func_symtable_itr->second;
  }

  yyerror(("Name error: name '" + name + "' is not defined").c_str());
  return func_symtable_itr->second;
}

void add_class(const std::string &name, class_symtable *parent_symtable_ptr) {
  class_symtable *class_symtable_ptr = new class_symtable;
  class_symtable_ptr->parent_symtable_ptr = parent_symtable_ptr;
  gsymtable.class_symtable_ptrs[name] = class_symtable_ptr;
}

class_symtable * lookup_class(const std::string &name) {
  auto class_symtable_itr = gsymtable.class_symtable_ptrs.find(name);
  if (class_symtable_itr != gsymtable.class_symtable_ptrs.end()) {
    return class_symtable_itr->second;
  }

  yyerror(("Name error: name '" + name + "' is not defined").c_str());
  return class_symtable_itr->second;
}

local_symtable * lookup_method(const std::string &class_name, const std::string &method_name) {
  class_symtable *class_symtable_ptr = lookup_class(class_name);
  auto method_symtable_itr = class_symtable_ptr->method_symtable_ptrs.find(method_name);
  if (method_symtable_itr != class_symtable_ptr->method_symtable_ptrs.end()) {
    return method_symtable_itr->second;
  }

  // inheritance
  class_symtable *parent_symtable_ptr = class_symtable_ptr->parent_symtable_ptr;
  while (parent_symtable_ptr) {
    method_symtable_itr = parent_symtable_ptr->method_symtable_ptrs.find(method_name);
    if (method_symtable_itr != parent_symtable_ptr->method_symtable_ptrs.end()) {
      return method_symtable_itr->second;
    }
    
    parent_symtable_ptr = parent_symtable_ptr->parent_symtable_ptr;
  }

  yyerror(("Attribute error: '" + class_name + "' object has no method '" + method_name + "()'").c_str());
  return method_symtable_itr->second;
}

int get_class_size(const std::string &name) {
  int size = 0;
  class_symtable *class_symtable_ptr = lookup_class(name);
  for (auto &entry : class_symtable_ptr->attr_entries) {
    size += entry.second.size;
  }

  // inheritance
  class_symtable *parent_symtable_ptr = class_symtable_ptr->parent_symtable_ptr;
  while (parent_symtable_ptr) {
    for (auto &entry : parent_symtable_ptr->attr_entries) {
      size += entry.second.size;
    }
    
    parent_symtable_ptr = parent_symtable_ptr->parent_symtable_ptr;
  }

  return size;
}

bool is_func(const std::string &name) {
  if (class_scope) {
    auto func_symtable_itr = cur_class_symtable_ptr->method_symtable_ptrs.find(name);
    if (func_symtable_itr != cur_class_symtable_ptr->method_symtable_ptrs.end()) {
      return true;
    }
  }

  auto func_symtable_itr = gsymtable.func_symtable_ptrs.find(name);
  if (func_symtable_itr != gsymtable.func_symtable_ptrs.end()) {
    return true;
  }

  return false;
}

bool is_class(const std::string &name) {
  return gsymtable.class_symtable_ptrs.find(name) != gsymtable.class_symtable_ptrs.end();
}
