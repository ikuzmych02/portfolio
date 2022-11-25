#include "Helpers.h"


int countConsecutiveOnes(int input) {
    int count = 0;
    int max = 0;
    
    int i;
    for (i = 0; i < sizeof(int) * 8; i++) {
        if (((input >> i) & ONE_MASK) == 1) {
            count++;
        } else {
            if (count > max) {
                max = count;
            }
            count = 0;
        }

        if (count > max) {
            max = count;
        }
    }
    
    return max;
}


int main() {
    int MK_VAR(0), MK_VAR(1);

    result0 = countConsecutiveOnes(0xF0000001);
    result1 = countConsecutiveOnes(0xED00058A);

    printf("Count of consecutive ones in result0 is %d\n", result0); // should output 4
    printf("Count of consecutive ones in result1 is %d\n", result1); // should output 3. Expands to: 11101101000000000000010110001010

    return 0;
}