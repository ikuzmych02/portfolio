#include <stdio.h>
#include <stdlib.h>

/**
 * Simple algorithm to add two numbers
 * without using arithmetic operators
 * 
 * @param x First integer to add
 * @param y Second integer to add
*/
int addBitwise(int x, int y) {

    while (y != 0) {
        unsigned carry = x & y;
        x = x ^ y;
        y = carry << 1;
    }

    return x;
}


int main() {

    printf("%d\n", addBitwise(1, 2));
    printf("%d\n", addBitwise(44, 22));
    return 0;
}