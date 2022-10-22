#all: basic functions modular
#
#asm: asm.s
#	gcc asm.s -o asm
#
#basic: c/basic/basic.s
#	gcc basic.s -o basic
#
#basic.s: c/basic/main.c
#	gcc -S basic.c -o basic.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#functions: c/functions/functions.s
#	gcc functions.s -o functions
#
#functions.s: c/functions/main.c
#	gcc -S functions.c -o functions.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#modular: c/modular/modular-main.s c/modular/modular-io.s c/modular/modular-make.s c/modular/modular-file.s c/modular/modular-generator.s
#	gcc modular-main.s modular-io.s modular-make.s modular-file.s modular-generator.s -o modular
#
#modular-main.s: c/modular/main.c
#	gcc -S modular-main.c -o modular-main.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#modular-io.s: c/modular/io.c
#	gcc -S modular-io.c -o modular-io.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#modular-make.s: c/modular/make.c
#	gcc -S modular-make.c -o modular-make.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#modular-file.s: c/modular/file.c
#	gcc -S modular-file.c -o modular-file.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
#
#modular-generator.s: c/modular/generator.c
#	gcc -S modular-generator.c -o modular-generator.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

executables/run_tests: tests/main.cpp tests/functions.h tests/functions.cpp tests/generator.h tests/generator.cpp tests/performance_test.h tests/performance_test.cpp tests/functions_object/asm_basic.o tests/functions_object/asm_optimized.o tests/functions_object/c_O0.o tests/functions_object/c_O1.o tests/functions_object/c_O2.o tests/functions_object/c_O3.o tests/functions_object/c_Ofast.o tests/functions_object/c_Os.o
	g++ -o executables/run_tests tests/main.cpp tests/functions.cpp tests/generator.cpp tests/performance_test.cpp tests/functions_object/asm_basic.o tests/functions_object/asm_optimized.o tests/functions_object/c_O0.o tests/functions_object/c_O1.o tests/functions_object/c_O2.o tests/functions_object/c_O3.o tests/functions_object/c_Ofast.o tests/functions_object/c_Os.o -O3

tests/functions_object/asm_basic.o:	asm/functions/make.s
	as asm/functions/make.s -o tests/functions_object/asm_basic.o
	objcopy --redefine-sym make_array=make_array_asm_basic tests/functions_object/asm_basic.o

tests/functions_object/asm_optimized.o:	asm/modular/make.s
	as asm/modular/make.s -o tests/functions_object/asm_optimized.o
	objcopy --redefine-sym make_array=make_array_asm_optimized tests/functions_object/asm_optimized.o

tests/functions_object/c_O0.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_O0.o -O0
	objcopy --redefine-sym make_array=make_array_c_O0 tests/functions_object/c_O0.o

tests/functions_object/c_O1.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_O1.o -O1
	objcopy --redefine-sym make_array=make_array_c_O1 tests/functions_object/c_O1.o

tests/functions_object/c_O2.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_O2.o -O2
	objcopy --redefine-sym make_array=make_array_c_O2 tests/functions_object/c_O2.o

tests/functions_object/c_O3.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_O3.o -O3
	objcopy --redefine-sym make_array=make_array_c_O3 tests/functions_object/c_O3.o

tests/functions_object/c_Ofast.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_Ofast.o -Ofast
	objcopy --redefine-sym make_array=make_array_c_Ofast tests/functions_object/c_Ofast.o

tests/functions_object/c_Os.o:	c/modular/make.c
	gcc -c c/modular/make.c -o tests/functions_object/c_Os.o -Os
	objcopy --redefine-sym make_array=make_array_c_Os tests/functions_object/c_Os.o
