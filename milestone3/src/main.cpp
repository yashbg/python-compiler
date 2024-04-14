#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdlib>
#include <filesystem>
#include "symtable.h"
#include "codegen.h"

extern FILE *yyin;
extern int yyparse();

FILE *lexer_logfile;
std::ofstream parser_logfile;

extern std::vector<std::vector<std::string>> ac3_code; // 3AC instructions (op, arg1, arg2, result)

void show_help();

void add_csv_header(std::ofstream &csvfile);
void dump_symtables(const std::string &output_dir);
void dump_3ac(const std::string &output_dir);

void dump_x86_code(const std::string &output_dir);

int main(int argc, char *argv[]) {
  std::string input_file, output_dir;
  bool verbose = false;
  for (int i = 1; i < argc; i++) {
    std::string arg = argv[i];
    if (arg == "-input") {
      if (i + 1 >= argc) {
        std::cerr << "Error: Input file not specified." << std::endl;
        show_help();
        return 1;
      }

      input_file = argv[i + 1];
      i++;
    }

    else if (arg == "-output") {
      if (i + 1 >= argc) {
        std::cerr << "Error: Output file not specified." << std::endl;
        show_help();
        return 1;
      }

      output_dir = argv[i + 1];
      if (output_dir.back() != '/') {
        output_dir += '/';
      }
      
      i++;
    }

    else if (arg == "-help") {
      show_help();
    }

    else if (arg == "-verbose") {
      verbose = true;
    }
  }

  if (input_file.empty() || output_dir.empty()) {
    std::cerr << "Error: Input file or output directory not specified." << std::endl;
    show_help();
    return 1;
  }

  yyin = fopen(input_file.c_str(), "r");
  if (yyin == NULL) {
    std::cerr << "Error: Could not open input file." << std::endl;
    return 1;
  }

  std::filesystem::create_directories(output_dir);

  lexer_logfile = fopen((output_dir + "lexer.log").c_str(), "w");
  parser_logfile.open(output_dir + "parser.log");

  if (verbose) {
    std::cout << "Input file: " << input_file << std::endl;
    std::cout << "Output directory: " << output_dir << std::endl;
    std::cout << "Parsing input file..." << std::endl;
  }

  // frontend

  insert_var("__name__", "str");

  yyparse();

  if (verbose) {
    std::cout << "Dumping symbol tables and 3AC..." << std::endl;
  }

  dump_symtables(output_dir);
  dump_3ac(output_dir);

  // backend

  if (verbose) {
    std::cout << "Generating x86_64 code..." << std::endl;
  }

  gen_x86_code();
  dump_x86_code(output_dir);

  return 0;
}

void show_help() {
  std::cout << "Usage: ./main [-verbose] -input <input_file> -output <output_dir>" << std::endl
            << "  -input: Input file to parse." << std::endl
            << "  -output: Output directory to dump the symbol tables and the 3AC." << std::endl
            << "  -verbose: Show verbose output." << std::endl;
}

void add_csv_header(std::ofstream &csvfile) {
  csvfile << "token,lexeme,type,ret_type,size,lineno,offset" << std::endl;
}

