.text
.globl half_div

half_div:

	pushl	%ebp
	pushl	%edi
    pushl   %esi
	movl	%esp, %ebp

	subl 	$12, %esp

    movl %ebp, %edi
    addl $20, %edi

    movl %ebp, %edx
    subl $8, %edx

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
    # | znak C          | -0x4(%ebp)
    # | M               | -0x8(%ebp)
    # | A               | -0xc(%ebp)

    # znak
    movb $0, %cl
    movb $0, %ch
    movb 0x19(%ebp), %al 
    movb 0x15(%ebp), %ah
    shlb $1, %al
    adcb $0, %cl

    shlb $1, %ah
    adcb $0, %ch


    xor %ch, %cl
    movb %cl, -0x4(%ebp)

    # wykładnik

    push $1
    push %edi
    call simple_shiftL

    push $1
    push %esi
    call simple_shiftL

    push $1
    push %edx
    call simple_shiftL

    xor %ecx, %ecx
    movb $3, %cl

    movb 0x15(%ebp), %ah
    movb 0x19(%ebp), %al

    shrb $3, %ah
    shrb $3, %al

    cmpb $0, %ah
    je NAN_OR_INF
    cmpb $0, %al
    je ZERO

    subb %al, %ah
    addb $15, %ah

    movb %ah, -0x1(%ebp)


    # mantysa

    push $5
    push %edi
    call simple_shiftL

    push $6
    push %edi
    call simple_shiftR

    push $5
    push %esi
    call simple_shiftL 

    push $6
    push %esi
    call simple_shiftR

    movb 0x15(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x15(%ebp)

    movb 0x19(%ebp), %cl
    addb $4, %cl
    movb %cl, 0x19(%ebp)


    movb 0x18(%ebp), %al
    movb %al, -0xc(%ebp)
    movb 0x19(%ebp), %al
    movb %al, -0xb(%ebp)
 

    xor %ah, %ah


    movb $0, -0x8(%ebp)
    movb $0, -0x7(%ebp)
    movb $0, -0x6(%ebp)
    movb $0, -0x5(%ebp)


LOOP:

    cmpb $11, %ah
    je LOOP_EXIT

    push %esi
    push %edi
    call simple_div


    push $1
    push %esi
    call simple_shiftL

    movb 0x14(%ebp), %al    

    cmpb $1, %al
    je X_1
    jmp X_0

SWAP:

   // movl %edi, %esi

    movb $0, %cl
    movb -0xc(%ebp), %al
    movb %al, 0x0(%edi)
    movb -0xb(%ebp), %al
    movb %al, 0x1(%edi)


    movl %edi, %ebx
    movl %esi, %edi
    movl %ebx, %esi

    incb %ah
    jmp LOOP

X_1:

    movb $0, %cl
    stc
    jmp SHIFT
X_0:

    movb $0, %cl
    clc
    jmp SHIFT
SHIFT:

    movb -0x8(%ebp), %al
    rclb $1, %al    
    movb %al, -0x8(%ebp)
    movb -0x7(%ebp), %al
    rclb $1, %al    
    movb %al, -0x7(%ebp)
  
    jmp SWAP

LOOP_EXIT:
  
    push $6
    push %edx
    call simple_shiftL_32

    movb -0x6(%ebp), %al
    cmpb $1, %al
    jb SHIFT_EXP_M


    movb -0x1(%ebp), %al
    movb %al, -0x6(%ebp)

    push $5
    push %edx
    call simple_shiftR_32

    jmp ADDING_THE_SIGN

SHIFT_EXP_M:

    push $1
    push %edx
    call simple_shiftL_32

    movb -0x1(%ebp), %al
    subb $1, %al
    cmpb $0, %al
    je NAN

    movb %al, -0x6(%ebp)

    push $5
    push %edx
    call simple_shiftR_32

    jmp ADDING_THE_SIGN

ADDING_THE_SIGN:

    push $1
    push %edx
    call simple_shiftR

    movb -0x4(%ebp), %al
    cmpb $1, %al
    je CHANGE_SIGN
    jmp RESULT

CHANGE_SIGN:

    movb -0x7(%ebp), %al
    addb $128, %al
    movb %al, -0x7(%ebp)

RESULT:

    movl -0x8(%ebp), %ecx
    movl 0x10(%ebp), %edi
    movl %ecx, 0x0(%edi)

    movl	%ebp, %esp
    popl    %esi
	popl	%edi
    popl    %ebp
    ret


NAN_OR_INF:

    cmpb $0, %al
    je NAN

INF: 

    movb $0,   -0x8(%ebp)
    movb $248, -0x7(%ebp)
 
    jmp ADDING_THE_SIGN

NAN:

    movb $255, -0x8(%ebp)
    movb $255, -0x7(%ebp)

    jmp ADDING_THE_SIGN

ZERO:

    movb $0, -0x8(%ebp)
    movb $0, -0x7(%ebp)

    jmp ADDING_THE_SIGN