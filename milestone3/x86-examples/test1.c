#include <stdio.h>

void bubbleSort(int array[], int n) {
    int i, j;
    for (i = 0; i < n; i++) {
        int swapped = 0;
        for (j = 0; j < n - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                int temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
                swapped = 1;
            }
        }
        if (!swapped)
            break;
    }
}

void insertionSort(int arr[], int n) {
    int i, j;
    for (i = 1; i < n; i++) {
        int key = arr[i];
        j = i - 1;
        while (j >= 0 && key < arr[j]) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

int main() {
    int data1[] = {-2, 45, 0, 11, -9};
    int data2[] = {-2, 45, 0, 11, -9};

    int n = sizeof(data1) / sizeof(data1[0]);

    bubbleSort(data1, n);
    insertionSort(data2, n);

    for (int i = 0; i < n; i++) {
        printf("%d\n", data1[i]);
    }

    printf("\n");
    for (int i = 0; i < n; i++) {
        printf("%d\n", data2[i]);
    }

    return 0;
}
