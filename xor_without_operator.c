#include "Helpers.h"

int xor(int a, int b);

int main() {
    int res1, res2, res3, res4;

    res1 = xor(9, 9);
    res2 = xor(12, 0);
    res3 = xor(17, 3);
    res4 = xor(29, 17);
    printf("9 xor 9 is : %d\n", res1); // 0
    printf("12 xor 0 is: %d\n", res2); // 12
    printf("17 xor 3 is: %d\n", res3); // 18
    printf("29 xor 17 is: %d\n", res4); // 12

    return 0;
}

/**
 * This function takes in two integers and find their XOR
 * without using the ^ XOR operator
 * 
 * @param a       Input integer 1
 * @param b       Input integer 2
 * 
 * @return res    Output after doing the XOR of input 1 and input 2
*/
int xor(int a, int b) {
    // Result itself is fairly simple.
    // In an XOR, we can only have one of the numbers be true at any bit position
    // This checks if a & NOT b is true, or if NOT a and b is true. The or
    // gate at the end gets the final result.
    return (a & ~b) | (~a & b);
}