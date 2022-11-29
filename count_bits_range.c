#include "Helpers.h"

int setBitsInRange(int range);
int countBits(int x);

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
        printf("The number of set bits from 1 to %d is %d\n", x, setBitsInRange(x));
    }
    return 0;
}

/**
 * This function takes in an input "range" and finds the 
 * count of the total set bits in first "range" positive numbers starting from 1
 * O(32 * n) time complexity -> O(n) time complexity
 * 
 * @param range  Range of numbers to process
 * 
 * @return       Total count of set bits
*/
int setBitsInRange(int range) {
    int count = 0;
    for (int i = 1; i <= range; i++) {
        count += countBits(i);
    }
    return count;
}

/**
 * Utility function. Counts number of set bits in a single number
 * 
 * @param x  Input integer
 * 
 * @return   Count of set bits in input integer
*/
int countBits(int x) {
    int count = 0;
    for (int i = 0; i < 32; i++) {
        if ((x >> i) & 1)
            count++;
    }
    return count;
}