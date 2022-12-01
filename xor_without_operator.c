#include "Helpers.h"

int xor(int a, int b);

int main() {
    int res1, res2, res3;

    res1 = xor(9, 9);
    res2 = xor(12, 0);
    res3 = xor(17, 3);
    printf("9 xor 9 is : %d\n", res1);
    printf("12 xor 0 is: %d\n", res2);
    printf("17 xor 3 is: %d\n", res3);

    return 0;
}

int xor(int a, int b) {
    int res = 0;

    for (int i = 0; i < sizeof(int) * 8; i++) {
        if (((a >> i) & 1) != ((b >> i) & 1))
            res |= 1 << i;
    }
    return res;
}

/**
 * 1001 ^ 1001 = 0000
 * 1100 ^ 0000 = 1100
 * 010001 ^ 000011 = 010010 -> 18
*/