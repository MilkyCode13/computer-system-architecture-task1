    .intel_syntax noprefix
    .text
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
