#ifndef TASK1_FUNCTIONS_H
#define TASK1_FUNCTIONS_H

#include <cstddef>
#include <memory>
#include <tuple>
#include <utility>

int *make_array_reference(const int *src_array, size_t src_size, size_t *new_size);

extern "C" {
int *make_array_asm_basic(const int *src_array, size_t src_size, size_t *new_size);
std::pair<int *, size_t> make_array_asm_optimized(const int *src_array, size_t src_size);

int *make_array_c_O0(const int *src_array, size_t src_size, size_t *new_size);
int *make_array_c_O1(const int *src_array, size_t src_size, size_t *new_size);
int *make_array_c_O2(const int *src_array, size_t src_size, size_t *new_size);
int *make_array_c_O3(const int *src_array, size_t src_size, size_t *new_size);
int *make_array_c_Ofast(const int *src_array, size_t src_size, size_t *new_size);
}

typedef int *ArrayMakerBasic(const int *src_array, size_t src_size, size_t *new_size);
typedef std::pair<int *, size_t> ArrayMakerPair(const int *src_array, size_t src_size);

inline int *run_make_array(ArrayMakerBasic func, const int *src_array, size_t src_size, size_t *new_size) {
    return func(src_array, src_size, new_size);
}

inline int *run_make_array(ArrayMakerPair func, const int *src_array, size_t src_size, size_t *new_size) {
    int *new_array;
    std::tie(new_array, *new_size) = func(src_array, src_size);
    return new_array;
}

#endif//TASK1_FUNCTIONS_H
