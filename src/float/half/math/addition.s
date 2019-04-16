.text
.globl half_add
half_add:

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
# | znakA           | -0x1(%ebp)
# | znakB           | -0x2(%ebp)
# | EXP           | -0x3(%ebp)

# Wyrównanie wykładników	

# Wykładnik 1
    
    movb $0, %dl
    movb 0x15(%ebp), %al
    shlb $1, %al
    adcb $0, %dl
    movb %dl, -0x1(%ebp)



    movb $0, %dl
    movb 0x19(%ebp), %ah
    shlb $1, %ah
    adcb $0, %dl
    movb %dl, -0x2(%ebp)

    shrb $3, %al
    shrb $3, %ah
    
    cmpb $31, %al
    je INFINITY
    cmpb $31, %ah
    je INFINITY

    cmpb %ah, %al    
    jb SWAP 
    jmp M

SWAP:

    movb -0x1(%ebp), %cl
    movb -0x2(%ebp), %ch
    movb %cl, -0x2(%ebp)
    movb %ch, -0x1(%ebp)

    movb %al, %cl
    movb %ah, %al
    movb %cl, %ah

    movb 0x14(%ebp), %cl
    movb 0x18(%ebp), %ch
    movb %cl, 0x18(%ebp)
    movb %ch, 0x14(%ebp)

    movb 0x15(%ebp), %cl
    movb 0x19(%ebp), %ch
    movb %cl, 0x19(%ebp)
    movb %ch, 0x15(%ebp)

M:

    movb %al, -0x3(%ebp)
    subb %ah, %al
    xor %ah, %ah

    push $6
    push %esi
    call simple_shiftL_16

    push $6
    push %esi
    call simple_shiftR_16

    movb 0x19(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x19(%ebp)

    push $6
    push %edi
    call simple_shiftL_16

    push $6
    push %edi
    call simple_shiftR_16

    movb 0x15(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x15(%ebp)


    cmpb $0, %al
    je DONT_SHIFT
    push %eax
    push %esi
    call simple_shiftR_16
DONT_SHIFT:
    movb -0x1(%ebp), %al
    movb -0x2(%ebp), %ah
    cmpb %al, %ah
    je ADD
    jmp OTHER_ADD

ADD:

    push %esi
    push %edi
    call simple_add_16

    movb 0x15(%ebp), %al
    cmpb $7, %al
    jg ADD_TO_EXP

  
    push $6
    push %edi
    call simple_shiftL_16
    jmp CHECK_SIGN

OTHER_ADD:

    push %esi
    push %edi
    call simple_sub_16

    movb 0x15(%ebp), %al
    movb 0x14(%ebp), %ch

    movb $0, %ah

LOOP2:
    cmpb $6, %ah
    je LOOP2_EXIT
    shlb $1, %ch
    rclb $1, %al
    incb %ah
    jmp LOOP2
LOOP2_EXIT: 

    movb $0, %dl

LOOP:
    shlb %ch
    rclb %al
    jc LOOP_EXIT
    addb $1, %dl
    jmp LOOP
LOOP_EXIT:

    movb -0x3(%ebp), %al
    addb $1, %dl
    subb %dl, %al
    movb %al, -0x3(%ebp)

    xor %ecx, %ecx
    movb %dl, %cl
    push %ecx
    push %edi
    call simple_shiftL_16

    push $6
    push %edi
    call simple_shiftL_16

    jmp CHECK_SIGN

ADD_TO_EXP:

    movb -0x3(%ebp), %cl
    addb $1, %cl

    push $5
    push %edi
    call simple_shiftL_16

    cmpb $31, %cl
    je INFINITY
    movb %cl, -0x3(%ebp)
    jmp CHECK_SIGN
    
INFINITY:
    movb $31, -0x3(%ebp)
    movb $0, 0x14(%ebp)
    movb $0, 0x15(%ebp)

CHECK_SIGN:

    movb -0x3(%ebp), %al
    movb %al, 0x16(%ebp)

    push $6
    push %edi
    call simple_shiftR_32

    movb -0x1(%ebp), %al
    cmpb $1, %al
    je CHANGE_SIGN
    jmp RESULT

CHANGE_SIGN:

    movb 0x15(%ebp), %al
    addb $128, %al
    movb %al, 0x15(%ebp)

RESULT:


    movl 0x0(%edi), %ecx
    movl 0x10(%ebp), %esi
    movl %ecx, 0x0(%esi)

	movl	%ebp, %esp
    popl    %esi
	popl	%edi
	popl	%ebp
	ret 