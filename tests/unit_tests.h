#ifndef TASK1_UNIT_TESTS_H
#define TASK1_UNIT_TESTS_H

#include "functions.h"
#include "generator.h"
#include <cstddef>
#include <fstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

class FailedTest : public std::runtime_error {
public:
    std::vector<int> input_;
    std::vector<int> expected_output_;
    std::vector<int> real_output_;

    FailedTest(const std::string &name, std::vector<int> input, std::vector<int> expected_output,
               std::vector<int> real_output);
};

class UnitTest {
    std::vector<int> input_{};
    std::vector<int> output_{};

public:
    explicit UnitTest(std::vector<int> input);

    UnitTest(const std::string &input_filename, const std::string &output_filename);

    template<typename ArrayMaker>
    void run_test(ArrayMaker func, const std::string &name) const {
        size_t output_size;
        int *output_array = run_make_array(func, input_.data(), input_.size(), &output_size);
        if (output_size != output_.size() || !std::equal(output_.begin(), output_.end(), output_array)) {
            std::vector<int> real_output(output_array, output_array + output_size);
            free(output_array);
            throw FailedTest(name, input_, output_, real_output);
        }

        free(output_array);
    }
};

class TestRunner {
    std::vector<UnitTest> tests_{};

public:
    TestRunner() = default;

    TestRunner(size_t array_size, size_t test_count);

    void add_test(const std::string &input_filename, const std::string &output_filename);

    template<typename ArrayMaker>
    void run_tests(ArrayMaker func, const std::string &name) const {
        for (const UnitTest &test: tests_) { test.run_test(func, name); }
    }
};

#endif//TASK1_UNIT_TESTS_H
