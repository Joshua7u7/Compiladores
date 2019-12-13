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
int verifyToIntType(char* name1, char* name2);
int * getValuesInt(char * name1, char * name2);
int verifyToFloatTypes(char* name1, char* name2);
int verifyFloatType(char * name);
float * getValuesFloat(char * name1, char * name2);

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
%token IF
%type <cadena> str
%type <cadena> str_strings
%type <entero> exp
%type <decimal> dec

             
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
    | str_strings
    | exp
    | dec
    | conditionals
;
             
declaration:  STRING NAME '=' str ';'  {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($4));
  copyStrings(current_values->string_value, $4);
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, STRING_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME '=' str_strings ';' {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($4));
  copyStrings(current_values->string_value, $4);
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, STRING_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| INT NAME '=' exp ';'  {
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
| STRING NAME ';'  {
  initializeValues();
  if (isOnTable(table, $2) == FALSE) table = insert(table, $2, current_values, STRING_);
  else printf("La variable %s ya ha sido decalarada\n", $2);
}
| STRING NAME '=' exp ';' {
  printf("Lo siento no se puede asignar un tipo int a un string\n");
}
| STRING NAME '=' dec ';' {
  printf("Lo siento no se puede asignar un tipo float a un string\n");
}
| INT NAME '=' str ';' {
  printf("Lo siento no se puede asignar un tipo string a un int\n");
}
| FLOAT NAME '=' str ';' {
  printf("Lo siento no se puede asignar un tipo string a un float\n");
}
| INT NAME '=' dec ';' {
  printf("Lo siento no se puede asignar un tipo float a un int\n");
}
| SHOWTABLE { showTable(table);}
;

reasignation:  NAME '=' exp ';'  {
  initializeValues();
  if (isOnTable(table, $1) == TRUE && getType(table, $1) == INT_) {
    current_values->int_value = $3;
    table = reasignation(table, current_values, $1, INT_);
  } else if (isOnTable(table, $1) != TRUE) printf("La variable %s no ha sido decalarada\n", $1);
  else printf("La variable %s no es de tipo int ", $1);
}
|  NAME '=' dec ';'  {
  initializeValues();
  if (isOnTable(table, $1) == TRUE && getType(table, $1) == FLOAT_)  {
    current_values->float_value = $3;
    table = reasignation(table, current_values, $1, FLOAT_);
  } else if (isOnTable(table, $1) != TRUE) printf("La variable %s no ha sido decalarada\n", $1);
  else printf("La variable %s no es de tipo float", $1);
}
|  NAME '=' str ';'  {
  initializeValues();
  if (isOnTable(table, $1) == TRUE && getType(table, $1) == STRING_) {
    current_values->string_value = (char*)malloc(sizeof(char)*stringLen($3));
    copyStrings(current_values->string_value, $3);
    table = reasignation(table, current_values, $1, STRING_);
  } else if (isOnTable(table, $1) != TRUE) printf("La variable %s no ha sido decalarada\n", $1);
  else printf("La variable %s no es de tipo string\n", $1);
}
| NAME '=' NAME '^' exp ';' {
  initializeValues();
  current_values->string_value = (char*)malloc(sizeof(char)*stringLen($3)*$5);
  if ( getType(table, $1) == getType(table , $3)) {
    current_values = getValue(table, $3, current_values);
    copyStrings(current_values->string_value, concatString(current_values->string_value, $5));
    reasignation(table, current_values, $1, STRING_);
  }
}
;

conditionals: IF '(' exp '=' '=' exp ')' {
  if ($3 == $6) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '=' '=' dec ')' {
  if ($3 == $6) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '=' '=' exp ')' {
  if ($3 == $6) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' exp '=' '=' dec ')' {
  if ($3 == $6) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' exp '<' exp ')' {
  if ($3 < $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '<' dec ')' {
  if ($3 < $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '<' exp ')' {
  if ($3 < $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' exp '<' dec ')' {
  if ($3 < $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' exp '>' exp ')' {
  if ($3 > $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '>' dec ')' {
  if ($3 > $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' dec '>' exp ')' {
  if ($3 > $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' exp '>' dec ')' {
  if ($3 > $5) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
| IF '(' str '=' '=' str ')' {
  if ( isTheSameString( $3 , $6) == TRUE ) printf("\nTRUE\n");
  else printf("\nFALSE\n");
}
;

exp: ENTERO	{ $$ = $1; }
    | NAME { 
      if (isVariableOnTable(table, $1) == TRUE) {
        if ( getType(table, $1) == INT_) {
          initializeValues();
          current_values = getValue(table, $1, current_values);
          $$ = current_values->int_value;
        } 
        else if (getType(table, $1) == FLOAT_){
          initializeValues();
          current_values = getValue(table, $1, current_values);
          $$ = (int)current_values->float_value;
        } else {
          printf("El tipo string no es asignable al tipo int ni float\n");
          //current_values = getValue(table, $1, current_values);
          //$$ = (char*)malloc(sizeof(char)*stringLen(current_values->string_value));
          //copyStrings($$, current_values->string_value);
          $$ = 0;
        }
      } else {
        printf("La variable %s no ha sido declarada\n", $1);
        $$ = 0;
      }
    }
	  | exp '+' exp         { $$ = $1 + $3; }
	  | exp '*' exp         { $$ = $1 * $3;	}
    | exp '/' exp         { $$ = $1 / $3;	}
    | exp '-' exp         { $$ = $1 - $3;	}
    | exp '^' exp         { $$ = pow($1,$3); }
    | MOD'(' exp ',' exp ')' { $$ = fmod($3,$5); }
;

dec: DECIMAL {$$ = $1; }
    | exp { $$ = (float)$1; }
    | dec '+' dec         { $$ = $1 + $3;    }
	  | dec '*' dec         { $$ = $1 * $3;	}
    | dec '/' dec         { $$ = $1 / $3;	}
    | dec '-' dec         { $$ = $1 - $3;	}
    | dec '^' dec         { $$ = pow($1,$3); }
    | MOD'(' dec ',' dec ')' { $$ = fmod($3,$5); }
    | exp '+' dec        { $$ = $1 + $3;    }
    | exp '*' dec        { $$ = $1 * $3;	}
    | exp '/' dec        { $$ = $1 / $3;	}
    | exp '-' dec        { $$ = $1 - $3;	}
    | exp '^' dec        { $$ = pow($1,$3); }
    | MOD'(' dec ',' exp ')' { $$ = fmod($3,$5); } 
    | MOD'(' exp ',' dec ')' { $$ = fmod($3,$5); } 
;

str_strings: NAME {
      if (isVariableOnTable(table, $1) == TRUE) {
        if ( getType(table, $1) == STRING_) {
          initializeValues();
          current_values = getValue(table, $1, current_values);
          $$ = (char*) malloc (sizeof(char)*stringLen(current_values->string_value));
          copyStrings($$, current_values->string_value);
        } else {
          printf("El tipo de dato no es compatible, por lo que se le asignará una cadena vacía\n");
          $$ = (char*) malloc (sizeof(char)*2);
          copyStrings($$, "");
        }
      } else {
        printf("La variable %s no ha sido declarada\n", $1);
        $$ = "";
      }
    }
    | str_strings '+' str_strings { 
      int tam = stringLen($1)+ stringLen($3);
      $$ = (char*)malloc(sizeof(char)*tam);
      concatStrings($1, $3);
      copyStrings($$, $1);
    }
;
str: CADENA { $$ = $1; }
    | str '^' exp {
      if ($3 < 0) {
        stringReverse($1); 
        $3 = $3 * -1;
      }
      $$ = (char*) malloc(sizeof(char)*(stringLen($1)*$3));
      copyStrings($$, concatString($1, $3));
    }
    | NAME {
      if (isVariableOnTable(table, $1) == TRUE) {
        if ( getType(table, $1) == STRING_) {
          initializeValues();
          current_values = getValue(table, $1, current_values);
          $$ = (char*) malloc (sizeof(char)*stringLen(current_values->string_value));
          copyStrings($$, current_values->string_value);
        } else {
          printf("El tipo de dato no es compatible, por lo que se le asignará una cadena vacía\n");
          $$ = (char*) malloc (sizeof(char)*2);
          copyStrings($$, "");
        }
      } else {
        printf("La variable %s no ha sido declarada\n", $1);
        $$ = "";
      }
    }
    | CADENA '+' str {
      $$ = (char*) malloc(sizeof(char)*(stringLen($1)+stringLen($3)));
      copyStrings($$, concatStrings($1, $3));
    }
    | str '+' str {
      $$ = (char*) malloc(sizeof(char)*(stringLen($1)+stringLen($3)));
      copyStrings($$, concatStrings($1, $3));
    }
;
%%

int main() {
  yyparse();
  table = createTable();
}
             
void yyerror (char *s)
{
  printf ("-- %s --\n", s);
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

int verifyToIntType(char* name1, char* name2) {
  if ( getType(table, name1) == INT_ && getType(table , name2) == INT_) return TRUE;
  else return FALSE;
}

int verifyFloatType(char * name) {
  int type = getType(table, name);
  if ( type == INT_ || type == FLOAT_) return TRUE;
  else return FALSE;
}

int verifyToFloatTypes(char* name1, char* name2) {
  int response = FALSE;
  int type_1 = getType(table, name1);
  int type_2 = getType(table, name2);
  if ( type_1 == INT_ && type_2 == INT_) response = TRUE;
  else if ( type_1 == INT_ && type_2 == FLOAT_) response = TRUE;
  else if ( type_1 == FLOAT_ && type_2 == FLOAT_) response = TRUE;
  else if ( type_1 == FLOAT_ && type_2 == INT_) response = TRUE;
  return response;
}

int * getValuesInt(char * name1, char * name2) {
  initializeValues();
  int total_results = 2;
  int * results = (int*)malloc(sizeof(int) * total_results);
  if ( verifyToIntType(name1, name2) == TRUE ) {
    current_values = getValue(table, name1, current_values);
    results[0] = current_values->int_value;
    current_values = getValue(table, name2, current_values);
    results[1] = current_values->int_value;
  }
  return results;
}

float * getValuesFloat(char * name1, char * name2) {
  initializeValues();
  int total_results = 2;
  float * results = (float*)malloc(sizeof(float) * total_results);
  if ( verifyToFloatTypes(name1, name2) == TRUE ) {
    current_values = getValue(table, name1, current_values);
    results[0] = current_values->float_value;
    current_values = getValue(table, name2, current_values);
    results[1] = current_values->float_value;
  }
  return results;
}