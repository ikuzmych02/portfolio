#include "Helpers.h"

char* reverseWordsInString(char* str);

int main() {
    char* res = (char*) malloc(14);
    strcpy(res, "Lord is Great");
    printf("%s\n", reverseWordsInString(res));
    
    free(res);
    return 0;
}

/**
 * This function will take in a string and reverse each word in it.
 * Ex. "Lord is Great" -> "droL si taerG"
 * 
 * @param str       String we want to reverse each word of
 * 
 * @return newStr   Result
*/
char* reverseWordsInString(char* str) {
    char* newStr = (char*) malloc(strlen(str) + 1);
    strcpy(newStr, str);
    int i = 0;
    int count = 0;
    int j;
    char temp;
    int x;
    
    while (str[i] != '\0') {
        while ((str[i] != 32 && (str[i] != '\0')) && (i <= strlen(str))) { // 32 in ASCII = space character ' '
            count++;
            i++;
        }
        x = 1;
        for (j = i - count; j < count / 2 + (i - count); j++) {
            temp = str[j];
            newStr[j] = str[i - x];
            newStr[i - x] = temp;
            x++;
        }
        if (str[i] == '\0') {
            break;
        }
        i++;
        count = 0;
    }

    return newStr;
}