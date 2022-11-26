#include "Helpers.h"

void swapVariables(int *x, int *y);

int main() {
    int *test1 = (int*) malloc(sizeof(int));
    int *test2 = (int*) malloc(sizeof(int));
    *test1 = 12;
    *test2 = 98;

    swapVariables(test1, test2);

    printf("After swapping with test2, test1 is now: %d\n", *test1);
    printf("After swapping with test1, test2 is now: %d\n", *test2);

    return 0;
}

/**
 * This function swaps two variables without using a temp.
 * For example: x = 10, y = 20
 * x = 10 + 20 -> 30
 * y = 30 - 20 -> 10. y now equal to 10
 * x = 30 - 10 -> 20. x now equal to 20
 * 
 * @param x   Integer pointer to first input variable
 * @param y   Integer pointer to second input variable
 * 
*/
void swapVariables(int *x, int *y) {

    *x = *x + *y;
    *y = *x - *y;
    *x = *x - *y;

    return;
}