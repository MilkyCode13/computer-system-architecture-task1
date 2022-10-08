#include "modular-make.h"
#include <stdlib.h>

int *make_array(const int *src_array, size_t src_size, size_t *new_size) {
    int *new_array = malloc(src_size * sizeof(int));
    *new_size = 0;
    for (size_t i = 0; i < src_size; ++i) {
        if (src_array[i] % 2 == 0 && src_array[i] < 0) {
            new_array[(*new_size)++] = src_array[i];
        }
    }

    return new_array;
}
