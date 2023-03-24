#include <stdio.h>
#include <stdlib.h>

char* intToStr(int x);
int countDigits(int x);

int main() {
    int test1 = 134;
    char* testResult = (char*) malloc(20);
    testResult = intToStr(test1);
    printf("%s\n", testResult);
    return 0;
}

/**
 * This function takes an integer input and converts it to a string
 * 
 * @param x      Integer to cast into a string
 * 
 * @return res   String result of the integer
*/
char* intToStr(int x) {
    char* res = (char*) malloc(20);
    int i = 0;
    int totalDigits = countDigits(x);
    for (i = 0; i < totalDigits; i++) {
        res[totalDigits - 1 - i] = (x % 10) + '0';
        x /= 10;
    }
    return res;
}

/**
 * This function takes an integer input and counts its digits.
 * For ex. x = 1234 -> count = 4
 * 
 * @param x        Integer to count digits of
 * 
 * @return count   Count of digits in given integer input
*/
int countDigits(int x) {
    int count = 0;
    while (x) {
        x /= 10;
        count++;
    }
    return count;
}