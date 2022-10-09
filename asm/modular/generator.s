    .intel_syntax noprefix
    .text
    .globl generate_array
    .type generate_array, @function
generate_array:
    push    rbp
    mov rbp, rsp
    push    rbx
    push    r12
    push    r13

    mov r12, rdi        # size

    mov edi, 0
    call    time@PLT
    mov edi, eax
    call    srandom@PLT

    mov rdi, r12        # size
    sal rdi, 2
    call    malloc@PLT
    mov r13, rax        # array

    mov rbx, 0          # i
    jmp generate_loop_condition
generate_loop_body:
    call    random@PLT
    mov edx, eax
    imul    rax, rax, 1152921497    # Magically dividing number by 1000000007 (btw, is it a good idea after all?...)
    sar eax, 60
    mov ecx, edx
    sar ecx, 31
    sub eax, ecx
    imul    ecx, eax, 1000000007    # Multiplying result by 1000000007
    mov eax, edx
    sub eax, ecx        # Getting remainder
    sub eax, 500000003  # Got good value

    lea rdx, [rbx*4]
    add rdx, r13        # Address of array[i]
    mov DWORD PTR [rdx], eax
    add rbx, 1          # i
generate_loop_condition:
    cmp rbx, r12        # i, size
    jb  generate_loop_body

    mov rax, r13

    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
