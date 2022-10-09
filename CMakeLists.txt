cmake_minimum_required(VERSION 3.23)
project(Task1 C)

set(CMAKE_C_STANDARD 99)

add_executable(Basic basic.c)
add_executable(Functions functions.c)
add_executable(Modular modular-main.c modular-io.c modular-io.h modular-make.c modular-make.h modular-file.c modular-file.h modular-generator.c modular-generator.h)
