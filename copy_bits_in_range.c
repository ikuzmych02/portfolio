#include "Helpers.h"

void copySetBitsInRange(int *x, int y, int l, int r);

int main() {
    int x = 10, x2 = 8;

    copySetBitsInRange(&x, 13, 2, 3);
    copySetBitsInRange(&x2, 7, 1, 2);

    printf("%d\n", x); // 14
    printf("%d\n", x2); // 11
    return 0;
}

/**
 * This function takes two inputs, and copies the set bits
 * in the specified range from y into the same range in x
 * Where l >= 1 and r <= 32
 * Example: x = 10 (1010), y = 13 (1101), l = 2, r = 3
 * Output: x = 14 (1110) because third bit from left in y is set
 * 
 * @param x    Pointer to x address
 * @param y    Value from which we want to get range of bits to set in x
 * @param l    Least-significant position in range
 * @param r    Most-significant position in range
 * 
*/
void copySetBitsInRange(int *x, int y, int l, int r) {
    int mask = (1 << (r - l)) + (1 << (r - l)) - 1;
    *x = (l == 1) ? *x | (mask & y) : *x | (mask << (r - 1)) & y;
}