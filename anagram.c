#include "Helpers.h"

#define NO_OF_CHARS 256  // total number of different characters in C
#define BOOL int

BOOL areAnagrams(char *str1, char *str2);

int main(int argc, char** argv) {

    areAnagrams(argv[1], argv[2]) ? printf("Your inputs are anagrams!") : printf("Your inputs are not anagrams!");

    return 0;
}

/**
 * This function takes in two strings and checks if
 * they are anagrams of one another
 * 
 * @param str1     First input string
 * @param str2     Second input string
 * 
 * @return 0       The strings are NOT anagrams
 * @return 1       The strings are anagrams
*/
BOOL areAnagrams(char *str1, char *str2) {
    if (strlen(str1) != strlen(str2)) {
        return 0;
    }

    int count1[NO_OF_CHARS] = { 0 };
    int count2[NO_OF_CHARS] = { 0 };

    //
    // Iterate through the length of the strings
    // and increase the count for any specific ASCII key
    //
    int i;
    for (i = 0; i < strlen(str1); i++) {
        count1[str1[i]]++;
        count2[str2[i]]++;
    }

    // compare the count arrays
    for (i = 0; i < NO_OF_CHARS; i++) {
        if (count1[i] != count2[i]) {
            return 0;
        }
    }

    return 1;
}