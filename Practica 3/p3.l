variable_names ([a-zA-Z_]+[0-9]*)+
positive_number ([1-9]+0*)+
negative_number -{positive_number}
potencia "^"
suma "+"
resta "-"
modulo "%"
positive_decimal {positive_number}\.({positive_number})*
negative_decimal {negative_number}\.({positive_number})*
base {positive_number}|{positive_decimal}|{negative_number}|{negative_decimal}
exponente {positive_number}|{positive_decimal}|{negative_number}|{negative_decimal}
%%
{variable_names} {printf("Nombre de variable");}
{positive_number} {printf("Numero positivo");}
{negative_number} {printf("Numero negativo");}
{positive_decimal} {printf("Numero positivo decimal");}
{negative_decimal} {printf("Numero negativo decimal");}
{base}{potencia}{exponente} {printf("potencia");}
