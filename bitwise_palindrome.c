#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TRUE 1
#define FALSE 0
#define MSB_MASK (0x80000000)
#define LSB_MASK (0x00000001)

/**
 * Implementation will assume unsigned int.
 * 
 * @param num An unsigned integer
*/
int isBitPalindrome(unsigned int num) {
    unsigned int reversed = 0;

    for (int i = 0; i < sizeof(unsigned int) * 4; i++) { // O(n/2) where n is the size of the input
        reversed |= ((MSB_MASK >> i) & num) >> ( 31 - i * 2); // populate bottom 2 bytes of reversed
        reversed |= ((LSB_MASK << i) & num) << ( 31 - i * 2); // populate MSB 2 bytes of reversed
    }

    printf("%x\n", reversed);
    return (num == reversed) ? TRUE: FALSE;
}

int main() {
    int test1, test2, test3, test4;

    test1 = isBitPalindrome(0xF000000F); // TRUE
    test2 = isBitPalindrome(0x80000001); // TRUE
    test3 = isBitPalindrome(0x10000008); // TRUE
    test4 = isBitPalindrome(0x10000001); // FALSE
    printf("Our results: %d  %d  %d  %d\n", test1, test2, test3, test4);

    return 0;
}