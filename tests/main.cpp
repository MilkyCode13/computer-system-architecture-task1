#include "functions.h"
#include "performance_test.h"
#include "unit_tests.h"
#include <iomanip>
#include <iostream>

#define SHOW_PERFORMANCE(func, array_size, run_count)                                                                  \
    {                                                                                                                  \
        auto result = measure_performance(func, array_size, run_count);                                                \
        std::cout << std::left << std::setw(25) << #func << "\tbest: " << result.best << "us mean: " << result.average \
                  << "us worst: " << result.worst << "us\n";                                                           \
    }

const size_t array_size = 1000000;
const size_t run_count = 100;
const size_t manual_test_count = 12;

void print_array(const std::vector<int> &array) {
    for (int number: array) { std::cout << number << " "; }

    std::cout << "\n";
}

void run_performance_tests() {
    SHOW_PERFORMANCE(make_array_reference, array_size, run_count);
    SHOW_PERFORMANCE(make_array_asm_basic, array_size, run_count);
    SHOW_PERFORMANCE(make_array_asm_optimized, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O0, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O1, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O2, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_O3, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_Ofast, array_size, run_count);
    SHOW_PERFORMANCE(make_array_c_Os, array_size, run_count);
}

void run_test_runner(const TestRunner &runner, const std::string& type) {
    runner.run_tests(make_array_reference, "reference");
    std::cout << type << " reference Ok!\n";
    runner.run_tests(make_array_asm_basic, "asm_basic");
    std::cout << type << " asm_basic Ok!\n";
    runner.run_tests(make_array_asm_optimized, "asm_optimized");
    std::cout << type << " asm_optimized Ok!\n";
    runner.run_tests(make_array_c_O2, "c");
    std::cout << type << " c Ok!\n";
    std::cout << "\n";
}

void run_random_tests() {
    TestRunner runner(array_size, 1000);
    run_test_runner(runner, "random");
}

void run_manual_tests() {
    TestRunner runner;
    for (size_t i = 1; i <= manual_test_count; ++i) {
        std::string prefix =
                i < 10 ? "tests/manual_tests/test0" + std::to_string(i) : "tests/manual_tests/test" + std::to_string(i);
        runner.add_test(prefix + "in.txt", prefix + "out.txt");
    }

    run_test_runner(runner, "manual");
}

int main() {
    try {
        // Manual Tests
        run_manual_tests();

        // Random Tests
        run_random_tests();
    } catch (FailedTest &failedTest) {
        std::cout << failedTest.what() << "\n";
        std::cout << "input:           ";
        print_array(failedTest.input_);
        std::cout << "expected output: ";
        print_array(failedTest.expected_output_);
        std::cout << "real input:      ";
        print_array(failedTest.real_output_);
    }


    // Performance Tests
    run_performance_tests();
}
