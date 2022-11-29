#include "Helpers.h"

#define TOGGLE_EVERY_BIT 0xFFFFFFFF

int absoluteValue(int num);

/**
 * Main loop that takes inputs from
 * user over command line and uses those.
 * 
 * @param argc Argument count
 * @param argv Array of char pointers (array of strings)
 *
 * @return 0 Function exited successfully
 */
int main(int argc, char **argv) {
    int x;
    for (int i = 1; i < argc; i++) {
        x = (int) strtol(argv[i], NULL, 10);
        printf("The absolute value of %d is %d\n", x, absoluteValue(x));
    }
    return 0;
}

/**
 * This function finds absolute value of a number without explicitly
 * checking if (num < 0)
 * 
 * @param num    Input number
 * 
 * 
*/
int absoluteValue(int num) {
    int result;
    if ((num >> 31) & 1 == 1) { // number is negative
        result = (num ^ 0xFFFFFFFF) + 1;
        return result;
    }
    return num;
}