#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define ONE_MASK 0x00000001
#define MK_VAR(n) result##n

void printArray(int arr[], int size) {
    int i;
    for (i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}


void swap(int* xp, int* yp) {
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

//
// Test struct. Total size: 13 bytes (when packed)
//
typedef struct {
    char name; // 1 byte
    int age;   // 4 bytes
    long long int favoriteNum; // 8 bytes
} Person;