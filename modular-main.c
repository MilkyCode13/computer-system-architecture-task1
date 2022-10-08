#include "modular-file.h"
#include "modular-io.h"
#include "modular-make.h"
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int file_input = 0;
    if (argc == 3) {
        file_input = 1;
    }

    size_t src_size;
    int *src_array = file_input ? read_array_file(argv[1], &src_size) : read_array(&src_size);


    size_t new_size;
    int *new_array = make_array(src_array, src_size, &new_size);
    free(src_array);

    if (file_input) {
        write_array_file(argv[2], new_array, new_size);
    } else {
        print_array(new_array, new_size);
    }
    free(new_array);

    return 0;
}
