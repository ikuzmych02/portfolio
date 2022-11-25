#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TRUE 1
#define FALSE 0
#define BOOLEAN int
#define MK_STRING(n) (*string##n)

char MK_STRING(0);
char MK_STRING(1);
char MK_STRING(2);
char MK_STRING(3);
char MK_STRING(4);
char MK_STRING(5);

/**
 * Functional implementation
 * to check if a string of any size is a palindrome
 * 
 * @param str String
*/
int isStringPalindrome(char* str) {
    int i = 0, j = strlen(str) - 1;
    int half = strlen(str) / 2;

    while (i < half && j > half) {
        if (*(str + j) != *(str + i)) { // compare two characters. Characters use ASCII values to see if they're equal
            return FALSE;
        }
        j--; i++;
    }

    return TRUE;
}

int main() {
    string0 = "aba";
    string1 = "racecar";
    string2 = "black";
    string3 = "saippuakivikauppias";
    string4 = "repaper";
    string5 = "Illya";

    BOOLEAN flag; 
    
    /**
     * 6 different test cases to check if
     * our string is in fact a palindrome
    */
    flag = isStringPalindrome(string0);
    printf("%s ", string0);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    flag = isStringPalindrome(string1);
    printf("%s ", string1);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    flag = isStringPalindrome(string2);
    printf("%s ", string2);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    flag = isStringPalindrome(string3);
    printf("%s ", string3);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    flag = isStringPalindrome(string4);
    printf("%s ", string4);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    flag = isStringPalindrome(string5);
    printf("%s ", string5);
    (flag == 1) ? printf("is a palindrome\n"): printf("is not a palindrome\n");

    return 0;
}