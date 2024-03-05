#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>

extern FILE *yyin;
extern int yyparse();

std::ofstream outfile;

void show_help() {
  std::cout << "Usage: ./main [-verbose] -input <input_file> -output <output_file>" << std::endl
            << "  -input: Input file to parse." << std::endl
            << "  -output: Output file to save the AST." << std::endl
            << "  -verbose: Show verbose output." << std::endl;
}

void add_dot_header() {
  outfile << "strict digraph AST {" << std::endl;
}

void add_dot_footer() {
  outfile << "}" << std::endl;
}

int main(int argc, char *argv[]) {
  std::string input_file, output_file;
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

      output_file = argv[i + 1];
      i++;
    }

    else if (arg == "-help") {
      show_help();
    }

    else if (arg == "-verbose") {
      verbose = true;
    }
  }

  if (input_file.empty() || output_file.empty()) {
    std::cerr << "Error: Input or output file not specified." << std::endl;
    show_help();
    return 1;
  }

  yyin = fopen(input_file.c_str(), "r");
  if (yyin == NULL) {
    std::cerr << "Error: Could not open input file." << std::endl;
    return 1;
  }

  outfile.open("graph.dot");

  if (verbose) {
    std::cout << "Input file: " << input_file << std::endl;
    std::cout << "Output file: " << output_file << std::endl;
    std::cout << "Parsing input file and creating DOT file..." << std::endl;
  }

  add_dot_header();
  yyparse();
  add_dot_footer();

  if (verbose) {
    std::cout << "Creating AST..." << std::endl;
  }

  return system(("dot -Tpdf graph.dot -o " + output_file).c_str());
}
