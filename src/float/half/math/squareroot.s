.text
.globl half_sqrt

half_sqrt:

	pushl	%ebp
	pushl	%edi
    pushl   %esi
	movl	%esp, %ebp

	subl 	$0xd, %esp

    movl 0x14(%ebp), %edi
    movl %edi, -0x8(%ebp)
    movl %ebp, %edi
    subl $8, %edi

    movl %ebp, %esi
    subl $4, %esi

    movl %ebp, %ebx
    subl $12, %ebx

    xor %ecx, %ecx

# | float a			|  0x14(%ebp)
# | float *wynik    |  0x10(%ebp) 
# | ret addr		|  0xc(%ebp)
# | kopia EBP		|  0x8(%ebp)
# | kopia EDI		|  0x4(%ebp)
# | kopia ESI       |  0x0(%ebp)
# | Ri  			| -0x4(%ebp)
# | Liczba  		| -0x8(%ebp)
# | Qi              | -0xc(%ebp)
# | EXP             | -0xd(%ebp)

    movb $0, (%esi, %ecx, 1)
    movb $0, (%ebx, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    movb $0, (%ebx, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    movb $0, (%ebx, %ecx, 1)
    addb $1, %cl
    movb $0, (%esi, %ecx, 1)
    movb $0, (%ebx, %ecx, 1)

# Sprawdzam czy liczba jest dodatnia

    movb 0x15(%ebp), %al

    shlb $1, %al

    jc UNDOABLE

    shrb $3, %al

# Sprawdzam czy wykładnik jest parzysty

    cmpb $0, %al
    je ZERO

    subb $15, %al
    movb %al, %cl
    shrb $1, %cl
    jc ODD
    jmp EVEN

UNDOABLE:

    movl	%ebp, %esp
	popl	%edi
    popl    %esi
	popl	%ebp
	ret

ODD:

    subb $1, %al
    shrb $1, %al
    addb $15, %al

    movb %al, -0xd(%ebp)

# wykładnik gotowy
# Przesunięcie mantysy w lewo żeby pozbyć się najstarszego bitu, który jest częścią wykładnika

    andb $3, -0x7(%ebp)

    movb $1, %cl
    addb $4, (%edi, %ecx, 1)

    push $5
    push %edi
    call simple_shiftL_16

    //przesuniecie dodajace reszte

    movb -0x7(%ebp), %al
    movb %al, -0x4(%ebp)

    push $2
    push %edi
    call simple_shiftL_16


    push $6
    push %esi
    call simple_shiftR_16

    // esi - reszta

    movb $0, %cl
    addb $1, (%ebx, %ecx, 1)

    movb -0x4(%ebp), %al

    subb $1, %al
    movb %al, -0x4(%ebp)

    movb $0, %dl
    jmp ALGORITHM_LOOP

EVEN:

    shrb $1, %al
    addb $15, %al

    movb %al, -0xd(%ebp)

    andb $3, -0x7(%ebp)

    movb $1, %cl
    addb $4, (%edi, %ecx, 1)

    push $5
    push %edi
    call simple_shiftL_16

    push $1
    push %edi
    call simple_shiftL_16

    movb $0, %cl
    addb $1, (%ebx, %ecx, 1)

    movb $0, %dl

ALGORITHM_LOOP:

    cmpb $11, %dl
    je ALGORITHM_LOOP_EXIT


    movb -0x4(%ebp), %al
    movb -0x3(%ebp), %cl
    movb %al, -0x3(%ebp)
    movb %cl, -0x2(%ebp)


    movb -0x7(%ebp), %al
    movb %al, -0x4(%ebp)

    push $6
    push %esi
    call simple_shiftR_32

    push $2
    push %edi
    call simple_shiftL_16


    push $2
    push %ebx
    call simple_shiftL_16

    movb $0, %cl
    addb $1, (%ebx, %ecx, 1)

    movb $2, %cl
LOOP:    
    cmpb $0, %cl
    jl X_1
    movb (%esi, %ecx, 1), %al
    movb (%ebx, %ecx, 1), %ah
    cmpb %ah, %al
    jb X_0
    cmpb %ah, %al
    je DALEJ
    jmp X_1
DALEJ:

    decb %cl
    jmp LOOP
X_1:

    push %ebx
    push %esi
    call simple_sub_16

    push $1
    push %ebx
    call simple_shiftR_16


    movb -0xc(%ebp), %al
    andb $254, %al
    addb $1, %al
    movb %al, -0xc(%ebp)

    incb %dl
    jmp ALGORITHM_LOOP

X_0:

    push $2
    push %ebx
    call simple_shiftR_16

    push $1
    push %ebx
    call simple_shiftL_16

    incb %dl
    jmp ALGORITHM_LOOP

ALGORITHM_LOOP_EXIT:

    push $5
    push %ebx
    call simple_shiftL_32

    movb $2, %cl
    movb -0xd(%ebp), %al
    movb %al, (%ebx, %ecx, 1)

    push $5
    push %ebx
    call simple_shiftR_32

ADDING_THE_SIGN:

    push $1
    push %ebx
    call simple_shiftR_16

    movl 0x0(%ebx), %ecx
    movl 0x10(%ebp), %edi
    movl %ecx, 0x0(%edi)

    movl	%ebp, %esp
    popl    %esi
	popl	%edi
    popl    %ebp
    ret


    ZERO:

    movb $0, 0x1(%ebx)
    movb $0, 0x0(%ebx)
    jmp ADDING_THE_SIGN