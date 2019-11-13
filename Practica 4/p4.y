%{
#include <stdio.h>
#include <stdlib.h>    
#include <math.h>

int yylex();
void yyerror (char *s);
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
    float decimal;
    char  string;
}

%token <entero> ENTERO
%token <decimal> DECIMAL
%token <string> STRING
%type <entero> exp
%type <decimal> dec

             
%left '+'
%left '-'
%left '/' 
%left '*'
%left '^'
             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
        | exp '\n'  { printf ("\tresultado: %i\n", $1); }
        | dec '\n'  { printf ("\tresultado: %.2f\n", $1); }
;
             
exp:     ENTERO	{ $$ = $1; }
	  | exp '+' exp         { $$ = $1 + $3;    }
	  | exp '*' exp         { $$ = $1 * $3;	}
    | exp '/' exp         { $$ = $1 / $3;	}
    | exp '-' exp         { $$ = $1 - $3;	}
    | exp '^' exp         { $$ = pow($1,$3); }
    | 'm' exp ',' exp ')' { $$ = fmod($2,$4); }
;

         

dec: DECIMAL {$$ = $1; }
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
    | 'm' dec ',' exp ')' { $$ = fmod($2,$4); } 
    | 'm' exp ',' dec ')' { $$ = fmod($2,$4); } 
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