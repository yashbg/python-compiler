#!/bin/bash

x86_64-linux-gnu-gcc -S -march=x86-64 -fno-asynchronous-unwind-tables -fno-exceptions ../x86-examples/test1.c -o ../x86-examples/test1.s
x86_64-linux-gnu-g++ -S -march=x86-64 -fno-asynchronous-unwind-tables -fno-exceptions ../x86-examples/test2.cpp -o ../x86-examples/test2.s
x86_64-linux-gnu-gcc -S -march=x86-64 -fno-asynchronous-unwind-tables -fno-exceptions ../x86-examples/test3.c -o ../x86-examples/test3.s
