#include <stdio.h>
#include <stdlib.h>
#include "utils.h"


void copyStrings(char * target, char * to_copy) {
    char * to_copy_clone = to_copy;
    char * target_clone = target;
    for (; *target_clone != '\0'; target_clone++) * target_clone = ' ';
    for (; *to_copy_clone != '\0'; to_copy_clone++) {
        *target = * to_copy_clone;
        target++;
    }
}

char * concatString(char * string, int number) {
    char * value = (char *)malloc(sizeof(char)*stringLen(string)*number+1);
    char * value_aux = value;
    for (int i = 0; i < number; i++) {
        char * auxiliar = string;
        while (* auxiliar != '\0') {
            * value = * auxiliar;
            value++;
            auxiliar++;
        }
    }
    return value_aux;
}

int isTheSameString(char * string_1, char * string_2) {
    char * current_char_string_1 = string_1;
    char * current_char_string_2 = string_2;
    int response = TRUE;
    if (stringLen(string_1) != stringLen(string_2)) response = FALSE;
    else {
        for (; *current_char_string_1 != '\0'; current_char_string_1++, current_char_string_2++) {
            if (* current_char_string_2 != * current_char_string_1) {
                response = FALSE;
                break;
            }
        }
    }
    return response;
}

int stringLen(char * string) {
    int counter = 0;
    char * current_char = string;
    while(* current_char != '\0'){
        current_char ++;
        counter++;
    }
    return counter;
}

void handleError(char * error) {
    printf("%s \n",error);
    exit(EXIT_FAILURE);
}