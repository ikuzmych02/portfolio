#include "Helpers.h"

void binaryRepresentation(int x);

int main(int argc, char **argv) {

    for (int i = 1; i < argc; i++) {
        binaryRepresentation(strtol(argv[i], NULL, 10)); // 000...01001
    }
    //binaryRepresentation(9);
    return 0;
}

/**
 * This function takes in an int and prints its binary form
 * 
 * @param x Input integer we want to convert to a binary representation
 * 
*/
void binaryRepresentation(int x) {
    char* str = (char*) malloc(sizeof(int) * 8 + 1); // allocate memory for the string
    char c;
    for (int i = 0; i < sizeof(int) * 8; i++) {
        str[i] = (((1 << (31 - i)) & x) >> (31 - i)) + '0';
        c = str[i];
    }
    printf("Binary representation of %d is %s\n", x, str);
    free(str);
}