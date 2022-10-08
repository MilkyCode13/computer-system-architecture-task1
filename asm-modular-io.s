    .intel_syntax noprefix
    .text

    .section    .rodata
size_format:
    .string "%lu"
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
