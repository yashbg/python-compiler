#include <iostream>
#include <string>
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

void show_help();

void add_dot_header();
void add_dot_footer();

void add_csv_header(std::ofstream &csvfile);
void dump_symtables(const std::string &output_dir);

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

  lexer_logfile = fopen("lexer.log", "w");
  parser_logfile.open("parser.log");

  if (verbose) {
    std::cout << "Input file: " << input_file << std::endl;
    std::cout << "Output directory: " << output_dir << std::endl;
    std::cout << "Parsing input file and creating DOT file..." << std::endl;
  }

  add_dot_header();
  yyparse();
  add_dot_footer();

  std::filesystem::create_directories(output_dir);

  if (verbose) {
    std::cout << "Creating AST..." << std::endl;
  }

  system(("dot -Tpdf graph.dot -o " + output_dir + "graph.pdf").c_str());

  if (verbose) {
    std::cout << "Dumping symbol tables..." << std::endl;
  }

  dump_symtables(output_dir);

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
