	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"%d"
.LC1:
	.string	"%d "
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp     # Saving stack frame
	mov	rbp, rsp
	push	r15     # Saving essential registers
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 104    # Reserving stack space for local vars
	mov	rax, QWORD PTR fs:40        # Stack canary
	mov	QWORD PTR -56[rbp], rax
	xor	eax, eax    # Clear eax
	mov	rax, rsp
	mov	rbx, rax
	lea	rax, -112[rbp]  # arr_size
	mov	rsi, rax
	lea	rax, .LC0[rip]  # Format string
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT  # Call scanf
	mov	eax, DWORD PTR -112[rbp] # Copy arr_size
	movsx	rdx, eax    # Extend arr_size to 64-bit number
	sub	rdx, 1          # arr_size - 1
	mov	QWORD PTR -88[rbp], rdx # arr_size - 1
	movsx	rdx, eax    # arr_size again
	mov	QWORD PTR -128[rbp], rdx    # one more copy of arr_size...
	mov	QWORD PTR -120[rbp], 0
	movsx	rdx, eax    # arr_size again
	mov	QWORD PTR -144[rbp], rdx    # arr_size again
	mov	QWORD PTR -136[rbp], 0
	cdqe                # extending arr_size in eax to rax full w
	lea	rdx, 0[0+rax*4] # Hooray! Something interesting... Looks like some magic of array creating... Hmm... Ah! It's the length of the array in bytes, I assume...
	mov	eax, 16     # eax = 16
	sub	rax, 1      # rax = 15 (?)
	add	rax, rdx    # Length of something?
	mov	esi, 16     # esi = 16
	mov	edx, 0      # edx = 0
	div	rsi         # length of something / 16
	imul	rax, rax, 16    # length of something / 16 * 16... Aaaah! We just got the length aligned with multiples of 16!
	sub	rsp, rax    # Reserving array space! Hooray!
	mov	rax, rsp    # Saving new rsp to rax...
	add	rax, 3      # adding 3 (?)
	shr	rax, 2      # Shift to right twice ==> dividing by 4 ==> we got ceiled div
	sal	rax, 2      # Shift to left twice ==> we just rounded up to nearest multiple of 4
	mov	QWORD PTR -80[rbp], rax # Saving beginning of array address
	mov	DWORD PTR -108[rbp], 0  # new_size
	mov	DWORD PTR -104[rbp], 0  # First loop counter (i)
	jmp	.L2
.L4:                # First loop body
	mov	eax, DWORD PTR -104[rbp]    # i
	cdqe            # Extend i to 64 bits
	lea	rdx, 0[0+rax*4] # Calculate current array byte position
	mov	rax, QWORD PTR -80[rbp] # Address of begin of the array
	add	rax, rdx    # Getting address of the element
	mov	rsi, rax    # scanf second argument - address to put the number
	lea	rax, .LC0[rip]  # scanf input format
	mov	rdi, rax    # scanf input format
	mov	eax, 0      # Using integer numbers
	call	__isoc99_scanf@PLT  # Call scanf
	mov	rax, QWORD PTR -80[rbp] # Address of begin of the array
	mov	edx, DWORD PTR -104[rbp]    # i
	movsx	rdx, edx    # Extend i to 64 bits
	mov	eax, DWORD PTR [rax+rdx*4]  # Getting current element
	and	eax, 1      # Getting % 2
	test	eax, eax    # Check if elem % 2 == 1
	jne	.L3 # Then go
	add	DWORD PTR -108[rbp], 1  # Else increase new_size
.L3:
	add	DWORD PTR -104[rbp], 1  # Increment i
.L2:                # First loop condition check
	mov	eax, DWORD PTR -112[rbp]    # arr_size
	cmp	DWORD PTR -104[rbp], eax    # comparing first counter to arr_size
	jl	.L4         # Go inside if i < arr_size
	mov	eax, DWORD PTR -108[rbp]    # Copy new_size to eax
	movsx	rdx, eax    # Extend new_size to 64 bit
	sub	rdx, 1
	mov	QWORD PTR -72[rbp], rdx
	movsx	rdx, eax
	mov	r14, rdx
	mov	r15d, 0
	movsx	rdx, eax
	mov	r12, rdx
	mov	r13d, 0
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	edi, 16
	mov	edx, 0
	div	rdi
	imul	rax, rax, 16
	sub	rsp, rax
	mov	rax, rsp
	add	rax, 3
	shr	rax, 2
	sal	rax, 2
	mov	QWORD PTR -64[rbp], rax
	mov	DWORD PTR -100[rbp], 0
	mov	DWORD PTR -96[rbp], 0
	jmp	.L5
.L7:
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR -100[rbp]
	movsx	rdx, edx
	mov	eax, DWORD PTR [rax+rdx*4]
	and	eax, 1
	test	eax, eax
	jne	.L6
	mov	eax, DWORD PTR -96[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -96[rbp], edx
	mov	rdx, QWORD PTR -80[rbp]
	mov	ecx, DWORD PTR -100[rbp]
	movsx	rcx, ecx
	mov	ecx, DWORD PTR [rdx+rcx*4]
	mov	rdx, QWORD PTR -64[rbp]
	cdqe
	mov	DWORD PTR [rdx+rax*4], ecx
.L6:
	add	DWORD PTR -100[rbp], 1
.L5:
	mov	eax, DWORD PTR -112[rbp]
	cmp	DWORD PTR -100[rbp], eax
	jl	.L7
	mov	DWORD PTR -92[rbp], 0
	jmp	.L8
.L9:
	mov	rax, QWORD PTR -64[rbp]
	mov	edx, DWORD PTR -92[rbp]
	movsx	rdx, edx
	mov	eax, DWORD PTR [rax+rdx*4]
	mov	esi, eax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -92[rbp], 1
.L8:
	mov	eax, DWORD PTR -92[rbp]
	cmp	eax, DWORD PTR -108[rbp]
	jl	.L9
	mov	eax, 0
	mov	rsp, rbx
	mov	rdx, QWORD PTR -56[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L11
	call	__stack_chk_fail@PLT
.L11:
	lea	rsp, -40[rbp]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
