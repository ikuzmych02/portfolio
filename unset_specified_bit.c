#include "Helpers.h"

int unsetBit(int x, int bitPos);

int main() {
    int num1 = 15, num2 = 14;
    
    printf("%d\n", unsetBit(num1, 1));   // 14
    printf("%d\n", unsetBit(num2, 1));   // 14
    printf("%d\n", unsetBit(num1, 2));   // 13
    printf("%d\n", unsetBit(num1, 3));   // 11
    printf("%d\n", unsetBit(num1, 4));   // 7
    printf("%d\n", unsetBit(num1, 5));   // 15
    return 0;
}

/**
 * This function takes an integer input and a bit
 * in range [1, 32], and "turns off" that bit
 * in integer input.
 * 
 * @param x        Integer input
 * @param bitPos   Bit position
*/
int unsetBit(int x, int bitPos) {

    // Solution: get 0 surrounded by 1's by doing XOR
    // of 1 shifted in to the position with all 1s.
    // This will toggle that bit.
    // Perform bitwise AND with x to unset that bit
    return x & ((1 << (bitPos - 1)) ^ 0xFFFFFFFF);
}