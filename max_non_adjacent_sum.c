#include "Helpers.h"
#define max(x, y) (x > y) ? x : y

int maxNonAdjacentSum(int arr[], size_t size);

int main() {
    int arr[5] = {4, 1, 6, 3, -1};
    printf("%d\n", maxNonAdjacentSum(arr, 5));

    return 0;
}

int maxNonAdjacentSum(int arr[], size_t size) {
    if (size == 0) {
        return 0;
    }

    int curr = 0;
    int curr1 = arr[0]; // inclusve
    int curr2 = 0;      // exclusive
    for (int i = 1; i < size; i++) {
        curr = max(curr1, curr2); // current inclusive = max of old inclusive and current number + exclusive
        curr1 = curr2 + arr[i];
        curr2 = curr;
    }

    return max(curr1, curr2);
}