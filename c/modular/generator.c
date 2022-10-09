#include "generator.h"
#include <stdlib.h>
#include <time.h>

#define MODULO 1000000007

int *generate_array(size_t size) {
    srandom(time(NULL));

    int *array = malloc(size * sizeof(int));
    for (size_t i = 0; i < size; ++i) {
        array[i] = (int) random() % MODULO - MODULO / 2;
    }

    return array;
}
