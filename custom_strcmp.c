#include "Helpers.h"

int customStrcmp(const char* str1, const char* str2);

int main() {
    char* x = "Hello";

    printf("%d\n", customStrcmp("hello1", "Hello1")); // 0
    printf("%d\n", customStrcmp("GeeksForGeeks", "geeksforgeeks")); // 0
    printf("%d\n", customStrcmp("rAnDoM", "RaNdOm")); // 0
    printf("%d\n", customStrcmp("rAnDoM", "RaNdOm1")); // -1

    printf("%d\n", 'x');
    printf("%d\n", 'X');

    return 0;
}

/**
 * Function to compare two strings
 * 
 * @param str1 String 1
 * @param str2 String 2
 * 
 * @return 0   The strings are equal
 * @return >0  The first non-matching cahracter in str1 is greater in ASCII than that of str2
 * @return <0  The first non-matching character in str1 is lower in ASCII than that of str2
*/
int customStrcmp(const char* str1, const char* str2) {
    int i = 0;
    int x;
    while (str1[i] != '\0' || str2[i] != '\0') {
        x = str1[i] - str2[i];
        if (str1[i] != str2[i] && x != 32 && x != -32) {
            return str1[i] > str2[i] ? 1 : -1;
        }
        i++;
    }
    return 0;
}