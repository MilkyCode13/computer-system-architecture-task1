#include "modular-io.h"
#include <stdio.h>
#include <stdlib.h>

int *read_array(size_t *size) {
    scanf("%lu", size);

    int *array = malloc(*size * sizeof(int));
    for (size_t i = 0; i < *size; ++i) {
        scanf("%d", &array[i]);
    }

    return array;
}

void print_array(int *array, size_t size) {
    for (size_t i = 0; i < size; ++i) {
        printf("%d ", array[i]);
    }
    printf("\n");
}
