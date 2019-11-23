%{
#include <stdio.h>
#include <stdlib.h>    
#include <math.h>
#include "./table/symbols_table.h"
#include "./utils/utils.h"

int yylex();
void yyerror (char *s);
int isOnTable(Symbol table, char * name );
void initializeValues();

Symbol table;
Values current_values;
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
  initializeValues();
  current_values->int_value = $4;
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2 , current_values , INT_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| INT NAME ';' {
  initializeValues();
  current_values->int_value = 0;
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, INT_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| FLOAT NAME ';' {
  initializeValues();
  current_values->float_value = 0.0;
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, FLOAT_);
    else printf("La variable %s ya ha sido decalarada\n", $2);
}
| FLOAT NAME '=' dec ';'  {
    initializeValues();
    current_values->float_value = $4;
    if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, FLOAT_);
    else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME '=' str ';'  {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($4));
  copyStrings(current_values->string_value, $4);
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, STRING_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME ';'  {
  initializeValues();
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, STRING_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| SHOWTABLE { showTable(table);}
;

reasignation:  NAME '=' exp ';'  {
  initializeValues();
  current_values->int_value = $3;
  if (isOnTable(table, $1) == TRUE) table = reasignation(table, current_values, $1, INT_);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
|  NAME '=' dec ';'  {
  initializeValues();
  current_values->float_value = $3;
  if (isOnTable(table, $1) == TRUE) table = reasignation(table, current_values, $1, FLOAT_);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
|  NAME '=' str ';'  {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($3));
  copyStrings(current_values->string_value, $3);
  if (isOnTable(table, $1) == TRUE) table = reasignation(table, current_values, $1, STRING_);
  else printf("La variable %s no ha sido decalarada\n", $1);
}
| NAME '=' NAME '^' exp ';' {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($3)*$5);
  if ( getType(table, $1) == getType(table , $3)) {
    copyStrings(current_values->string_value, getValue(table, $3));
    copyStrings(current_values->string_value, concatString(current_values->string_value, $5));
    reasignation(table, current_values, $1, STRING_);
  }
}
;

str: CADENA { $$ = $1; }
    | CADENA '+' CADENA { 
      $$ = (char*) malloc(sizeof(char)*(stringLen($1)+stringLen($3)));
      copyStrings($$, concatStrings($1, $3));
    }
    | CADENA '^' exp { 
      $$ = (char*) malloc(sizeof(char)*(stringLen($1)*$3));
      copyStrings($$, concatString($1, $3));
    }
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

void initializeValues() {
  current_values = createValues();
}