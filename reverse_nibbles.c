#include "Helpers.h"

uint32_t reverseNibbles(uint32_t num);

int main() {

    uint32_t x = reverseNibbles(0x12345678); // should return 0x87654321
    printf("%x\n", x);
    return 0;
}

/**
 * This function takes in a 32-bit unsigned int and reverses the half-octets
 * 
 * @param num          32-bit unsigned int
 * 
 * @return reversed    Result after reversing
*/
uint32_t reverseNibbles(uint32_t num) {
    uint32_t reversed = 0x00000000;
    int i;
    for (i = 0; i < sizeof(uint32_t) * 2; i++) { // 8 total loops for 8-half bytes in our number
        reversed |= ((num >> (i * 4)) & 0xF) << (32 - (i + 1) * 4);
    }
    return reversed;
}