    .intel_syntax noprefix
    .text

    .globl  console
    .type   console, @function
console:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14

    # int* src_array = read_array(&src_size);
    call    read_array
    mov ebx, edx                # src_size
    mov r12, rax                # src_array

    # int* new_array = make_array(src_array, src_size, &new_size)
    mov esi, ebx                # int src_size
    mov rdi, r12                # const int *src_array
    call    make_array
    mov r13d, edx               # new_size
    mov r14, rax                # new_array

    # free(src_array);
    mov rdi, r12                # src_array
    call    free@PLT

    # print_array(new_array, new_size);
    mov esi, r13d               # int size <- new_size
    mov rdi, r14                # int *array <- new_array
    call    print_array

    # free(new_array);
    mov rdi, r14                # new_array
    call    free@PLT
    mov eax, 0

    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  file
    .type   file, @function
file:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    sub rsp, 8

    mov r15, rsi

    # int* src_array = read_array_file(input_file, &src_size);
    call    read_array_file
    mov ebx, edx                # src_size
    mov r12, rax                # src_array

    # int* new_array = make_array(src_array, src_size, &new_size)
    mov esi, ebx                # int src_size
    mov rdi, r12                # const int *src_array
    call    make_array
    mov r13d, edx               # new_size
    mov r14, rax                # new_array

    # free(src_array);
    mov rdi, r12                # src_array
    call    free@PLT

    # write_array_file(output_file, new_array, new_size);
    mov edx, r13d               # int size <- new_size
    mov rsi, r14                # int *array <- new_array
    mov rdi, r15
    call    write_array_file

    # free(new_array);
    mov rdi, r14                # new_array
    call    free@PLT
    mov eax, 0

    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  generator
    .type   generator, @function
generator:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14

    mov ebx, edi                # src_size

    # int* src_array = generate_array(src_size);
    call    generate_array
    mov r12, rax                # src_array

    # print_array(src_array, src_size);
    mov esi, ebx                # int size <- src_size
    mov rdi, r12                # int *array <- src_array
    call    print_array

    # int* new_array = make_array(src_array, src_size, &new_size)
    mov esi, ebx                # int src_size
    mov rdi, r12                # const int *src_array
    call    make_array
    mov r13d, edx               # new_size
    mov r14, rax                # new_array

    # free(src_array);
    mov rdi, r12                # src_array
    call    free@PLT

    # print_array(new_array, new_size);
    mov esi, r13d               # int size <- new_size
    mov rdi, r14                # int *array <- new_array
    call    print_array

    # free(new_array);
    mov rdi, r14                # new_array
    call    free@PLT
    mov eax, 0

    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  main
    .type   main, @function
main:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    sub rsp, 8                  # Reserve space for local variables
    mov rax, QWORD PTR fs:40    # Stack canary
    mov QWORD PTR -16[rbp], rax
    xor eax, eax

    mov rbx, rsi
    cmp rdi, 3
    je file_mode

    cmp rdi, 2
    je  generator_mode

    jmp console_mode

file_mode:
    mov rsi, QWORD PTR 16[rbx]
    mov rdi, QWORD PTR 8[rbx]
    call    file
    jmp canary

generator_mode:
    mov edx, 10
    mov esi, 0
    mov rdi, QWORD PTR 8[rbx]
    call    strtoul@PLT
    mov rdi, rax
    call    generator
    jmp canary

console_mode:
    call    console

canary:
    mov rdx, QWORD PTR -16[rbp]  # Stack canary
    sub rdx, QWORD PTR fs:40
    je  end
    call    __stack_chk_fail@PLT
end:
    add rsp, 8
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
