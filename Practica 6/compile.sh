#! /bin/bash

# gcc -g symbols_table.c main.c utils.c -o main
flex symbols.l
bison symbols.y -d
gcc -g lex.yy.c symbols.tab.c ./table/symbols_table.c ./table/utils_table.c ./utils/utils.c -o symbols -lm
if [ -f symbols ]
then echo "Compilado con éxito" && ./symbols
else echo "Checar errores de compilación"
fi
