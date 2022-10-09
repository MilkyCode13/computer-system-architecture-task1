all: basic functions modular

asm: asm.s
	gcc asm.s -o asm

basic: basic.s
	gcc basic.s -o basic

basic.s: basic.c
	gcc -S basic.c -o basic.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

functions: functions.s
	gcc functions.s -o functions

functions.s: functions.c
	gcc -S functions.c -o functions.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

modular: modular-main.s modular-io.s modular-make.s modular-file.s modular-generator.s
	gcc modular-main.s modular-io.s modular-make.s modular-file.s modular-generator.s -o modular

modular-main.s: modular-main.c
	gcc -S modular-main.c -o modular-main.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

modular-io.s: modular-io.c
	gcc -S modular-io.c -o modular-io.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

modular-make.s: modular-make.c
	gcc -S modular-make.c -o modular-make.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

modular-file.s: modular-file.c
	gcc -S modular-file.c -o modular-file.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none

modular-generator.s: modular-generator.c
	gcc -S modular-generator.c -o modular-generator.s -masm=intel -O0 -Wall -fno-asynchronous-unwind-tables -fcf-protection=none
