#include <stdio.h>
#include <stdlib.h>
#include "symbols_table.h"
#include "../utils/utils.h"

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

Values createValues() {
    Values new_value = (Values)malloc(sizeof(values));
    if (new_value == NULL) {
        printf("Error in values");
        exit(EXIT_FAILURE);
    }
    return new_value;
}

Symbol insert(Symbol table, char * name, values * value, int option) {
    Item * new_item, * current_symbol;
    new_item = createNewSymbol();
    new_item = fillGenericFields(new_item, name);
    new_item = setValues(new_item, value, option);
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

Item * fillGenericFields(Item * new_item, char * name) {
    new_item->item_value = (values *)malloc(sizeof(values));
    new_item->id = ++counter;
    new_item->variable_name = (char*)malloc(sizeof(char)*stringLen(name));
    copyStrings(new_item->variable_name, name);
    new_item->next_item = NULL;
    return new_item;
}

Item * setValues(Item * new_item , values * value , int option) {
    switch (option) {
    case INT_:
        new_item->type = INT_;
        new_item->dimention = sizeof(value->int_value);
        new_item->item_value->int_value = value->int_value;
        break;
    case FLOAT_:
        new_item->type = FLOAT_;
        new_item->dimention = sizeof(value->float_value);
        new_item->item_value->float_value = value->float_value;
        break;
    case STRING_:
        new_item->type = STRING_;
        new_item->dimention = sizeof(value->string_value);
        new_item->item_value->string_value = (char*)malloc(sizeof(char)*stringLen(value->string_value));
        copyStrings(new_item->item_value->string_value, value->string_value);
        break;
    default:
        break;
    }
    return new_item;
}

Symbol reasignation (Symbol table, Values value, char * name, int option) {
    Item * current_symbol = table;
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            switch (option) {
                case INT_:
                    current_symbol->item_value->int_value = value->int_value;
                break;
                case FLOAT_:
                    current_symbol->item_value->float_value = value->float_value;
                break;
                case STRING_:
                    copyStrings(current_symbol->item_value->string_value , value->string_value);
                break;
            }
            break;
        }
        current_symbol = current_symbol->next_item;
    }
    return table;
}


Values getValue(Symbol table, char * name, Values value) {
    Item * current_symbol = table;
    int type = getType(table, name);
    while (current_symbol != NULL) {
        if (isTheSameString(current_symbol->variable_name, name) == TRUE) {
            switch (type) {
                case INT_:
                    value->int_value = current_symbol->item_value->int_value;
                break;
                case FLOAT_:
                    value->float_value = current_symbol->item_value->float_value;
                break;
                case STRING_:
                    value->string_value = (char*)malloc(sizeof(char)*stringLen(current_symbol->item_value->string_value));
                    copyStrings(value->string_value , current_symbol->item_value->string_value);
                break;
            }
            break;
        }
        current_symbol = current_symbol->next_item;
    }
    return value;
}