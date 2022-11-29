#include "Helpers.h"

int swapBitsByPosition(unsigned int num, int pos1, int pos2);

int main() {

    int x = swapBitsByPosition(9, 0, 1); // input 1001 -> output 1010
    printf("%d\n", x);

    return 0;
}

/**
 * @brief This function takes three inputs, and swaps the specified bits in an integer
 * 
 * @param num     Number we want to swap bits
 * @param pos1    Right-most position
 * @param pos2    Left-most position
 * 
 * @return int    Result after swapping bits in specified positions
 */
int swapBitsByPosition(unsigned int num, int pos1, int pos2) {
    int bit1, bit2;
    int x;
    bit1 = (num >> pos1) & 1;
    bit2 = (num >> pos2) & 1;
    x = bit1 ^ bit2;
    x = (x << pos1) | (x << pos2);

    return x ^ num;
}
