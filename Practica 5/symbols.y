%{
#include <stdio.h>
#include <stdlib.h>    
#include <string.h>
#include <math.h>
#include "symbols_table.h"
#include "utils.h"

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
%token <cadena> NAME
%token MOD
%token INT
%token FLOAT
%token STRING
%token SHOWTABLE
%type <entero> exp
%type <decimal> dec
%type <cadena> str

             
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
    | str
    | exp
    | dec
;
             
declaration: INT NAME '=' exp ';'  {
  if (isOnTable(table, $2) == FALSE) table = insert_int(table, $2, $4);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| INT NAME ';' {
  if (isOnTable(table, $2) == FALSE) table = insert_int(table, $2, 0);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| FLOAT NAME ';' {
  if (isOnTable(table, $2) == FALSE) table = insert_float(table, $2, 0.0);
    else printf("La variable %s ya ha sido decalarada\n", $2);
}
| FLOAT NAME '=' dec ';'  {
    if (isOnTable(table, $2) == FALSE) table = insert_float(table, $2, $4);
    else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME '=' CADENA ';'  {
  if (isOnTable(table, $2) == FALSE) table = insert_string(table, $2, $4);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME ';'  {
  if (isOnTable(table, $2) == FALSE) table = insert_string(table, $2, "");
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| SHOWTABLE { showTable(table);}
;

reasignation:  NAME '=' exp ';'  {
  if (isOnTable(table, $1) == TRUE) table = reasignation_int(table, $3, $1);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
|  NAME '=' dec ';'  {
    if (isOnTable(table, $1) == TRUE) table = reasignation_float(table, $3, $1);
    else printf("La variable %s no ha sido decalarada\n", $1);
}
|  NAME '=' CADENA ';'  {
  if (isOnTable(table, $1) == TRUE) table = reasignation_string(table, $3, $1);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
| NAME '=' NAME '^' exp ';' {
  if ( getType(table, $1) == getType(table , $3)) {
    char * value = (char*)malloc(sizeof(char)*stringLen($3)*$5);
    copyStrings(value, getValue(table, $3));
    copyStrings(value, concatString(value, $5));
    reasignation_string(table, value, $1);
  }
}
;

str: CADENA { $$ = $1; }
    | CADENA '^' exp { printf("YA estamos bien "); }
;
exp:     ENTERO	{ $$ = $1; }
	  | exp '+' exp         { $$ = $1 + $3;    }
	  | exp '*' exp         { $$ = $1 * $3;	}
    | exp '/' exp         { $$ = $1 / $3;	}
    | exp '-' exp         { $$ = $1 - $3;	}
    | exp '^' exp         { $$ = pow($1,$3); }
    | MOD'(' exp ',' exp ')' { $$ = fmod($3,$5); }
;

dec: DECIMAL {$$ = $1; }
    | dec '+' dec         { $$ = $1 + $3;    }
	  | dec '*' dec         { $$ = $1 * $3;	}
    | dec '/' dec         { $$ = $1 / $3;	}
    | dec '-' dec         { $$ = $1 - $3;	}
    | dec '^' dec         { $$ = pow($1,$3); }
    | MOD'(' dec ',' dec ')' { $$ = fmod($3,$5); }
    | dec '+' exp        { $$ = $1 + $3;    }
    | exp '+' dec        { $$ = $1 + $3;    }
	  | dec '*' exp        { $$ = $1 * $3;	}
    | exp '*' dec        { $$ = $1 * $3;	}
    | dec '/' exp        { $$ = $1 / $3;	}
    | exp '/' dec        { $$ = $1 / $3;	}
    | dec '-' exp        { $$ = $1 - $3;	}
    | exp '-' dec        { $$ = $1 - $3;	}
    | dec '^' exp        { $$ = pow($1,$3); }
    | exp '^' dec        { $$ = pow($1,$3); }
    | MOD'(' dec ',' exp ')' { $$ = fmod($3,$5); } 
    | MOD'(' exp ',' dec ')' { $$ = fmod($3,$5); } 
;
%%

int main() {
  yyparse();
  table = createTable();
}
             
void yyerror (char *s)
{
  printf ("-- La expresión no es correcta --\n");
}
            
int yywrap()  
{  
  return 1;  
}

int isOnTable(Symbol table, char * name ) {
  if (isVariableOnTable(table, name) == TRUE) return TRUE;
  else return FALSE;
}