#!/bin/bash
p4c-ebpf --arch psa -o src/katran.c src/katran.p4
clang -O2 -target bpf -c src/katran.c -o src/katran.o
