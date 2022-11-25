#include <stdlib.h>
#include <stdio.h>

/*
 * @param number. Unsigned integer
 * @return 1      Number has two consecutive ones
 * @return 0      Number does not have two consecutive ones
 */
int inspect_bits(unsigned int number)
{
    int mask = 0x0001;
    int countOfOnes = 0;
    unsigned int num = number;  
    int loopSize = sizeof(number) * 8;
    
    for (int i = 0; i < loopSize; i++) {
      if ((mask & num) == 1) {
        countOfOnes++;
        num >>= 1;
        if (countOfOnes == 2) {
          return 1;
        }
      } else {
        countOfOnes = 0;
        num >>= 1;
      }
    }
  
    // Waiting to be implemented
    return 0;
}


int main ()
{
    printf("%d", inspect_bits(0x0003));
    return 0;
}