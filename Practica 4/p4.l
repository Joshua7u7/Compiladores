%{
#include "p4.tab.h"
#include <string.h>
%}

NUM [0-9]+
DECIMAL [0-9]+\.[0-9]+
LETRA [a-zA-Z]+
CAD ["][A-Za-z0-9 ]+["]
%%

{NUM}           {
		printf("Numero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                }

{DECIMAL} {
    printf("Numero decimal %s\n", yytext);
    yylval.decimal = atof(yytext);
    return (DECIMAL);
}

"+"|"*"|"/"|"-"|"^"	 	{
		printf("Signo op\n");
                return (yytext[0]);
                }

"("|")" {
    printf("Parentesis\n");
    return(yytext[0]);
}

"," {
    printf("Coma \n");
    return(yytext[0]);
}

[Mm][Oo][Dd] {
    printf("Modulo \n ");
    return (MOD);
}

"\n"            {
		printf("Salto de linea\n");
                return (yytext[0]);
                }

{CAD}           {
		printf("Cadena %s\n",yytext);
                int cont, tam;
                char *a;
                tam=strlen(yytext);
                a=(char*)malloc(tam*sizeof(char));
                for(cont=1; cont<tam-1; cont++){
                    a[cont-1]=yytext[cont];
                }
                yylval.cadena=a;
                return (CADENA);
                }
%%