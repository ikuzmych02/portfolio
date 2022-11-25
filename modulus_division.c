#include "Helpers.h"

int modulusDivision(int n, int d);


int main() {

    printf("%d\n", modulusDivision(17, 4)); // 1
    printf("%d\n", modulusDivision(17, 16)); // 1
    printf("%d\n", modulusDivision(26, 2)); // 0
    printf("%d\n", modulusDivision(29, 16)); // 13
    
    return 0;
}

/**
 * Function performs modulus division of two inputs, where d is always a power-of-two number
 * 
 * @param n Left-most operand
 * @param d Right-most operand
 * 
 * @return n % d
*/
int modulusDivision(int n, int d) {
    return (n & (d - 1));
}