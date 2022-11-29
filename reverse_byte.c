#include "Helpers.h"

uint8_t reverseByte(uint8_t byte);

int main() {

    uint8_t x = reverseByte(0xF1); // should return 8F
    printf("%x\n", x);
    return 0;
}

/**
 * This function takes in a byte and reverses it
 * 
 * @param byte         Single byte
 * 
 * @return reversed    Result after reversing
*/
uint8_t reverseByte(uint8_t byte) {
    char reversed = 0x00;
    int i;
    for (i = 0; i < sizeof(uint8_t) * 8; i++) {
        reversed = reversed | (((byte >> i) & 1) << (7 - i));
    }
    return reversed & 0xFF;
}