#include "Helpers.h"

int unsetRightmostBit(unsigned int x);

int main() {

    printf("%d\n", unsetRightmostBit(12)); // 8
    printf("%d\n", unsetRightmostBit(9));  // 8
    printf("%d\n", unsetRightmostBit(116)); // 112

    return 0;
}

/**
 * This function unsets the right-most bit in a given integer
 * 
 * @param x Input integer
 * 
 * @return  The result after unsetting the rightmost bit
*/
int unsetRightmostBit(unsigned int x) {
    
    return x & (x - 1);
}