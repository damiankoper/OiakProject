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

	movb	0x16(%ebp), %dl
	shlb	$1, %dl		
	movb	0x17(%ebp), %dl
	rclb	$1, %dl
    jc UJEMNA_A
    movb $0, -0x2(%ebp)
    jmp EXP_2
UJEMNA_A:
    movb $1, -0x2(%ebp)
EXP_2:

	movb	0x1a(%ebp), %cl
	shlb	$1, %cl		
	movb	0x1b(%ebp), %cl
	rclb	$1, %cl
    jc UJEMNA_B
    movb $0, -0x3(%ebp)
    jmp DALEJ

UJEMNA_B:
    movb $1, -0x3(%ebp)
DALEJ:

    cmpb $0, %cl
    je ZERO
    cmpb $0, %dl
    je ZERO
    cmpb $255, %cl
    je INFINITY
    cmpb $255, %dl
    je INFINITY
    jmp DALEJ_2
ZERO:
    movb $0, %cl
    movb $0, (%esi, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    movb $0, 0x20(%ebp)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
jmp RESULT
INFINITY:
    movb $0, %cl
    movb $0, (%esi, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    addb $1, %cl
    movb $255, (%esi, %ecx, 1)

jmp ADDING_THE_SIGN

DALEJ_2:

	subb	$127-1, %dl	
	addb	%cl, %dl	

    movb %dl, -0x1(%ebp)

    push $9
    push %esi
    call simple_shiftL

    push $9
    push %esi
    call simple_shiftR

    movb $2, %cl
    addb $128, (%esi, %ecx, 1)

    push $9
    push %edi
    call simple_shiftL

    push $9
    push %edi
    call simple_shiftR

    addb $128, (%edi, %ecx, 1)

    push %edi
    push %esi
    call simple_mul

    push $16
    push %edi
    call simple_shiftL_32

    movb $0, %dl
    movb $3, %cl
    movb (%esi, %ecx, 1), %al

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
    push %esi
    call simple_shiftL

    push $8
    push %esi
    call simple_shiftR

    movb $3, %cl
    movb %al, (%esi, %ecx, 1)

ADDING_THE_SIGN:

    push $1
    push %esi
    call simple_shiftR

    movb -0x2(%ebp), %al
    movb -0x3(%ebp), %dl
    cmpb %al, %dl
    je RESULT
    movb (%esi, %ecx, 1), %al
    addb $128, %al
    movb %al, (%esi, %ecx, 1)

RESULT:

    movl 0x0(%esi), %ecx
    movl 0x10(%ebp), %edi
    movl %ecx, 0x0(%edi)

    movl	%ebp, %esp
    popl    %esi
	popl	%edi
    popl    %ebp
    ret