#include "Helpers.h"

int russianPeasant(int x, int y);

int main() {
    
    printf("%d\n", russianPeasant(12, 12));
    return 0;
}

/**
 * Multiply two numbers without using multiply operator
 * 
 * @param x Operand 1
 * @param y Operand 2
 * 
 * @return x Result of the muliplication
*/
int russianPeasant(int x, int y) {
    int result;
    while (y > 0) {
        if (y & 1) { // if second number is odd, add to result. Is odd if bottom bit is a 1
            result = result + x;
        }
        x <<= 1;
        y >>= 1;
    }
    return result;
}