cmake_minimum_required(VERSION 3.23)
project(Task1 C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 20)

add_executable(Basic c/basic/main.c)
add_executable(Functions c/functions/main.c)
add_executable(Modular c/modular/main.c c/modular/io.c c/modular/io.h c/modular/make.c c/modular/make.h c/modular/file.c c/modular/file.h c/modular/generator.c c/modular/generator.h)
add_executable(Tests tests/main.cpp tests/functions.cpp tests/generator.cpp tests/performance_test.cpp tests/functions_object/asm_basic.o tests/functions_object/asm_optimized.o tests/functions_object/c_O0.o tests/functions_object/c_O1.o tests/functions_object/c_O2.o tests/functions_object/c_O3.o tests/functions_object/c_Ofast.o tests/functions_object/c_Os.o)
