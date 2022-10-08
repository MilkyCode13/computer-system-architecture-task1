    .intel_syntax noprefix
    .text

    .section    .rodata
file_read_option:
    .string "r"
file_write_option:
    .string "w"
size_format:
    .string "%lu"
in_number_format:
    .string "%d"
out_number_format:
    .string "%d "

    .text
    .globl  read_array_file
    .type   read_array_file, @function
read_array_file:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    sub rsp, 16                  # Reserve space for local variables

    # FILE *file = fopen(filename, "r")
    lea rsi, file_read_option[rip]
    call    fopen@PLT
    mov r14, rax
    cmp r14, 0
    jne  read_array_file_can_read

    mov rax, 0
    mov rdx, 0
    jmp read_array_file_end

read_array_file_can_read:
    # fscanf(file, "%d", &src_size);
    lea rdx, -48[rbp]
    lea rsi, size_format[rip]   # Input format
    mov rdi, r14
    mov eax, 0                  # Integer value
    call    __isoc99_fscanf@PLT
    mov r12d, DWORD PTR -48[rbp]    # size

    # int *array = malloc(*size * sizeof(int));
    mov rdi, r12                # size
    sal rdi, 2
    call    malloc@PLT
    mov r13, rax                # array

    # Input loop
    mov rbx, 0                  # i
    jmp input_loop_condition
input_loop_body:
    # fscanf(file, "%d", &src_array[i]);
    lea rdx, [rbx*4]
    add rdx, r13                # array
    lea rsi, in_number_format[rip]  # Input format
    mov rdi, r14
    mov eax, 0                  # Integer value
    call    __isoc99_fscanf@PLT

    add rbx, 1                  # i
input_loop_condition:
    cmp rbx, r12                # i, size
    jl  input_loop_body

    # fclose(file);
    mov rdi, r14
    call    fclose@PLT

    mov rax, r13
    mov rdx, r12

read_array_file_end:
    add rsp, 16
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


    .globl  write_array_file
    .type   write_array_file, @function
write_array_file:
    push    rbp
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14

    mov r12, rsi                # array
    mov r13d, edx               # size

    # FILE *file = fopen(filename, "w");
    lea rsi, file_write_option[rip]
    call    fopen@PLT
    mov r14, rax

    # Output loop
    mov rbx, 0                  # i
    jmp output_loop_condition
output_loop_body:
    # fprintf(filename, "%d ", array[i]);
    lea rax, [rbx*4]
    add rax, r12                # Address of array[i]
    mov edx, DWORD PTR [rax]    # array[i]
    lea rsi, out_number_format[rip] # Output format
    mov rdi, r14
    mov eax, 0
    call    fprintf@PLT
    add rbx, 1                  # i
output_loop_condition:
    cmp rbx, r13                # i, size
    jl  output_loop_body

    # printf("\n");
    mov edi, 10
    mov rsi, r14
    call    fputc@PLT

    # fclose(file);
    mov rdi, r14
    call    fclose@PLT

    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
