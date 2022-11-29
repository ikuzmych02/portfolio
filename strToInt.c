#include "Helpers.h"

/**
 * Main loop that takes inputs from
 * user over command line and uses those.
 * 
 * @param argc Argument count
 * @param argv Array of char pointers (array of strings)
 *
 * @return 0 Function exited successfully
 */
int main(int argc, char** argv) {
    int i;
    printf("Your inputs were as follows: \n");
    for (i = 1; i < argc; i++) {
        printf("%d\t", strToInt(argv[i]));
    }
    //i = strToInt("123");
    return 0;
}

/**
 * This function converts a string representation of an integer
 * to an int type
 * 
 * @param str  Character pointer (string)
 * 
 * @return     Integer representation of the input string
*/
int strToInt(char* str) {
    int res = 0;
    for (int i = 0; i < strlen(str); i++) {
        res += (str[strlen(str) - 1 - i] - '0') * pow(10, i);
    }
    return res;
}