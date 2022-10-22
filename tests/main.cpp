#include "functions.h"
#include "performance_test.h"
#include "unit_tests.h"
#include <iomanip>
#include <iostream>

#define SHOW_PERFORMANCE(func, array_size, run_count)                                                                      \
    {                                                                                                                      \
        auto result = measure_performance(func, array_size, run_count);                                                    \
        std::cout << std::left << std::setw(25) << #func                                                                                \
                  << "\tbest: " << result.best << "us mean: " << result.average << "us worst: " << result.worst << "us\n"; \
    }

const size_t array_size = 1000000;
const size_t run_count = 100;

int main() {
    SHOW_PERFORMANCE(make_array_reference, array_size, run_count);
    SHOW_PERFORMANCE(make_array_asm_basic, array_size, run_count);
    SHOW_PERFORMANCE(make_array_asm_optimized, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O0, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O1, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O2, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O3, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_Ofast, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_Os, array_size, run_count);

    TestRunner runner(array_size, 1000);
    runner.run_tests(make_array_asm_basic);
    runner.run_tests(make_array_asm_optimized);
}
