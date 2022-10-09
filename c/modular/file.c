#include "file.h"
#include <stdio.h>
#include <stdlib.h>

int *read_array_file(char *filename, size_t *size) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        *size = 0;
        return NULL;
    }

    fscanf(file, "%lu", size);

    int *array = malloc(*size * sizeof(int));
    for (size_t i = 0; i < *size; ++i) {
        fscanf(file, "%d", &array[i]);
    }

    fclose(file);
    return array;
}

void write_array_file(const char *filename, int *array, size_t size) {
    FILE *file = fopen(filename, "w");

    for (size_t i = 0; i < size; ++i) {
        fprintf(file, "%d ", array[i]);
    }
    fprintf(file, "\n");

    fclose(file);
}
