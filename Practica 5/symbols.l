%{
#include "symbols.tab.h"
#include "utils.h"
%}

NUM [0-9]+
DECIMAL [0-9]+\.[0-9]+
VARIABLE [a-zA-Z_]+[0-9]*[a-zA-Z_]*
CAD ["][A-Za-z0-9 ]+["]
%%

{NUM}   {
            yylval.entero = atoi(yytext); 
            return (ENTERO); 
        }

{DECIMAL} {
     yylval.decimal = atof(yytext); 
     return (DECIMAL); 
}

"+"|"*"|"/"|"-"|"^"	 	{
        return (yytext[0]);
    }

[Mm][Oo][Dd] {
    return (MOD);
}

"("|")" {
    return(yytext[0]); 
}

","|";" {
    return(yytext[0]); 
}

"=" {
    return(yytext[0]); 
}

"int" {
    return(INT);
}

"float" {
    return(FLOAT);
}

"char"[ ]*"*" {
    return(STRING); 
}

"show_table" {
    return (SHOWTABLE);
}
{VARIABLE} {
    int cont, tam;
    char * a;
    tam = strlen(yytext);
    a = (char*)malloc(tam*sizeof(char));
    for (cont = 0; cont<tam; cont++) {
        a[cont]=yytext[cont];
    }
    yylval.cadena = a; 
    return(NAME);
}

"\n" {
    return (yytext[0]);
    }

{CAD} {	
    int cont, tam;
    char *a;
    tam = strlen(yytext);
    a = (char*)malloc(tam*sizeof(char));
    for (cont = 1; cont<tam-1; cont++) {
        a[cont-1]=yytext[cont];
    }
    yylval.cadena=a; 
    return (CADENA); 
    }
%%