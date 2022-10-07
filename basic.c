#include <stdio.h>
#include <stdlib.h>

int main() {
    int src_size;
    scanf("%d", &src_size);

    int *src_array = malloc(src_size * sizeof(int));
    for (int i = 0; i < src_size; ++i) {
        scanf("%d", &src_array[i]);
    }

    int *new_array = malloc(src_size * sizeof(int));
    int new_size = 0;
    for (int i = 0; i < src_size; ++i) {
        if (src_array[i] % 2 == 0 && src_array[i] < 0) {
            new_array[new_size++] = src_array[i];
        }
    }
    free(src_array);

    for (int i = 0; i < new_size; ++i) {
        printf("%d ", new_array[i]);
    }
    printf("\n");
    free(new_array);

    return 0;
}
