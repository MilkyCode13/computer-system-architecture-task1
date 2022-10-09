#include "functions.h"

int *make_array_reference(const int *src_array, size_t src_size, size_t *new_size) {
    *new_size = 0;
    int *new_array = new int[src_size];

    for (size_t i = 0; i < src_size; ++i) {
        if (src_array[i] % 2 == 0 && src_array[i] < 0) {
            new_array[(*new_size)++] = src_array[i];
        }
    }

    return new_array;
}
