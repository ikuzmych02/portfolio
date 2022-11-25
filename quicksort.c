#include "Helpers.h"

int partition(int arr[], int low, int high) {
    
    // select the rightmost element as pivot
    int pivot = arr[high];

    // pointer for the greater element
    int i = low - 1;

    // traverse each element of the array
    // compare them with the pivot
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {

            // if the element smaller than pivot is found
            // swap it with the greater element pointed by i
            i++;

            // swap element at i with element at j
            swap(&arr[i], &arr[j]);
        }
    }

    // swap the pivot element with the greater element at i
    swap(&arr[i + 1], &arr[high]);

    // return the partition point;
    return (i + 1);
}

void quickSort(int arr[], int low, int high) {
    if (low < high) {

        // find the pivot element such that
        // elements smaller than pivot are on left of pivot
        // elements greater than pivot are on right of pivot
        int pi = partition(arr, low, high);

        // recursive call on the left of pivot
        quickSort(arr, low, pi - 1);

        // recursive call on the right of pivot
        quickSort(arr, pi + 1, high);
    }
}


int main() {
    int test[] = {12, 44, 11, 10, 1, 2, 3, 88, 55};
    int size = sizeof(test) / sizeof(test[0]);
    quickSort(test, 0, size - 1);
    printArray(test, size);

    return 0;
}


