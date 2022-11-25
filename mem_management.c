#include "Helpers.h"

/**
 * Moves data from one buffer to another
 * 
 * @param dest Destination buffer
 * @param src  Source buffer
 * @param size Size of data we want to transfer
*/
void myMemCpy(void *dest, void *src, size_t size) {

    char *csrc = (char*) src;
    char *cdest = (char*) dest;

    for (int i = 0; i < size; i++) {
        cdest[i] = csrc[i];
    }
    return;
}

/**
 * Similar to memcpy, but instead uses a temp array
 * to take care of cases where src and dest addresses
 * are overlapping
 * 
 * @param dest Destination buffer
 * @param src  Source buffer
 * @param size Size of data we want to transfer
*/
void myMemMove(void *dest, void *src, size_t size) {

    char *csrc = (char*) src;
    char *cdest = (char*) dest;

    char *temp = (char*) malloc(sizeof(char) * size);

    for (int i = 0; i < size; i++) {
        temp[i] = csrc[i];
    }

    for (int j = 0; j < size; j++) {
        cdest[j] = temp[j];
    }

    free(temp);
    temp = NULL;

    return;
}


int main() {
    char* str = "Hello there";
    char* dest = (char*) malloc(sizeof(str) + 1);

    myMemCpy(dest, str, strlen(str) + 1);
    printf("%s\n", dest);
    
    char* newDest = (char*) malloc(sizeof(dest) + 1);
    myMemMove(newDest, dest, strlen(dest) + 1);
    printf("%s\n", newDest);
    

    free(dest);
    free(newDest);
    dest = NULL;
    newDest = NULL;

    return 0;
}