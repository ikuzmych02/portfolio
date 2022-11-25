#include "Helpers.h"

/**
 * Function that will reverse a string in-place
 * 
 * @param str String of any size
*/
void reverseString(char* str) {
    char *temp = (char*) malloc(sizeof(char) * strlen(str));
    int j = strlen(str) - 1;
    for (int i = 0; i < strlen(str); i++) {
        temp[i] = str[j];
        j--;
    }

    for (int i = 0; i < strlen(str); i++) {
        str[i] = temp[i];
    }

    free(temp);
    return;
}


int main() {
    char* result = (char*)(malloc(10));
    
    memcpy(result, "Forty-two", sizeof(char)*9 + 1);
    printf("%d\n", strlen(result));
    printf("%s\n", result);

    reverseString(result);

    printf("%s", result);

    free(result);
    result = NULL;

    return 0;
}