    .intel_syntax noprefix
    .text

    .section    .rodata
size_format:
    .string "%u"
in_number_format:
    .string "%d"
out_number_format:
    .string "%d "

    .text
    .globl  read_array
    .type   read_array, @function
read_array:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    sub rsp, 8                  # Reserve space for local variables

    # scanf("%d", &src_size);
    lea rsi, -32[rbp]
    lea rdi, size_format[rip]   # Input format
    mov eax, 0                  # Integer value
    call    __isoc99_scanf@PLT
    mov r12d, DWORD PTR -32[rbp]    # size

    # int *array = malloc(*size * sizeof(int));
    mov rdi, r12                # size
    sal rdi, 2
    call    malloc@PLT
    mov r13, rax                # array

    # Input loop
    mov rbx, 0                  # i
    jmp input_loop_condition
input_loop_body:
    # scanf("%d", &src_array[i]);
    lea rsi, [rbx*4]
    add rsi, r13                # array
    lea rdi, in_number_format[rip]  # Input format
    mov eax, 0                  # Integer value
    call    __isoc99_scanf@PLT

    add rbx, 1                  # i
input_loop_condition:
    cmp rbx, r12                # i, size
    jl  input_loop_body

    mov rax, r13
    mov rdx, r12

    add rsp, 8
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  make_array
    .type   make_array, @function
make_array:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    sub rsp, 8                  # Reserve space for local variables

    mov r12, rdi                # src_array
    mov r13, rsi                # src_size

    # int *new_array = malloc(src_size * sizeof(int));
    mov rdi, r13                # src_size
    sal rdi, 2
    call    malloc@PLT
    mov r14, rax                # new_array
    mov r15, 0                  # new_size

    # Make loop
    mov rbx, 0                  # i
    jmp make_loop_condition
make_loop_body:
    # If src_array[i] % 2 != 0 then continue
    lea rax, [rbx*4]
    add rax, r12                # src_array
    mov eax, DWORD PTR [rax]    # src_array[i]
    and eax, 1
    test    eax, eax
    jne make_loop_increment

    # If src_array[i] >= 0 then continue
    lea rax, [rbx*4]
    add rax, r12                # src_array
    mov eax, DWORD PTR [rax]    # src_array[i]
    test    eax, eax
    jns make_loop_increment

    # new_array[new_size++] = src_array[i];
    lea rdx, [rbx*4]
    mov rax, r12                # src_array
    lea rcx, [rdx+rax]          # Address of src_array[i]
    lea rdx, [r15*4]
    add rdx, r14                # Address of new_array[new_size]
    mov eax, DWORD PTR [rcx]    # src_array[i]
    mov DWORD PTR [rdx], eax    # new_array[new_size]
    add r15, 1
make_loop_increment:
    add rbx, 1                  # i
make_loop_condition:
    cmp rbx, r13                # i, src_size
    jl  make_loop_body

    mov rax, r14                # new_array
    mov rdx, r15

    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  print_array
    .type   print_array, @function
print_array:
    push    rbp
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    sub rsp, 8
    mov r12, rdi                # array
    mov r13d, esi               # size

    # Output loop
    mov rbx, 0                  # i
    jmp output_loop_condition
output_loop_body:
    # printf("%d ", array[i]);
    lea rax, [rbx*4]
    add rax, r12                # Address of array[i]
    mov esi, DWORD PTR [rax]    # array[i]
    lea rdi, out_number_format[rip] # Output format
    mov eax, 0
    call    printf@PLT
    add rbx, 1                  # i
output_loop_condition:
    cmp rbx, r13                # i, size
    jl  output_loop_body

    # printf("\n");
    mov edi, 10
    call    putchar@PLT

    add rsp, 8
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
