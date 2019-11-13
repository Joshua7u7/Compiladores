#! /bin/bash

flex p4.l
bison -d p4.y
gcc -g lex.yy.c p4.tab.c -o main -lm
# clear
# ./main