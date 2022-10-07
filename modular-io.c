#include "modular-io.h"
#include <stdio.h>
#include <stdlib.h>

int *read_array(int *size) {
    scanf("%d", size);

    int *array = malloc(*size * sizeof(int));
    for (int i = 0; i < *size; ++i) {
        scanf("%d", &array[i]);
    }

    return array;
}

void print_array(int *array, int size) {
    for (int i = 0; i < size; ++i) {
        printf("%d ", array[i]);
    }
    printf("\n");
}
