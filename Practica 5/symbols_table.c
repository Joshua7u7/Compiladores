#include <stdio.h>
#include <stdlib.h>
#include "symbols_table.h"
#include "utils.h"

int counter = 0;

Symbol createTable() {
    Symbol table = NULL;
    return table;
}

Item * createNewSymbol() {
    Item * new_item = (Item *)malloc(sizeof(Item));
    if (new_item == NULL) handleError("Full memory");
    return new_item;
}

int isEmpty(Symbol table) {
    if (table == NULL) return TRUE;
    else return FALSE;
}

Symbol insert_int(Symbol table, char * name, int value) {
    Item * new_item, *current_symbol;
    new_item = createNewSymbol();
    new_item->item_value = (values *)malloc(sizeof(values));
    new_item->variable_name = (char*)malloc(sizeof(char)*stringLen(name));
    new_item->dimention = sizeof(value);
    new_item->id = ++counter;
    new_item->type = INT_;
    copyStrings(new_item->variable_name, name);
    new_item->item_value->int_value = value;
    new_item->next_item = NULL;
    if (isEmpty(table) == TRUE) {
        table = new_item;
        return table;
    }
    else {
        current_symbol = table;
        while (current_symbol->next_item != NULL)
            current_symbol = current_symbol->next_item;
        current_symbol->next_item = new_item;
        return table;
    }
}

Symbol insert_float(Symbol table, char * name, float value) {
    Item * new_item, *current_symbol;
    new_item = createNewSymbol();
    new_item->item_value = (values *)malloc(sizeof(values));
    new_item->variable_name = (char*)malloc(sizeof(char)*stringLen(name));
    new_item->dimention = sizeof(value);
    new_item->id = ++counter;
    new_item->type = FLOAT_;
    copyStrings(new_item->variable_name, name);
    new_item->item_value->float_vale = value;
    new_item->next_item = NULL;
    if (isEmpty(table) == TRUE) {
        table = new_item;
        return table;
    }
    else {
        current_symbol = table;
        while (current_symbol->next_item != NULL)
            current_symbol = current_symbol->next_item;
        current_symbol->next_item = new_item;
        return table;
    }
}

Symbol insert_string(Symbol table, char * name, char * value) {
    Item * new_item, *current_symbol;
    new_item = createNewSymbol();
    new_item->item_value = (values *)malloc(sizeof(values));
    new_item->variable_name = (char*)malloc(sizeof(char)*stringLen(name));
    new_item->item_value->string_value = (char*)malloc(sizeof(char)*stringLen(value));
    new_item->dimention = sizeof(value);
    new_item->id = ++counter;
    new_item->type = STRING_;
    copyStrings(new_item->variable_name, name);
    copyStrings(new_item->item_value->string_value, value);
    new_item->next_item = NULL;
    if (isEmpty(table) == TRUE) {
        table = new_item;
        return table;
    }
    else {
        current_symbol = table;
        while (current_symbol->next_item != NULL)
            current_symbol = current_symbol->next_item;
        current_symbol->next_item = new_item;
        return table;
    }
}

void showTable(Symbol table) {
    Symbol aux_table = table;
    while (aux_table != NULL) {
        printf("Id de la variable: %d\n", aux_table->id);
        printf("Nombre de la variable: %s \n", aux_table->variable_name);
        switch (aux_table->type) {
        case INT_:
            printf("Valor: %d\n ", aux_table->item_value->int_value);
            break;
        case FLOAT_:
            printf("Valor: %.2f\n ", aux_table->item_value->float_vale);
            break;
        case STRING_:
            printf("Valor: %s\n ", aux_table->item_value->string_value);
            break;
        default:
            break;
        }
        aux_table = aux_table->next_item;
    }
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

Symbol reasignation_int(Symbol table, int value, char * name) {
    Item * current_symbol = table;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            current_symbol->item_value->int_value = value;
            break;
        }
    }
    return table;
}

Symbol reasignation_float(Symbol table, float value, char * name) {
    Item * current_symbol = table;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            current_symbol->item_value->float_vale = value;
            break;
        }
    }
    return table;
}

Symbol reasignation_string(Symbol table, char * value, char * name) {
    Item * current_symbol = table;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            copyStrings(current_symbol->item_value->string_value , value);
            break;
        }
    }
    return table;
}