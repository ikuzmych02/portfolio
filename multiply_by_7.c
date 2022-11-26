#include "Helpers.h"

int multiplyBySeven(int x);

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
        printf("%d Multiplied by seven is equal to: %d\n", x, multiplyBySeven(x));
    }
    return 0;
}

/**
 * This function efficiently multiplies a number by seven
 * without using *, / operators
 * 
 * @param x Input integer to multiply
 * 
 * @return  Result of the calculation.
*/
int multiplyBySeven(int x) {

    // shift left by 3 to multiply by 8 (2 to power of 3), then subtract original x
    return (x << 3) - x;
}