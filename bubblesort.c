#include "Helpers.h"

void bubbleSort(int arr[], int n) {
    int i, j;
    for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
            }
        }
    }
}

int main() {
    int arr[] = {12, 44, 1, 3, 78, 67};
    int sizeArr = sizeof(arr) / sizeof(arr[0]);
    bubbleSort(arr, sizeArr);
    printArray(arr, sizeArr);

    return 0;
}