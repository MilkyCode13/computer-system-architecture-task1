#include "modular-file.h"
#include "modular-generator.h"
#include "modular-io.h"
#include "modular-make.h"
#include <stdlib.h>

int console() {
    size_t src_size;
    int *src_array = read_array(&src_size);

    size_t new_size;
    int *new_array = make_array(src_array, src_size, &new_size);
    free(src_array);

    print_array(new_array, new_size);
    free(new_array);

    return 0;
}

int file(char *input_file, char *output_file) {
    size_t src_size;
    int *src_array = read_array_file(input_file, &src_size);

    size_t new_size;
    int *new_array = make_array(src_array, src_size, &new_size);
    free(src_array);

    write_array_file(output_file, new_array, new_size);
    free(new_array);

    return 0;
}

int generator(size_t src_size) {
    int *src_array = generate_array(src_size);

    size_t new_size;
    int *new_array = make_array(src_array, src_size, &new_size);
    free(src_array);

    print_array(new_array, new_size);
    free(new_array);

    return 0;
}

int main(int argc, char *argv[]) {
    switch (argc) {
        case 3:
            return file(argv[1], argv[2]);
        case 2:
            return generator(atol(argv[1]));
        default:
            return console();
    }
}
