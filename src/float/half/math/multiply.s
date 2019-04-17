.text
.globl half_mul

half_mul:

	pushl	%ebp
	pushl	%edi
    pushl   %esi
	movl	%esp, %ebp

	subl 	$0x3, %esp

    movl %ebp, %edi
    addl $20, %edi

    movl %ebp, %esi
    addl $24, %esi

    xor %ecx, %ecx

    # | float b			| 0x18(%ebp)
    # | float a			| 0x14(%ebp)
    # | float* wynik	| 0x10(%ebp)
    # | ret addr		| 0xc(%ebp)
    # | kopia EBP       | 0x8(%ebp)
    # | kopia EDI		| 0x4(%ebp)
    # | kopia ESI		| 0x0(%ebp)
    # | EXP             | -0x1(%ebp)
    # | znak A          | -0x2(%ebp)
    # | znak B          | -0x3(%ebp)


    movb 0x15(%ebp), %dl
    shlb $1, %dl
    jc UJEMNA_A
    movb $0, -0x2(%ebp)

    jmp EXP_2
UJEMNA_A:
    movb $1, -0x2(%ebp)
EXP_2:

    movb 0x19(%ebp), %cl
    shlb $1, %cl
    jc UJEMNA_B
    movb $0, -0x3(%ebp)

    jmp DALEJ

UJEMNA_B:
    movb $1, -0x3(%ebp)
DALEJ:

    shrb $3, %dl
    shrb $3, %cl

    cmpb $0, %cl
    je ZERO
    cmpb $0, %dl
    je ZERO
    cmpb $31, %cl
    je INFINITY
    cmpb $31, %dl
    je INFINITY
    jmp DALEJ_2
ZERO:
    movb $0, 0x14(%ebp)
    movb $0, 0x15(%ebp)

    jmp RESULT

INFINITY:
   
    movb $0,  0x14(%ebp)
    movb $124, 0x15(%ebp)

    jmp CHECK_SIGN

DALEJ_2:

	subb	$15-1, %dl	
	addb	%cl, %dl	

    movb %dl, -0x1(%ebp)

    andb $3, 0x19(%ebp)

    movb 0x19(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x19(%ebp)

    andb $3, 0x15(%ebp)

    movb 0x15(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x15(%ebp)

    push %edi
    push %esi
    call simple_mul_16

    movb 0x18(%ebp), %al
    movb %al, 0x16(%ebp)


    push $2
    push %edi
    call simple_shiftL_32

    movb $0, %dl
    movb 0x16(%ebp), %al

LOOP:    
    shlb $1, %al
    jc LOOP_EXIT
    addb $1, %dl
    jmp LOOP
LOOP_EXIT:

    movb -0x1(%ebp), %al
    subb %dl, %al
    addb $1, %dl

    movb $0, %cl
    movb %dl, %cl

    push %ecx
    push %edi
    call simple_shiftL_32

    movb %al, 0x17(%ebp)

    push $13
    push %edi
    call simple_shiftR_32

ADDING_THE_SIGN:

    push $1
    push %edi
    call simple_shiftR_16

CHECK_SIGN:

    movb -0x2(%ebp), %al
    movb -0x3(%ebp), %dl
    cmpb %al, %dl
    je RESULT
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
    popl    %ebp
    ret