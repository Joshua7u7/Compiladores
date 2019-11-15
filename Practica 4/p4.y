%{
#include <stdio.h>
#include <stdlib.h>    
#include <string.h>
#include <math.h>

int yylex();
void yyerror (char *s);
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
%type <entero> exp
%type <decimal> dec
%type <cadena> cad


             
%left '+' '-'
%left '/' '*' MOD
%left '^'
             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
        | exp '\n'  { printf ("\tresultado: %i\n", $1); }
        | dec '\n'  { printf ("\tresultado: %.2f\n", $1); }
        | cad '\n'  { printf ("\tresultado: %s\n", $1); }
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

cad :   CADENA{$$ = $1;}
    | cad '+' cad { $$ = strcat($1,$3); }
;
%%

int main() {
  yyparse();
}
             
void yyerror (char *s)
{
  printf ("--%s--\n", s);
}
            
int yywrap()  
{  
  return 1;  
}  