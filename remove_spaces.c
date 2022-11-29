#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* removeSpaces(char* str);

int main(int argc, char** argv) {
    //char* input = (char*) malloc(strlen(argv[1]) + 1);
    //strcpy(input, argv[1]);
    char* s = removeSpaces(argv[1]);
    printf("%s\n", s);

    free(s);
    return 0;
}

/**
 * This function takes a string and removes spaces
 * 
 * @param str          Input string
 * 
 * @return newStr      New output string
*/
char* removeSpaces(char* str) {
    char* newStr = (char*) malloc(strlen(str));
    int x = 0; // offset for each space
    
    int i;
    for (i = 0; i < strlen(str); i++) {
        if (str[i] != 32) { // if it is not a space character
            newStr[i - x] = str[i]; // copy over that character to our new string
        } else {
            x++; // increase the space offset
        }
    }
    return newStr;
}