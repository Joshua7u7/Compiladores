#include <stdio.h>
#include <stdlib.h>
#include "symbols_table.h"
#include "../utils/utils.h"

int isEmpty(Symbol table) {
    if (table == NULL) return TRUE;
    else return FALSE;
}

int isVariableOnTable(Symbol table, char * variable) {
    Symbol current_symbol = table;
    int response = FALSE;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, variable) == TRUE) {
            response = TRUE;
            break;
        }
        current_symbol = current_symbol->next_item;
    }
    return response;
}

int getType(Symbol table, char * name) {
    Item * current_symbol = table;
    int type;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            type = current_symbol->type;
            break;
        }
        current_symbol = current_symbol->next_item;
    }
    return type;
}

void showTable(Symbol table) {
    Symbol aux_table = table;
    printf("\t|****************|**************|**************|\n");
    printf("\t|      ID        |     NOMBRE   |     VALOR    |\n");
    while (aux_table != NULL) {
        switch (aux_table->type) {
        case INT_:
            printf("\t|       %d        |        %s    |        %d    |\n", aux_table->id, 
            aux_table->variable_name, aux_table->item_value->int_value);
            break;
        case FLOAT_:
            printf("\t|       %d        |        %s    |        %.2f    |\n", aux_table->id, 
            aux_table->variable_name, aux_table->item_value->float_value);
            break;
        case STRING_:
            printf("\t|       %d        |        %s    |        %s    |\n", aux_table->id, 
            aux_table->variable_name, aux_table->item_value->string_value);
            break;
        default:
            break;
        }
        aux_table = aux_table->next_item;
    }
    printf("\t|****************|**************|**************|\n");
}