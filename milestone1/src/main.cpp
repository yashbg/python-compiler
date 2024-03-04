#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>

extern int yyparse();

void add_dot_header() {
  std::cout << "strict graph AST {" << std::endl << std::endl;
                "ratio = fill;" << std::endl;
                "node [style=filled];" << std::endl << std::endl;
}

void add_dot_footer() {
  std::cout << "}" << std::endl;
}

int main(int argc, char *argv[]) {
  std::string input_file, output_file;
  bool verbose = false;
  for (int i = 1; i < argc; i++) {
    if (argv[i].substr(0, 8) == "--input=") {
      input_file = argv[i].substr(8);
    }
    else if (argv[i].substr(0, 9) == "--output=") {
      output_file = argv[i].substr(9);
    }
    else if (argv[i] == "--help") {
      show_help();
    }
    else if (argv[i] == "--verbose") {
      verbose = true;
    }
  }

  if (input_file.empty() || output_file.empty()) {
    std::cerr << "Error: Input or output file not specified." << std::endl;
    show_help();
    return 1;
  }

  std::fstream outfile;
  outfile.open("graph.dot", ios::out);
  std::streambuf *coutbuf = std::cout.rdbuf();
  std::streambuf *outfilebuf = outfile.rdbuf();

  std::cout.rdbuf(outfilebuf);

  if (verbose) {
    std::cout.rdbuf(coutbuf);
    std::cout << "Input file: " << input_file << std::endl;
    std::cout << "Output file: " << output_file << std::endl;
    std::cout << "Parsing input file and creating DOT file..." << std::endl;
    std::cout.rdbuf(outfilebuf);
  }

  add_dot_header();
  yyparse();
  add_dot_footer();

  if (verbose) {
    std::cout.rdbuf(coutbuf);
    std::cout << "Creating AST..." << std::endl;
    std::cout.rdbuf(outfilebuf);
  }

  return system("dot -Tpdf graph.dot -o " + output_file);
}
