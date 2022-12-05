#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TRUE 1
#define FALSE 0
typedef int BOOLEAN;

/**
 * Functional implementation
 * to check if a string of any size is a palindrome
 * 
 * @param str String
 * 
 * @return TRUE    1    The string is a palindrome
 * @return FALSE   0    The string is not a palindrome
*/
BOOLEAN isStringPalindrome(char* str) {
    for (int i = 0; i < strlen(str) / 2; i++) {
        if (str[i] != str[strlen(str) - 1 - i]) {
            return FALSE;
        }
    }

    return TRUE;
}

/**
 * Main loop that takes inputs from
 * user over command line and uses those as parameters for the isStringPalindrome function.
 * 
 * @param argc Argument count
 * @param argv Array of char pointers (array of strings)
 *
 * @return 0 Function exited successfully
 */
int main(int argc, char** argv) {

    for (int i = 1; i < argc; i++) {
        isStringPalindrome(argv[i]) ? printf("%s is a palindrome!\n", argv[i]) : printf("%s is NOT a palindrome!\n", argv[i]);
    }

    return 0;
}