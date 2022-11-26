#include "Helpers.h"

int findOnlySetBit(int num);

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
        printf("The only set bit in %d is at position %d\n", x, findOnlySetBit(x));
    }
    return 0;
}

/**
 * This function finds the only set bit in an integer
 * 
 * @param num Integer to find set position of
 * 
 * @return -1         The number has more than one set bit or no set bits
 * @return position   Position of set bit (going from left to right and starting index being 0)
*/
int findOnlySetBit(int num) {
    int pos = 0, count = 0;
    int i;
    for (i = 0; i < sizeof(int) * 8; i++) {
        if ((num >> i) & 0x1) {
            count++;
            pos = i;
        }
    }
    return (count == 1) ? pos: -1; // if there are more than 1 set bit, or 0, return -1
}