#ifndef TASK1_PERFORMANCE_TEST_H
#define TASK1_PERFORMANCE_TEST_H

#include "functions.h"
#include "generator.h"
#include <chrono>
#include <cstddef>
#include <iostream>
#include <vector>

template<typename ArrayMaker>
int64_t measure_run(ArrayMaker func, const std::vector<int> &array) {
    size_t new_size;
    auto start = std::chrono::steady_clock::now();
    int *new_array = run_make_array(func, array.data(), array.size(), &new_size);
    auto end = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);

    free(new_array);
    return duration.count();
}

struct MeasurementResults {
    uint64_t average;
    uint64_t best;
    uint64_t worst;
};

template<typename ArrayMaker>
MeasurementResults measure_performance(ArrayMaker func, size_t array_size, size_t run_count = 10) {
    uint64_t sum = 0;
    uint64_t best;
    uint64_t worst;

    for (size_t i = 0; i < run_count; ++i) {
        std::vector<int> array = generate_array(array_size);
        uint64_t result = measure_run(func, array);

        sum += result;
        if (i == 0 || result < best) {
            best = result;
        }

        if (i == 0 || result > worst) {
            worst = result;
        }
    }

    return MeasurementResults{sum / run_count, best, worst};
}

#endif//TASK1_PERFORMANCE_TEST_H
