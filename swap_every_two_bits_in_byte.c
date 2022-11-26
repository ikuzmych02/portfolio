#include "Helpers.h"

uint8_t swapEveryTwoBits(uint8_t byte);

int main() {

    // Test case 1. Expands out to: 01 11 10 01
    //           Should convert to: 10 11 01 10
    printf("%x\n", swapEveryTwoBits(0x79)); // output should be B6
    return 0;
}


/**
 * Function that swaps bits in a byte in pairs.
 * For ex: 01 11 10 01 -> 10 11 01 10
 * 
 * @param byte Input byte
 * 
 * @return     Result after swaps
*/
uint8_t swapEveryTwoBits(uint8_t byte) {
    // Extracting the high bit shift it to lowbit
    // Extracting the low bit shift it to highbit
    return ((byte & 0xAA) >> 1) | ((byte & 0x55) << 1); 
}