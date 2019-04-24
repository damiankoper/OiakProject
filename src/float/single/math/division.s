.text
.globl single_div

single_div:

	pushl	%ebp
	pushl	%edi
    pushl   %esi
	movl	%esp, %ebp

	subl 	$28, %esp

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
    # | A_2             | -0x10(%ebp)
    # | A_1             | -0x14(%ebp)
    # | B_2             | -0x18(%ebp)
    # | B_1             | -0x1c(%ebp)


    # znak
    movb $0, %cl
    movb $0, %ch
    movb 0x1b(%ebp), %al 
    movb 0x17(%ebp), %ah
    shlb $1, %al
    adcb $0, %cl

    shlb $1, %ah
    adcb $0, %ch


    xor %ch, %cl
    movb %cl, -0x4(%ebp)

    # wykładnik

    xor %ecx, %ecx
    movb $3, %cl

    movb 0x3(%esi), %ah
    movb 0x2(%esi), %cl

    shlb $1, %cl
    rclb $1, %ah

    movb 0x3(%edi), %al
    movb 0x2(%edi), %cl

    shlb $1, %cl
    rclb $1, %al

    cmpb $0, %ah
    je NAN_OR_INF
    cmpb $0, %al
    je ZERO

    subb %ah, %al
    addb $127, %al

    movb %al, -0x1(%ebp)


    # mantysa

    movb $0, 0x3(%edi)
    movb $0, 0x3(%esi)

    movb 0x2(%edi), %al
    andb $127, %al
    addb $128, %al
    movb %al, 0x2(%edi) 

    movb 0x2(%esi), %al
    andb $127, %al
    addb $128, %al
    movb %al, 0x2(%esi)

    #nowe
    
    movb 0x3(%edi), %al
    movb %al, -0x11(%ebp)
    movb 0x2(%edi), %al
    movb %al, -0x12(%ebp)
    movb 0x1(%edi), %al
    movb %al, -0x13(%ebp)
    movb 0x0(%edi), %al
    movb %al, -0x14(%ebp)
    movb $0, -0xd(%ebp)
    movb $0, -0xe(%ebp)
    movb $0, -0xf(%ebp)
    movb $0, -0x10(%ebp)


    movb 0x3(%esi), %al
    movb %al, -0x19(%ebp)
    movb 0x2(%esi), %al
    movb %al, -0x1a(%ebp)
    movb 0x1(%esi), %al
    movb %al, -0x1b(%ebp)
    movb 0x0(%esi), %al
    movb %al, -0x1c(%ebp)
    movb $0, -0x18(%ebp)
    movb $0, -0x17(%ebp)
    movb $0, -0x16(%ebp)
    movb $0, -0x15(%ebp)


    movl %ebp, %edi
    subl $20, %edi

    movl %ebp, %esi
    subl $28, %esi



    push $24
    push %edi
    call simple_shiftL_64

    push %esi
    push %edi
    call simple_div_64

    jmp LOOP_EXIT

/*
    xor %ah, %ah

    movb $0, -0x8(%ebp)
    movb $0, -0x7(%ebp)
    movb $0, -0x6(%ebp)
    movb $0, -0x5(%ebp)

LOOP:

    cmpb $25, %ah
    je LOOP_EXIT

    push %esi
    push %edi
    call simple_div_32


    push $1
    push %esi
    call simple_shiftL_32

    movb $0, %cl
    movb (%edi, %ecx, 1), %al
    cmpb $1, %al
    je X_1
    jmp X_0

SWAP:

    movb $0, %cl
    movb -0xc(%ebp), %al
    movb %al, 0x0(%edi)
    movb -0xb(%ebp), %al
    movb %al, 0x1(%edi)
    movb -0xa(%ebp), %al
    movb %al, 0x2(%edi)
    movb -0x9(%ebp), %al
    movb %al, 0x3(%edi)

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
    movb -0x6(%ebp), %al
    rclb $1, %al    
    movb %al, -0x6(%ebp)
    movb -0x5(%ebp), %al
    rclb $1, %al    
    movb %al, -0x5(%ebp)

    jmp SWAP
*/
LOOP_EXIT:

    movb 0x3(%edi), %al
    cmpb $0, %al
    je SHIFT_EXP_M

    movb -0x1(%ebp), %al
    movb %al, 0x3(%edi)
    jmp ADDING_THE_SIGN


SHIFT_EXP_M:

    push $1
    push %edi
    call simple_shiftL_32

    movb -0x1(%ebp), %al
    subb $1, %al
    cmpb $0, %al
    je NAN

    movb %al, 0x3(%edi)

    jmp ADDING_THE_SIGN


ADDING_THE_SIGN:

    push $1
    push %edi
    call simple_shiftR_32

    movb -0x4(%ebp), %al
    cmpb $1, %al
    je CHANGE_SIGN
    jmp RESULT


CHANGE_SIGN:

    movb 0x3(%edi), %al
    addb $128, %al
    movb %al, 0x3(%edi)

RESULT:

    movl 0x0(%edi), %ecx
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

    movb $0, 0x0(%edi)
    movb $0, 0x1(%edi)
    movb $0, 0x2(%edi)
    movb $255, 0x3(%edi)
    jmp ADDING_THE_SIGN

NAN:

    movb $255, 0x0(%edi)
    movb $255, 0x1(%edi)
    movb $255, 0x2(%edi)
    movb $255, 0x3(%edi)
    jmp ADDING_THE_SIGN

ZERO:

    movb $0, 0x0(%edi)
    movb $0, 0x1(%edi)
    movb $0, 0x2(%edi)
    movb $0, 0x3(%edi)
    jmp ADDING_THE_SIGN

