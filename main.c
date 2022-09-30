#include <stdio.h>

int main() {
    int array_size;
    scanf("%d", &array_size);

    int a[array_size];
    int new_size = 0;
    for (int i = 0; i < array_size; ++i) {
        scanf("%d", &a[i]);

        if (a[i] % 2 == 0) {
            ++new_size;
        }
    }

    int b[new_size];
    for (int i = 0, j = 0; i < array_size; ++i) {
        if (a[i] % 2 == 0) {
            b[j++] = a[i];
        }
    }

    for (int i = 0; i < new_size; ++i) {
        printf("%d ", b[i]);
    }
    return 0;
}
