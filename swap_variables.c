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

void swapVariables(int *x, int *y) {

    *x = *x + *y;
    *y = *x - *y;
    *x = *x - *y;

    return;
}