%{
#include <stdio.h>
#include <stdlib.h>    
#include <string.h>
#include <math.h>
#include "symbols_table.h"

int yylex();
void yyerror (char *s);
int isOnTable(Symbol table, char * name );

Symbol table;
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
  float decimal;
  char * cadena;
}

%token <entero> ENTERO
%token <decimal> DECIMAL
%token <cadena> CADENA
%token MOD
%token INT
%token FLOAT
%token STRING
%token SHOWTABLE


             
%left '+' '-'
%left '/' '*' MOD
%left '^'
             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line           
;

line:     '\n'
    | declaration
    | reasignation
;
             
declaration: INT CADENA '=' ENTERO ';'  {
  if (isOnTable(table, $2) == FALSE) table = insert_int(table, $2, $4);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| FLOAT CADENA '=' DECIMAL ';'  {
    if (isOnTable(table, $2) == FALSE) table = insert_float(table, $2, $4);
    else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING CADENA '=' CADENA ';'  {
  if (isOnTable(table, $2) == FALSE) table = insert_string(table, $2, $4);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| SHOWTABLE { showTable(table);}
;

reasignation:  CADENA '=' ENTERO ';'  {
  if (isOnTable(table, $1) == TRUE) table = reasignation_int(table, $3, $1);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
|  CADENA '=' DECIMAL ';'  {
    if (isOnTable(table, $1) == TRUE) table = reasignation_float(table, $3, $1);
    else printf("La variable %s no ha sido decalarada\n", $1);
}
|  CADENA '=' CADENA ';'  {
  if (isOnTable(table, $1) == TRUE) table = reasignation_string(table, $3, $1);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
;

%%

int main() {
  yyparse();
  table = createTable();
}
             
void yyerror (char *s)
{
  printf ("--%s--\n", s);
}
            
int yywrap()  
{  
  return 1;  
}

int isOnTable(Symbol table, char * name ) {
  if (isVariableOnTable(table, name) == TRUE) return TRUE;
  else return FALSE;
}