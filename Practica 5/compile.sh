#! /bin/bash

# gcc -g symbols_table.c main.c utils.c -o main
flex symbols.l
bison symbols.y -d
gcc -g lex.yy.c symbols.tab.c symbols_table.c utils.c -o symbols