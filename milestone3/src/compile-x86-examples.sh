#!/bin/bash

x86_64-linux-gnu-gcc -S -march=x86-64 -fno-asynchronous-unwind-tables -fno-exceptions ../x86-examples/test1.c -o ../x86-examples/test1.s
