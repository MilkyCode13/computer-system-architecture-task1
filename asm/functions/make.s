    .intel_syntax noprefix
    .text
    .globl  make_array
    .type   make_array, @function
make_array:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    sub rsp, 48                 # Reserve space for local variables

    mov QWORD PTR -24[rbp], rdi # src_array
    mov QWORD PTR -32[rbp], rsi # src_size
    mov QWORD PTR -40[rbp], rdx # Address of new_size

    # int *new_array = malloc(src_size * sizeof(int));
    mov rax, QWORD PTR -32[rbp] # src_size
    cdqe
    sal rax, 2
    mov rdi, rax
    call    malloc@PLT
    mov QWORD PTR -8[rbp], rax  # new_array
    mov QWORD PTR -48[rbp], 0   # new_size

    # Make loop
    mov QWORD PTR -16[rbp], 0   # i
    jmp make_loop_condition
make_loop_body:
    # If src_array[i] % 2 != 0 then continue
    mov rax, QWORD PTR -16[rbp] # i
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    and eax, 1
    test    eax, eax
    jne make_loop_increment

    # If src_array[i] >= 0 then continue
    mov rax, QWORD PTR -16[rbp] # i
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    test    eax, eax
    jns make_loop_increment

    # new_array[new_size++] = src_array[i];
    mov rax, QWORD PTR -16[rbp] # i
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    lea rcx, [rdx+rax]
    mov rax, QWORD PTR -48[rbp] # new_size
    lea rdx, 1[rax]
    mov QWORD PTR -48[rbp], rdx # new_size
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -8[rbp]  # new_array
    add rdx, rax
    mov eax, DWORD PTR [rcx]    # src_array[i]
    mov DWORD PTR [rdx], eax    # new_array[new_size]
make_loop_increment:
    add QWORD PTR -16[rbp], 1   # i
make_loop_condition:
    mov rax, QWORD PTR -32[rbp] # src_size
    cmp QWORD PTR -16[rbp], rax # i
    jl  make_loop_body

    mov rax, QWORD PTR -40[rbp] # Address of new_size
    mov rcx, QWORD PTR -48[rbp] # new_size
    mov QWORD PTR [rax], rcx
    mov rax, QWORD PTR -8[rbp]  # new_array
    leave
    ret
