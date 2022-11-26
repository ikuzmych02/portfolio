#include "Helpers.h"

char swapNibbles(char byte);

int main() {

    printf("%x\n", swapNibbles(0xF1));
    return 0;
}

/**
 * This function swaps two nibbles (half a byte) in a single byte.
 * For example, F1 -> 1F
 * 
 * @param byte    Single byte
 * 
 * @return        Result of swapping them
*/
char swapNibbles(char byte) {
    return ((byte & 0x0F) << 4) | ((byte & 0xF0) >> 4);
}