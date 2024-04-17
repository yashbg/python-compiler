#!/bin/bash

gcc ../tests/test1/x86.s -o ../tests/test1/test1 -no-pie
../tests/test1/test1 > ../tests/test1/out.log
echo "Output saved to ../tests/test1/out.log"

gcc ../tests/test2/x86.s -o ../tests/test2/test2 -no-pie
../tests/test2/test2 > ../tests/test2/out.log
echo "Output saved to ../tests/test2/out.log"

gcc ../tests/test3/x86.s -o ../tests/test3/test3 -no-pie
../tests/test3/test3 > ../tests/test3/out.log
echo "Output saved to ../tests/test3/out.log"

gcc ../tests/test4/x86.s -o ../tests/test4/test4 -no-pie
../tests/test4/test4 > ../tests/test4/out.log
echo "Output saved to ../tests/test4/out.log"

gcc ../tests/test5/x86.s -o ../tests/test5/test5 -no-pie
../tests/test5/test5 > ../tests/test5/out.log
echo "Output saved to ../tests/test5/out.log"
