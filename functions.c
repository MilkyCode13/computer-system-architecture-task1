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

int *make_array(const int *src_array, int src_size, int *new_size) {
    int *new_array = malloc(src_size * sizeof(int));
    *new_size = 0;
    for (int i = 0; i < src_size; ++i) {
        if (src_array[i] % 2 == 0 && src_array[i] < 0) {
            new_array[(*new_size)++] = src_array[i];
        }
    }

    return new_array;
}

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
