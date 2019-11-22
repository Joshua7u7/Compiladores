#include <stdio.h>

#ifndef utils
#define utils

#define TRUE 1
#define FALSE 2

void copyStrings(char * , char * );
void handleError(char * );
int isTheSameString(char * , char * );
int stringLen(char *);
char * concatString(char * string, int number);

#endif