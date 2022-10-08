#ifndef TASK1_MODULAR_FILE_H
#define TASK1_MODULAR_FILE_H

#include <stddef.h>

int *read_array_file(char *filename, size_t *size);
void write_array_file(const char *filename, int *array, size_t size);

#endif//TASK1_MODULAR_FILE_H
