#include "modular-io.h"
#include "modular-make.h"
#include <stdlib.h>

int main() {
    int src_size;
    int *src_array = read_array(&src_size);

    int new_size;
    int *new_array = make_array(src_array, src_size, &new_size);
    free(src_array);

    print_array(new_array, new_size);
    free(new_array);

    return 0;
}
