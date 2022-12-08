#include <stdio.h>
#include <stdlib.h>

//
// Simple program to showcase how structs and unions
// allocate memory in a program
//

typedef struct {
    int x;            // 4 bytes
    long long int z;  // 8 bytes (x now aligns to 8 bytes)
    char y;           // 1 byte  (y now aligns to 8 bytess)
} Test;

typedef union UnionTest {
    int x;
    char y;
    long long int z;
} UnionTest;

int main() {
    printf("Size of Test struct: %d\n", sizeof(Test)); // 24, due to byte alignment
    printf("Size of Test union: %d\n", sizeof(UnionTest)); // 8, due to maximum type size (long long = 8 bytes)

    return 0;
}