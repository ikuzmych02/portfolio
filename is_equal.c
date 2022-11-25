#include "Helpers.h"

int isEqual(int x, int y);

int main() {

    printf("%d\n", isEqual(1, 1)); // 1
    printf("%d\n", isEqual(2, 12)); // 0
    return 0;
}

/**
 * Function to check if two numbers are equal without using comparison operators
 * 
 * @param x  First integer input
 * @param y  Second integer input
 * 
 * @return 0 Numbers are NOT equal
 * @return 1 Numbers are equal
*/
int isEqual(int x, int y) {
    return (x ^ y) ? 0 : 1;
}
