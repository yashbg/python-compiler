#!/bin/bash

x86_64-linux-gnu-gcc ../tests/test1/x86.s -o ../tests/test1/test1 -no-pie
qemu-x86_64-static -L /usr/x86_64-linux-gnu/ ../tests/test1/test1