#include "Helpers.h"

int addAndDetectOverflow(int* result, int x, int y);

int main() {
    int* res = (int*) malloc(sizeof(int));
    printf("%d\n", addAndDetectOverflow(res, 2147483640, 10));
    printf("%d\n", *res);

    return 0;
}

/**
 * This function will add two ints, place the result in result if no overflow is detected
 * 
 * @param result Pointer to the result
 * @param x      First operand
 * @param y      Second operand
 * 
 * @return 0     Successfully added, no overflow
 * @return -1    Overflow detected. Failure code
*/
int addAndDetectOverflow(int* result, int x, int y) {
    *result = x + y;
    if ((x > 0 && y > 0 && *result < 0) || (x < 0 && y < 0 && *result > 0)) {
        return -1;
    }
    
    return 0;
}