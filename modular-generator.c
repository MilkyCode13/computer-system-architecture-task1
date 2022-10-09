#include "modular-generator.h"
#include <stdlib.h>
#include <time.h>

int *generate_array(size_t size) {
    srandom(time(NULL));

    int* array = malloc(size * sizeof(int));
    for (size_t i = 0; i < size; ++i) {
        array[i] = random();
    }

    return array;
}
