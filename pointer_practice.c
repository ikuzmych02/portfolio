#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int* returnArr() {
    int *p = (int*) (malloc(sizeof(int) * 5));

    for (int i = 0; i < 5; i++) {
        *(p + i) = i * 10;
    }

    return p;
}


void reference(int* test, size_t size) {
    for (int i = 0; i < size; i++) {
        *(test + i) = i * 12;
    }
    
    return;
}

int main() {
    int* result;
    int* res = (int*) malloc(sizeof(int) * 10);
    result = returnArr();
    for (int i = 0; i < 5; i++) {
        printf("[%d] ", result[i]);
    }
    
    printf("\n");

    reference(res, 10);
    int x = sizeof(res);
    for (int i = 0; i < 10; i++) {
        printf("[%d] ", res[i]);
    }


    free(result);
    free(res);
    result = NULL;
    
    return 0;
}