void dump_symtables(const std::string &output_dir) {
  std::ofstream global_dumpfile;
  global_dumpfile.open(output_dir + "global.csv");
  add_csv_header(global_dumpfile);
  for (auto &entry : gsymtable.var_entries) {
    global_dumpfile << "NAME," << entry.first << "," << entry.second.type << ",," << entry.second.size << "," << entry.second.lineno << entry.second.offset << std::endl;
  }

  for (auto &symtable : gsymtable.func_symtable_ptrs) {
    std::ofstream func_dumpfile;
    func_dumpfile.open(output_dir + symtable.first + ".csv");
    add_csv_header(func_dumpfile);
    for (auto &entry : symtable.second->var_entries) {
      func_dumpfile << "NAME," << entry.first << "," << entry.second.type << ",," << entry.second.size << "," << entry.second.lineno << "," << entry.second.offset << std::endl;
    }

    global_dumpfile << "NAME," << symtable.first << ",," << symtable.second->return_type << ",," << symtable.second->lineno << std::endl;
  }

  for (auto &symtable : gsymtable.class_symtable_ptrs) {
    std::ofstream class_dumpfile;
    class_dumpfile.open(output_dir + symtable.first + ".csv");
    add_csv_header(class_dumpfile);
    for (auto &entry : symtable.second->attr_entries) {
      class_dumpfile << "NAME," << entry.first << "," << entry.second.type << ",," << entry.second.size << "," << entry.second.lineno << entry.second.offset << std::endl;
    }

    for (auto &method_symtable : symtable.second->method_symtable_ptrs) {
      std::ofstream method_dumpfile;
      method_dumpfile.open(output_dir + symtable.first + "_" + method_symtable.first + ".csv");
      add_csv_header(method_dumpfile);
      for (auto &entry : method_symtable.second->var_entries) {
        method_dumpfile << "NAME," << entry.first << "," << entry.second.type << ",," << entry.second.size << "," << entry.second.lineno << entry.second.offset << std::endl;
      }

      class_dumpfile << "NAME," << method_symtable.first << ",," << method_symtable.second->return_type << ",," << method_symtable.second->lineno << std::endl;
    }
  }
}

void dump_3ac(const std::string &output_dir) {
  std::ofstream ac3_dumpfile;
  ac3_dumpfile.open(output_dir + "3ac.log");
  for (auto &line_code : ac3_code) {
    if (line_code[0] == "=") {
      ac3_dumpfile << line_code[3] << " = "
                   << line_code[1] << std::endl;
    }
    else if(line_code[3] == "goto"){
      ac3_dumpfile << line_code[3] << " "
                   << line_code[1] << std::endl;
    }
    else if(line_code[1] == "goto"){
      ac3_dumpfile << line_code[3] << " "
                   << line_code[0] << " "
                   << line_code[1] << " "
                   << line_code[2] << std::endl;
    }
    else if((line_code[1] == ":") && (line_code[0].empty())){
        ac3_dumpfile << line_code[3]
                     << line_code[1] << std::endl;
    }
    else if((line_code[3] == "beginfunc") || (line_code[3] == "endfunc")){
      ac3_dumpfile << line_code[3] << std::endl;
    }
    else if(line_code[0] == "push"){
      ac3_dumpfile << line_code[0] << " "
                   << line_code[1] << std::endl;
    }
    else if(line_code[0] == "return"){
      ac3_dumpfile << line_code[0] << std::endl;
    }
    else if(line_code[0] == "popparam"){
      ac3_dumpfile << line_code[3] << " = "
                   << line_code[0] << std::endl;
    }
    else if(line_code[0] == "stackpointer"){
      ac3_dumpfile << line_code[0] << " "
                   << line_code[1] << std::endl;
    }
    else if(line_code[0] == "param"){
      ac3_dumpfile << line_code[0] << " "
                   << line_code[1] << std::endl;
    }
    else if(line_code[3] == "call"){
      ac3_dumpfile << line_code[3] << " "
                   << line_code[1] << " "
                   << line_code[2] << " "
                   << line_code[0] << std::endl;
    }
    else if (line_code[2].empty()) {
      ac3_dumpfile << line_code[3] << " = "
                   << line_code[0] << " "
                   << line_code[1] << std::endl;
    }
    else {
      ac3_dumpfile << line_code[3] << " = "
                   << line_code[1] << " "
                   << line_code[0] << " "
                   << line_code[2] << std::endl;
    }
  }
}

void dump_x86_code(const std::string &output_dir) {
  std::ofstream x86_dumpfile;
  x86_dumpfile.open(output_dir + "x86.s");
  for (const auto &line : x86_code) {
    x86_dumpfile << line << std::endl;
  }
}
