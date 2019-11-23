#include <stdio.h>
#include <stdlib.h>
#include "utils.h"
#include "symbols_table.h"


int main(int argc, char ** argv) {
    Symbol table = createTable();
    table = insert_int(table, "variable_entera", 3);
    table = insert_int(table, "variable_entera_2", 5);
    table = insert_float(table, "variable_flotante", 2.25);
    table = insert_string(table, "variable_string", "Hola mundo");
    showTable(table);
    return 0;
}