#include <string>
#include <vector>
#include <unordered_map>
#include "symtable.h"

extern bool global_scope;
extern global_symtable gsymtable;
extern local_symtable *cur_symtable_ptr;

extern void yyerror(const char *);

symtable_entry lookup(const std::string &name) {
  if (global_scope) {
    auto entry_itr = gsymtable.var_entries.find(name);
    if (entry_itr == gsymtable.var_entries.end()) {
      yyerror("Undeclared variable");
    }

    return entry_itr->second;
  }

  // name resolution
  auto entry_itr = cur_symtable_ptr->var_entries.find(name);
  if (entry_itr == cur_symtable_ptr->var_entries.end()) {
    auto entry_itr = gsymtable.var_entries.find(name);
    if (entry_itr == gsymtable.var_entries.end()) {
      yyerror("Undeclared variable");
    }

    return entry_itr->second;
  }

  return entry_itr->second;
}

void insert(const std::string &name, const symtable_entry &entry) {
  // TODO: handle redeclarations
  if (global_scope) {
    gsymtable.var_entries[name] = entry;
    return;
  }

  cur_symtable_ptr->var_entries[name] = entry;
}
