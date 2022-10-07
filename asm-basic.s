    .intel_syntax noprefix
    .text

    .section    .rodata
in_number_format:
    .string "%d"
out_number_format:
    .string "%d "

    .text
    .globl  main
    .type   main, @function
main:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    sub rsp, 48                 # Reserve space for local variables
    mov rax, QWORD PTR fs:40    # Stack canary
    mov QWORD PTR -8[rbp], rax
    xor eax, eax

    # scanf("%d", &src_size);
    lea rax, -44[rbp]           # Address of src_size
    mov rsi, rax
    lea rax, in_number_format[rip]  # Input format
    mov rdi, rax
    mov eax, 0                  # Integer value
    call    __isoc99_scanf@PLT

    # int *src_array = malloc(src_size * sizeof(int));
    mov eax, DWORD PTR -44[rbp] # src_size
    cdqe
    sal rax, 2
    mov rdi, rax
    call    malloc@PLT
    mov QWORD PTR -24[rbp], rax # src_array

    # Input loop
    mov DWORD PTR -40[rbp], 0   # i
    jmp input_loop_condition
input_loop_body:
    # scanf("%d", &src_array[i]);
    mov eax, DWORD PTR -40[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx                # RAX = Address of src_array[i]
    mov rsi, rax
    lea rax, in_number_format[rip]  # Input format
    mov rdi, rax
    mov eax, 0                  # Integer value
    call    __isoc99_scanf@PLT

    add DWORD PTR -40[rbp], 1   # i
input_loop_condition:
    mov eax, DWORD PTR -44[rbp] # src_size
    cmp DWORD PTR -40[rbp], eax # i
    jl  input_loop_body

    # int *new_array = malloc(src_size * sizeof(int));
    mov eax, DWORD PTR -44[rbp] # src_size
    cdqe
    sal rax, 2
    mov rdi, rax
    call    malloc@PLT
    mov QWORD PTR -16[rbp], rax # new_array
    mov DWORD PTR -36[rbp], 0   # new_size

    # Make loop
    mov DWORD PTR -32[rbp], 0   # i
    jmp make_loop_condition
make_loop_body:
    # If src_array[i] % 2 != 0 then continue
    mov eax, DWORD PTR -32[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    and eax, 1
    test    eax, eax
    jne make_loop_increment

    # If src_array[i] >= 0 then continue
    mov eax, DWORD PTR -32[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    test    eax, eax
    jns make_loop_increment

    # new_array[new_size++] = src_array[i];
    mov eax, DWORD PTR -32[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    lea rcx, [rdx+rax]
    mov eax, DWORD PTR -36[rbp] # new_size
    lea edx, 1[rax]
    mov DWORD PTR -36[rbp], edx # new_size
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -16[rbp] # new_array
    add rdx, rax
    mov eax, DWORD PTR [rcx]    # src_array[i]
    mov DWORD PTR [rdx], eax    # new_array[new_size]
make_loop_increment:
    add DWORD PTR -32[rbp], 1   # i
make_loop_condition:
    mov eax, DWORD PTR -44[rbp] # src_size
    cmp DWORD PTR -32[rbp], eax # i
    jl  make_loop_body

    # free(src_array);
    mov rax, QWORD PTR -24[rbp] # src_array
    mov rdi, rax
    call    free@PLT

    # Output loop
    mov DWORD PTR -28[rbp], 0   # i
    jmp output_loop_condition
output_loop_body:
    # printf("%d ", new_array[i]);
    mov eax, DWORD PTR -28[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -16[rbp] # new_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # new_array[i]
    mov esi, eax
    lea rax, out_number_format[rip] # Output format
    mov rdi, rax
    mov eax, 0
    call    printf@PLT
    add DWORD PTR -28[rbp], 1   # i
output_loop_condition:
    mov eax, DWORD PTR -28[rbp] # i
    cmp eax, DWORD PTR -36[rbp] # new_size
    jl  output_loop_body

    # printf("\n");
    mov edi, 10
    call    putchar@PLT

    # free(new_array);
    mov rax, QWORD PTR -16[rbp] # new_array
    mov rdi, rax
    call    free@PLT
    mov eax, 0

    mov rdx, QWORD PTR -8[rbp]  # Stack canary
    sub rdx, QWORD PTR fs:40
    je  end
    call    __stack_chk_fail@PLT
end:
    leave
    ret
