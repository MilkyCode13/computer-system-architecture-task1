    .intel_syntax noprefix
    .text
    .globl  main
    .type   main, @function
main:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    sub rsp, 16                 # Reserve space for local variables
    mov rax, QWORD PTR fs:40    # Stack canary
    mov QWORD PTR -40[rbp], rax
    xor eax, eax

    # int* src_array = input_array(&src_size);
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

    mov rdx, QWORD PTR -40[rbp]  # Stack canary
    sub rdx, QWORD PTR fs:40
    je  end
    call    __stack_chk_fail@PLT
end:
    add rsp, 16
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
