    .intel_syntax noprefix
    .text
    .globl  make_array
    .type   make_array, @function
make_array:
    push    rbp                 # Save stack frame
    mov rbp, rsp
    sub rsp, 48                 # Reserve space for local variables

    mov QWORD PTR -24[rbp], rdi # src_array
    mov DWORD PTR -28[rbp], esi # src_size
    mov QWORD PTR -40[rbp], rdx # Address of new_size

    # int *new_array = malloc(src_size * sizeof(int));
    mov eax, DWORD PTR -28[rbp] # src_size
    cdqe
    sal rax, 2
    mov rdi, rax
    call    malloc@PLT
    mov QWORD PTR -8[rbp], rax  # new_array
    mov DWORD PTR -44[rbp], 0   # new_size

    # Make loop
    mov DWORD PTR -16[rbp], 0   # i
    jmp make_loop_condition
make_loop_body:
    # If src_array[i] % 2 != 0 then continue
    mov eax, DWORD PTR -16[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    and eax, 1
    test    eax, eax
    jne make_loop_increment

    # If src_array[i] >= 0 then continue
    mov eax, DWORD PTR -16[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    add rax, rdx
    mov eax, DWORD PTR [rax]    # src_array[i]
    test    eax, eax
    jns make_loop_increment

    # new_array[new_size++] = src_array[i];
    mov eax, DWORD PTR -16[rbp] # i
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -24[rbp] # src_array
    lea rcx, [rdx+rax]
    mov eax, DWORD PTR -44[rbp] # new_size
    lea edx, 1[rax]
    mov DWORD PTR -44[rbp], edx # new_size
    cdqe
    lea rdx, 0[0+rax*4]
    mov rax, QWORD PTR -8[rbp]  # new_array
    add rdx, rax
    mov eax, DWORD PTR [rcx]    # src_array[i]
    mov DWORD PTR [rdx], eax    # new_array[new_size]
make_loop_increment:
    add DWORD PTR -16[rbp], 1   # i
make_loop_condition:
    mov eax, DWORD PTR -28[rbp] # src_size
    cmp DWORD PTR -16[rbp], eax # i
    jl  make_loop_body

    mov rax, QWORD PTR -40[rbp]
    mov ecx, DWORD PTR -44[rbp]
    mov DWORD PTR [rax], ecx
    mov rax, QWORD PTR -8[rbp]
    leave
    ret
