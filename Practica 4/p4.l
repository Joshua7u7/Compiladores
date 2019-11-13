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
%%