#include "Helpers.h"

int findParity(int num);

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
        printf("The parity of %d is %s\n", x, (findParity(x) ? "odd" : "even"));
    }
    return 0;
}

/**
 * This function takes an integer and returns its parity
 * 
 * @param num   Input integer
 * 
 * @return 0    Input integer has an EVEN parity
 * @return 1    Input integer has an ODD parity
*/
int findParity(int num) {
    int parity = 0; // parity set to 0 by default. will toggle to 1 if there is odd number of bits
    int i;
    for (i = 0; i < sizeof(int) * 8; i++) {
        if ((num >> i) & 1) { // We have a bit
            parity = parity ^ 1; // toggle parity
        }
    }

    return parity;
}