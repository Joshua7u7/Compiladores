#include <stdio.h>

#ifndef SymbolsTable
#define SymbolsTable

#define TRUE 1
#define FALSE 2
#define INT_ 3
#define FLOAT_ 4
#define STRING_ 5

typedef struct {
    int int_value;
    float float_vale;
    char char_value;
    char * string_value;
}values;

typedef struct item{
    int id;
    char * variable_name;
    int type;
    int dimention;
    values  * item_value;
    struct item * next_item;
}Item;

typedef Item * Symbol;

Symbol createTable();
Item * createNewSymbol();
int isEmpty(Symbol);
Symbol insert_int(Symbol , char *, int);
Symbol insert_float(Symbol , char * , float ); 
Symbol insert_string(Symbol , char * , char * );
void showTable(Symbol );
int isVariableOnTable(Symbol , char * );
Symbol reasignation_string(Symbol , char * , char * );
Symbol reasignation_int(Symbol , int , char * );
Symbol reasignation_float(Symbol , float , char * );

#endif