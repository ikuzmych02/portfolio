#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TRUE 1
#define FALSE 0
#define BOOLEAN int

BOOLEAN binarySearch(int* array, int x, int left, int right) {
    if (left > right) {
        return FALSE; // by this point the left is over the right. Element does not exist in the array
    }

    int middle = (left + right) / 2;
    if (array[middle] == x) {
        return TRUE;
    } else if (x < array[middle]) {
        return binarySearch(array, x, left, middle - 1);
    } else {
        return binarySearch(array, x, middle + 1, right);
    }

    return FALSE;
}

int main() {
    int arr[] = {1, 2, 4, 7, 12, 35};
    BOOLEAN result;

    result = binarySearch(arr, 12, 0, 6);
    printf("Is the passed in element in the array? %d\n", result);

    result = binarySearch(arr, 35, 0, 6);
    printf("Is the passed in element in the array? %d\n", result);

    result = binarySearch(arr, 1500, 0, 6);
    printf("Is the passed in element in the array? %d\n", result);

    return 0;
}