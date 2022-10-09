#include "generator.h"
#include <random>

std::vector<int> generate_array(std::size_t size) {
    std::random_device dev;
    std::mt19937 generator(dev());
    std::uniform_int_distribution<int> distribution(std::numeric_limits<int>::min());

    std::vector<int> array(size);
    for (size_t i = 0; i < size; ++i) {
        array[i] = distribution(generator);
    }

    return array;
}
