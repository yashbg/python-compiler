# python-compiler

A compilation toolchain, where the input is in a statically typed subset of the Python language and the output is x86_64 code. 

## Milestones

The compiler was developed in 3 milestones:
- Milestone 1 - To construct a scanner and a parser and output a graphical 
representation of the AST of the input program
- Milestone 2 - To add the symbol table, perform semantic analysis, 
generate 3AC code and add runtime support for function calls
- Milestone 3 - To generate x86_64 assembly from the 3AC code and run it 
via GAS on Linux

## Features supported

- Primitive data types (e.g., int, float, str, and bool)
- 1D lists
- Basic operators:
- Arithmetic operators: +, -, *, /, //, %, **
- Relational operators: ==, !=, >, <, >=, <=
- Logical operators: and, or, not
- Bitwise operators: &, |, ^, ~, <<, >>
- Assignment operators: =, +=, -=, *=, /=, //=, %=, **=, &=, |=, =^, <<=, >>=
- Control flow via if-elif-else, for, while, break, and continue
- Support iterating over ranges specified using the range() function.
- Support for recursion
- Support for the library function print() for only printing the primitive 
Python types, one at a time
- Support for classes and objects, including multilevel inheritance and 
constructors
- Methods and method calls
