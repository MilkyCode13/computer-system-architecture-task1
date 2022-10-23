#include "unit_tests.h"

FailedTest::FailedTest(const std::string &name, std::vector<int> input, std::vector<int> expected_output,
                       std::vector<int> real_output)
    : std::runtime_error(name + " Test Failed!!!"), input_{std::move(input)}, expected_output_{std::move(
                                                                                      expected_output)},
      real_output_(std::move(real_output)) {}

UnitTest::UnitTest(std::vector<int> input) : input_{std::move(input)} {
    size_t output_size;
    int *output_array = run_make_array(make_array_reference, input_.data(), input_.size(), &output_size);
    output_ = std::vector<int>(output_array, output_array + output_size);
    free(output_array);
}

UnitTest::UnitTest(const std::string &input_filename, const std::string &output_filename) {
    int number;

    std::ifstream input_file(input_filename);
    input_file >> number;
    while (input_file >> number) { input_.push_back(number); }
    input_file.close();

    std::ifstream output_file(output_filename);
    while (output_file >> number) { output_.push_back(number); }
    input_file.close();
}

TestRunner::TestRunner(size_t array_size, size_t test_count) {
    for (size_t i = 0; i < test_count; ++i) { tests_.emplace_back(generate_array(array_size)); }
}

void TestRunner::add_test(const std::string &input_filename, const std::string &output_filename) {
    tests_.emplace_back(input_filename, output_filename);
}
