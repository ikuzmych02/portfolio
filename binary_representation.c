#include "Helpers.h"

void binaryRepresentation(int x);

/**
 * Main loop that takes inputs from
 * user over command line and uses those
 * 
 * @param argc Argument count
 * @param argv Array of char pointers (array of strings)
 *
 * @return 0 Function exited successfully
 */
int main(int argc, char **argv) {

    for (int i = 1; i < argc; i++) {
        binaryRepresentation(strtol(argv[i], NULL, 10));
    }
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
    for (int i = sizeof(int) * 8 - 1; i >= 0; i--) {
        str[i] = ((x >> (31 - i)) & 1) + '0';
    }
    printf("Binary representation of %d is %s\n", x, str);
    free(str);
}
