#ifndef TASK1_UNIT_TESTS_H
#define TASK1_UNIT_TESTS_H

#include "functions.h"
#include "generator.h"
#include <cstddef>
#include <stdexcept>
#include <utility>
#include <vector>

class UnitTest {
    std::vector<int> input_;
    std::vector<int> output_;

public:
    explicit UnitTest(std::vector<int> input) : input_{std::move(input)} {
        size_t output_size;
        int *output_array = run_make_array(make_array_reference, input_.data(), input_.size(), &output_size);
        output_ = std::vector<int>(output_array, output_array + output_size);
        free(output_array);
    }

    template<typename ArrayMaker>
    void run_test(ArrayMaker func) {
        size_t output_size;
        int *output_array = run_make_array(func, input_.data(), input_.size(), &output_size);
        if (output_size != output_.size() || !std::equal(output_.begin(), output_.end(), output_array)) {
            free(output_array);
            throw std::runtime_error("Test Failed!!!");
        }

        free(output_array);
    }
};

class TestRunner {
    std::vector<UnitTest> tests_{};

public:
    TestRunner(size_t array_size, size_t test_count) {
        for (size_t i = 0; i < test_count; ++i) {
            tests_.emplace_back(generate_array(array_size));
        }
    }

    template<typename ArrayMaker>
    void run_tests(ArrayMaker func) {
        for (UnitTest &test: tests_) {
            test.run_test(func);
        }
    }
};

#endif//TASK1_UNIT_TESTS_H
