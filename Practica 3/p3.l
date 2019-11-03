variable_names ([a-zA-Z_]+[0-9]*)+
positive_number ([1-9]+0*)+
negative_number -{positive_number}
potencia "^"
suma "+"
resta "-"
positive_decimal {positive_number}\.({positive_number})*
negative_decimal {negative_number}\.({positive_number})*
base {positive_number}|{positive_decimal}|{negative_number}|{negative_decimal}
exponente {positive_number}|{positive_decimal}|{negative_number}|{negative_decimal}
%%
{variable_names} {printf("\nNombre de variable\n");}
{positive_number} {printf("\nNumero positivo");}
{negative_number} {printf("\nNumero negativo");}
{positive_decimal} {printf("\nNumero positivo decimal");}
{negative_decimal} {printf("\nNumero negativo decimal");}
{base}{potencia}{exponente} {printf("\npotencia");}
{base}{suma}{base} {printf("\nsuma");}
{base}{resta}{base} {printf("\nresta");}
{base}"MOD("{base}")" {printf("\nmodulo");}
