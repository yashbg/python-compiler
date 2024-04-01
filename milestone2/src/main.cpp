#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdlib>
#include <filesystem>
#include "symtable.h"

extern FILE *yyin;
extern int yyparse();

std::ofstream outfile;
FILE *lexer_logfile;
std::ofstream parser_logfile;

extern global_symtable gsymtable;
extern std::vector<std::vector<std::string>> ac3_code;

void show_help();

void add_dot_header();
void add_dot_footer();

void add_csv_header(std::ofstream &csvfile);
void dump_symtables(const std::string &output_dir);
void dump_3ac(const std::string &output_dir);

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

  outfile.open("graph.dot");

  lexer_logfile = fopen((output_dir + "lexer.log").c_str(), "w");
  parser_logfile.open(output_dir + "parser.log");

  if (verbose) {
    std::cout << "Input file: " << input_file << std::endl;
    std::cout << "Output directory: " << output_dir << std::endl;
    std::cout << "Parsing input file and creating DOT file..." << std::endl;
  }

  insert_var("__name__", {"str", "", 0, 0, 0, 0, 0});
  insert_var("print", {"null", "", 0, 0, 0, 0, 0});
  insert_var("len", {"int", "", 0, 0, 0, 0, 0});
  insert_var("range", {"int", "", 0, 0, 0, 0, 0});

  // add_dot_header();
  yyparse();
  // add_dot_footer();

  std::filesystem::create_directories(output_dir);

  // if (verbose) {
  //   std::cout << "Creating AST..." << std::endl;
  // }

  // system(("dot -Tpdf graph.dot -o " + output_dir + "graph.pdf").c_str());

  if (verbose) {
    std::cout << "Dumping symbol tables and 3AC..." << std::endl;
  }

  dump_symtables(output_dir);
  dump_3ac(output_dir);

  return 0;
}

void show_help() {
  std::cout << "Usage: ./main [-verbose] -input <input_file> -output <output_dir>" << std::endl
            << "  -input: Input file to parse." << std::endl
            << "  -output: Output directory to dump the symbol tables and the 3AC." << std::endl
            << "  -verbose: Show verbose output." << std::endl;
}

void add_dot_header() {
  outfile << "strict digraph AST {" << std::endl;
}

void add_dot_footer() {
  outfile << "}" << std::endl;
}

void add_csv_header(std::ofstream &csvfile) {
  csvfile << "token,lexeme,type,lineno" << std::endl;
}

void dump_symtables(const std::string &output_dir) {
  std::ofstream global_dumpfile;
  global_dumpfile.open(output_dir + "global.csv");
  add_csv_header(global_dumpfile);
  for (auto &entry : gsymtable.var_entries) {
    global_dumpfile << "NAME," << entry.first << "," << entry.second.type << "," << entry.second.lineno << std::endl;
  }

  for (auto &symtable : gsymtable.func_symtable_ptrs) {
    std::ofstream func_dumpfile;
    func_dumpfile.open(output_dir + symtable.first + ".csv");
    add_csv_header(func_dumpfile);
    for (auto &entry : symtable.second->var_entries) {
      func_dumpfile << "NAME," << entry.first << "," << entry.second.type << "," << entry.second.lineno << std::endl;
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
    else if (line_code[0].empty() && line_code[2].empty()) {
      ac3_dumpfile << line_code[3] << " = "
                   << line_code[1] << std::endl;
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
