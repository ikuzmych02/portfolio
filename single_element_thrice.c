#include "Helpers.h"

/**
 * Returns the element in an integer array
 * that does NOT appear thrice (3x times)
 * 
 * @param arr Array of integers
*/
int returnElement(int arr[], size_t size) {

    int targetElement = arr[0];
    int count = 0;
    for (int i = 0; i < size; i++) {
        if (targetElement == arr[i]) {
            count++;
        } else {
            if (count != 3) {
                return targetElement;
            }
            targetElement = arr[i];
            count = 0;
        }
    }
    return -1; // every element appears thrice
}


int main() {
    
    int arr[] = {1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4}; // 2 appears two times
    int arr2[] = {1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 6, 6, 6}; // 1 appears four times
    int arr3[] = {11, 11, 11, 12, 12, 12}; // every element appears thrice

    printf("The number that does not appear thrice in the array is %d\n", returnElement(arr, 11)); // should return 2
    
    printf("The number that does not appear thrice in the array2 is %d\n", returnElement(arr2, 16)); // should return 1
    
    printf("The number that does not appear thrice in the array3 is %d\n", returnElement(arr3, 6)); // should return -1

    return 0;
}