#include "Helpers.h"

int countConsecutiveOnes(int input);

int main() {
    int MK_VAR(0), MK_VAR(1);

    result0 = countConsecutiveOnes(0xF0000001);
    result1 = countConsecutiveOnes(0xED00058A);

    printf("Count of consecutive ones in result0 is %d\n", result0); // should output 4
    printf("Count of consecutive ones in result1 is %d\n", result1); // should output 3. Expands to: 11101101000000000000010110001010

    return 0;
}

/**
 * This function takes an integer input and counts maximum amount of consecutive
 * bits in the binary representation of the number
 * 
 * @param input          Integer input
 * 
 * @return maximum       Count of max consecutive ones
*/
int countConsecutiveOnes(int input) {
    int count = 0;
    int maximum = 0;
    
    int i;
    for (i = 0; i < sizeof(int) * 8; i++) {
        if (((input >> i) & ONE_MASK) == 1) {
            count++;
        } else {
            maximum = max(count, maximum);
            count = 0;
        }

        maximum = max(count, maximum);
    }
    
    return maximum;
}