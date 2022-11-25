#include "Helpers.h"

int multiplyBy3Point5(int x);

int main() {

    printf("%d\n", multiplyBy3Point5(2)); // 7
    printf("%d\n", multiplyBy3Point5(4)); // 14
    printf("%d\n", multiplyBy3Point5(6)); // 21
    printf("%d\n", multiplyBy3Point5(8)); // 28
    
    return 0;
}

/**
 * This function will multiply an integer by 3.5 without using *, /, %
 * 
 * @param x Integer number
 * 
 * @return int Input number multiplied by 3.5
*/
int multiplyBy3Point5(int x) {
    return (x << 2) - (x >> 1); // equivalent to doing: (x * 4) - (x / 2) = x * 3.5
}