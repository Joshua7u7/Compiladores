%{
#include "p4.tab.h"
#include <string.h>
%}

NUM [0-9]+
DECIMAL [0-9]+\.[0-9]+
LETRA [a-zA-Z]+
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

"mod(" {
    printf("Modulo 1\n ");
    return (yytext[0]);
}

"," {
    printf("Separador\n");
    return (yytext[0]);
}

")" {
    printf("Terminador de modulo\n");
    return (yytext[0]);
}

"\n"            {
		printf("Salto de linea\n");
                return (yytext[0]);
                }
%%