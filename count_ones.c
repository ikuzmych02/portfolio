#include <stdio.h>
#include <stdlib.h>
#include "Helpers.h"

#define MK_INT(n) result##n


int countOnes(int input) {

    int count = 0;
    for (int i = 0; i < sizeof(int) * 8; i++) {
        if ((input >> i) & ONE_MASK)
            count++;
    }

    return count;
}

int main() {
    int MK_INT(0), MK_INT(1);

    result0 = countOnes(0xFF0000FF);
    result1 = countOnes(0x11000067); // expands to 00010001000000000000000001100111

    printf("%d\n", result0);
    printf("%d\n", result1);


    return 0;
}