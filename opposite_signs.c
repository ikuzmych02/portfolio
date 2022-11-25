#include <stdio.h>
#include <stdlib.h>
#define BOOL int
#define TRUE 1
#define FALSE 0

BOOL oppositeSigns(int x, int y);

int main() {
    int test1, test2, test3;
    test1 = oppositeSigns(-3, 4);
    test2 = oppositeSigns(-3, -12);
    test3 = oppositeSigns(3, 4);
    printf("%d\n", test1);
    printf("%d\n", test2);
    printf("%d\n", test3);

    return 0;
}

/**
 * This function will compare the signs of two integers
 * 
 * @param x Integer 1
 * @param y Integer 2
 * 
 * @return 1    The integers have opposite signs
 * @return 0    THe integers have the same signs
*/
BOOL oppositeSigns(int x, int y) {
    return ((x ^ y) < 0);
}