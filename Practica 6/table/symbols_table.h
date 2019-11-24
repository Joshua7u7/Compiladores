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
    float float_value;
    char char_value;
    char * string_value;
}values;

typedef values * Values;

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
void showTable(Symbol );
int isVariableOnTable(Symbol , char * );
int getType(Symbol , char * );
Values getValue(Symbol , char * , Values ); 
Item * fillGenericFields(Item * , char * );
Item * setValues(Item *  , values *, int );
Symbol insert(Symbol , char * , values *, int );
Values createValues();
Symbol reasignation (Symbol , Values , char * , int );
#endif