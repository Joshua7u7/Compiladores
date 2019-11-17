#include <stdio.h>
#include <stdlib.h>
#include "utils.h"


void copyStrings(char * target, char * to_copy) {
    char * to_copy_clone = to_copy;
    for (; *to_copy_clone != '\0'; to_copy_clone++) {
        *target = * to_copy_clone;
        target++;
    }
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