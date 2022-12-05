#include "Helpers.h"

int factorial(int x);

int main() {
    int x = 5;
    printf("%d\n", factorial(x)); //120
    return 0;
}

/**
 * This function takes in an input
 * and returns the factorial of that number
 * 
 * @param x      Input integer
 * 
 * @return res   Factorial result of input integer
*/
int factorial(int x) {
    int res = 1;
    if (x <= 1) {
        return 1;
    }

    for (int i = x; i > 1; i--) {
        res = res * i;
    }

    return res;
}