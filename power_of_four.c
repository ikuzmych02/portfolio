#include "Helpers.h"

int powerOfFour(int x);

int main() {
    int t1, t2, t3;
    t1 = powerOfFour(16);
    t2 = powerOfFour(64);
    t3 = powerOfFour(12);

    printf("%d\n", t1);
    printf("%d\n", t2);
    printf("%d\n", t3);

    return 0;
}

/**
 * This function takes an integer and checks if it is a power of four
 * 
 * @param x Integer that will be checked
 * 
 * @return 1 Integer is a power of four
 * @return 0 Integer is NOT a power of four
*/
int powerOfFour(int x) {

    if (x == 0) {
        return 0;
    }

    while (x != 1) {
        if (x % 4 != 0) {
            return 0;
        }
        x /= 4;
    }

    return 1;
}