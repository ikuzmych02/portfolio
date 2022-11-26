#include "Helpers.h"

void reverseString(char* str);

int main() {
    char* result = (char*)(malloc(10));
    
    memcpy(result, "Forty-two", sizeof(char)*9 + 1);
    printf("%s\n", result);

    reverseString(result);

    printf("%s", result);

    free(result);
    result = NULL;

    return 0;
}

/**
 * Function that will reverse a string in-place
 * 
 * @param str String of any size
*/
void reverseString(char* str) {
    
    char temp;
    for (int i = 0; i < strlen(str) / 2; i++) {
        temp = str[i];
        str[i] = str[strlen(str) - 1 - i];
        str[strlen(str) - 1 - i] = temp;
    }

    return;
}