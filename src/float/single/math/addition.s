.text
.globl single_add
single_add:

	pushl	%ebp
	pushl	%edi
    pushl   %esi
	movl	%esp, %ebp

	subl 	$0x3, %esp

    movl %ebp, %edi
    addl $20, %edi

    movl %ebp, %esi
    addl $24, %esi

    xor %eax, %eax
    movl $3, %ecx

# | float a			|  0x18(%ebp)
# | float b			|  0x14(%ebp)
# | float *wynik    |  0x10(%ebp) 
# | ret addr		|  0xc(%ebp)
# | kopia EBP		|  0x8(%ebp)
# | kopia ESI       |  0x4(%ebp)
# | kopia EDI		|  0x0(%ebp)
# | exp             | -0x1(%ebp)
# | znakA           | -0x2(%ebp)
# | znakB           | -0x3(%ebp)

# Wyrównanie wykładników	

# Wykładnik 1
    
    movb (%edi, %ecx, 1), %al
    movb (%esi, %ecx, 1), %ah
    
    movb $0, %dl
    shlb $1, %al
    adcb $0, %dl
    movb %dl, -0x1(%ebp)

    movb $0, %dh
    shlb $1, %ah
    adcb $0, %dh
    movb %dh, -0x2(%ebp)

    pushl $1
    pushl %edi   
    call simple_shiftL_32

    pushl $1
    pushl %esi
    call simple_shiftL_32

    movb (%edi, %ecx, 1), %al
    movb (%esi, %ecx, 1), %ah

    cmpb $255, %al
    je INFINITY
    cmpb $255, %al
    je INFINITY

    cmpb %ah, %al
    je COMPARE_M
    cmpb %ah, %al    
    jb SWAP 
    jmp M

COMPARE_M:

    decb %ecx

    cmpb $0, %cl
    jl M

    movb (%edi, %ecx, 1), %dl
    movb (%esi, %ecx, 1), %dh

    cmpb %dh, %dl
    jb SWAP
    jmp COMPARE_M

SWAP:

    movb %al, %cl
    movb %ah, %al
    movb %cl, %ah

    movb -0x1(%ebp), %dl
    movb -0x2(%ebp), %dh
    movb %dh, -0x1(%ebp)
    movb %dl, -0x2(%ebp)

    movl %edi, %ebx
    movl %esi, %edi
    movl %ebx, %esi 

M:

    movb %al, -0x3(%ebp)
    subb %ah, %al
    xor %ah, %ah

    push $8
    push %esi
    call simple_shiftL_32

    push $9
    push %esi
    call simple_shiftR_32

    movb $2, %cl
    addb $128, (%esi, %ecx, 1)

    push $8
    push %edi
    call simple_shiftL_32

    push $9
    push %edi
    call simple_shiftR_32

    addb $128, (%edi, %ecx, 1)

    cmpb $0, %eax
    je DONT_SHIFT
    push %eax
    push %esi
    call simple_shiftR_32
DONT_SHIFT:
    movb -0x1(%ebp), %al
    movb -0x2(%ebp), %ah
    cmpb %al, %ah
    je ADD
    jmp OTHER_ADD

ADD:

    push %esi
    push %edi
    call simple_add_32

    movb $3, %cl
    movb (%edi, %ecx, 1), %al
    cmpb $1, %al
    je ADD_TO_EXP
    push $1
    push %edi
    call simple_shiftL_32
    jmp CHECK_SIGN
OTHER_ADD:

    push %esi
    push %edi
    call simple_sub_32

    movl $2, %ecx
    movb (%edi, %ecx, 1), %al
    movl $1, %ecx
    movb (%edi, %ecx,1),  %ah
    movb $0, %ecx
    movb (%edi, %ecx, 1), %ch

    movb $0, %dl

LOOP: #TODO: bug here
    shlb %ch
    rclb %ah
    rclb %al
    jc LOOP_EXIT
    addb $1, %dl
    jmp LOOP
LOOP_EXIT:
    xor %ecx, %ecx

    movb -0x3(%ebp), %al
    subb %dl, %al
    movb %al, -0x3(%ebp)

    addb $1, %dl

    movb %dl, %cl
    push %ecx
    push %edi
    call simple_shiftL_32
    jmp CHECK_SIGN

ADD_TO_EXP:

    movb -0x3(%ebp), %cl
    addb $1, %cl
    cmpb $255, %cl
    je INFINITY
    movb %cl, -0x3(%ebp)
    jmp CHECK_SIGN
INFINITY:
    movb %cl, -0x3(%ebp)
    movb $0, %cl
    movb $0, (%edi, %ecx, 1)
    addb $1, %cl
    movb $0, (%edi, %ecx,1)
    addb $1, %cl
    movb $0, (%edi, %ecx, 1)
    addb $1, %cl
    movb $0, (%edi, %ecx, 1)

CHECK_SIGN:

    movb $3, %cl
    movb -0x3(%ebp), %al
    movb %al, (%edi, %ecx, 1)

    push $1
    push %edi
    call simple_shiftR_32

    movb -0x1(%ebp), %al
    cmpb $1, %al
    je CHANGE_SIGN
    jmp RESULT

CHANGE_SIGN:

    addb $128, (%edi, %ecx,1)

RESULT:

    movl 0x0(%edi), %ecx
    movl 0x10(%ebp), %esi
    movl %ecx, 0x0(%esi)

	movl	%ebp, %esp
    popl    %esi
	popl	%edi
	popl	%ebp
	ret 