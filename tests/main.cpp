#include "functions.h"
#include "performance_test.h"
#include <iostream>

#define SHOW_PERFORMANCE(func, array_size, run_count)                                                                \
    {                                                                                                                \
        auto result = measure_performance(func, array_size, run_count);                                              \
        std::cout << #func                                                                                           \
                  << "\tworst: " << result.worst << " mean: " << result.average << " best: " << result.best << "\n"; \
    }

int main() {
    SHOW_PERFORMANCE(make_array_asm_optimized, 1000000, 100);
}
