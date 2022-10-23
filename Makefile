all: all_versions tests


all_versions: executables/asm_basic executables/asm_functions executables/asm_registers executables/asm_modular executables/c_basic executables/c_functions executables/c_modular


executables/asm_basic: asm/basic/main.s
	gcc -o executables/asm_basic asm/basic/main.s

executables/asm_functions: asm/functions/main.s
	gcc -o executables/asm_functions asm/functions/main.s

executables/asm_registers: asm/registers/main.s
	gcc -o executables/asm_registers asm/registers/main.s

executables/asm_modular: asm/modular/main.s asm/modular/io.s asm/modular/make.s asm/modular/file.s asm/modular/generator.s
	gcc -o executables/asm_modular asm/modular/main.s asm/modular/io.s asm/modular/make.s asm/modular/file.s asm/modular/generator.s


executables/c_basic: c/basic/main.c
	gcc -o executables/c_basic c/basic/main.c

executables/c_functions: c/functions/main.c
	gcc -o executables/c_functions c/functions/main.c

executables/c_modular: c/modular/main.c c/modular/io.h c/modular/io.c c/modular/make.h c/modular/make.c c/modular/file.h c/modular/file.c c/modular/generator.h c/modular/generator.c
	gcc -o executables/c_modular c/modular/main.c c/modular/io.c c/modular/make.c c/modular/file.c c/modular/generator.c


tests: executables/run_tests

executables/run_tests: tests/main.cpp tests/functions.h tests/functions.cpp tests/generator.h tests/generator.cpp tests/unit_tests.h tests/unit_tests.cpp tests/performance_test.h tests/performance_test.cpp tests/functions_object/asm_basic.o tests/functions_object/asm_optimized.o tests/functions_object/c_O0.o tests/functions_object/c_O1.o tests/functions_object/c_O2.o tests/functions_object/c_O3.o tests/functions_object/c_Ofast.o tests/functions_object/c_Os.o
	g++ -o executables/run_tests tests/main.cpp tests/functions.cpp tests/generator.cpp tests/unit_tests.cpp tests/performance_test.cpp tests/functions_object/asm_basic.o tests/functions_object/asm_optimized.o tests/functions_object/c_O0.o tests/functions_object/c_O1.o tests/functions_object/c_O2.o tests/functions_object/c_O3.o tests/functions_object/c_Ofast.o tests/functions_object/c_Os.o -O3

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


clean:
	rm -f executables/asm_* executables/c_* executables/run_tests tests/functions_object/*.o
