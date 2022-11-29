#include "Helpers.h"

void boolArrPuzzle(int arr[]);

int main() {
    int arr[2] = {0, 1};
    int arr2[2] = {1, 0};

    boolArrPuzzle(arr);

    printf("%d\n", arr[0]);
    printf("%d\n", arr[1]);

    return 0;
}

/**
 * This function takes in an array of two elements that contains 0 and 1
 * Goal is to make both elements in the array 0
 * 
 * 1. It is guaranteed that one element is 0 but we do not know its position
 * 2. We can't say about another element it can be 0 or 1.
 * 3. We can only complement array elements, no other operation like and, or, multi, diviosion, ....etc.
 * 4. We can't use if, else, and loop constructs
 * 5. Obviously, you cannot simply assign 0 to the array elements
 * 
 * @param arr  2-element array containing 0 and 1
 * 
*/
void boolArrPuzzle(int arr[]) {
    arr[ arr[1] ] = arr[ arr[0] ];
    return;
}