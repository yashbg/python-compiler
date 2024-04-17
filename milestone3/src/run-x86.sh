#!/bin/bash

x86_64-linux-gnu-gcc ../tests/test1/x86.s -o ../tests/test1/test1 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test1/test1
echo
x86_64-linux-gnu-gcc ../tests/test2/x86.s -o ../tests/test2/test2 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test2/test2
echo
x86_64-linux-gnu-gcc ../tests/test3/x86.s -o ../tests/test3/test3 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test3/test3
echo
x86_64-linux-gnu-gcc ../tests/test4/x86.s -o ../tests/test4/test4 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test4/test4
echo
x86_64-linux-gnu-gcc ../tests/test5/x86.s -o ../tests/test5/test5 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test5/test5
