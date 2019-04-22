.text
.globl single_sqrt

single_sqrt:

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
    movb 0x17(%ebp), %al # d
    movb 0x16(%ebp), %cl # c
    shlb $1, %cl
    rclb $1, %al
    jc UNDOABLE


    cmpb $0, %al
    je ZERO

# Sprawdzam czy wykładnik jest parzysty

    subb $127, %al
    movb %al, %cl
    shrb $1, %cl
    jc ODD
    jmp EVEN

UNDOABLE:


    movb $255, 0x3(%ebx)
    movb $255, 0x2(%ebx)
    push $1
    push %ebx
    call simple_shiftR_32

    movl 0x0(%ebx), %ecx
    movl 0x10(%ebp), %edi
    movl %ecx, 0x0(%edi)

    movl	%ebp, %esp
	popl	%edi
    popl    %esi
	popl	%ebp
	ret

ODD:

    subb $1, %al
    shrb $1, %al
    addb $127, %al

    movb %al, -0xd(%ebp)

# wykładnik gotowy
# Przesunięcie mantysy w lewo żeby pozbyć się najstarszego bitu, który jest częścią wykładnika


    movb -0x6(%ebp), %al
    andb $127, %al
    addb $128, %al 
   
    movb %al, -0x5(%ebp)
    movb -0x7(%ebp), %al
    movb %al, -0x6(%ebp)
    movb -0x8(%ebp), %al
    movb %al, -0x7(%ebp)
    movb $0, -0x8(%ebp)




    push $2
    push %edi
    call simple_shiftL_64


    movb $1, -0xc(%ebp)
    movb $1, -0x4(%ebp)
    /*
    push %ebx
    push %esi
    call simple_sub_32
*/

    movb $0, %dl

    jmp ALGORITHM_LOOP

EVEN:

    shrb $1, %al
    addb $127, %al

    movb %al, -0xd(%ebp)


    movb -0x6(%ebp), %al
    andb $127, %al
    addb $128, %al
   
    movb %al, -0x5(%ebp)
    movb -0x7(%ebp), %al
    movb %al, -0x6(%ebp)
    movb -0x8(%ebp), %al
    movb %al, -0x7(%ebp)
    movb $0, -0x8(%ebp)



    push $1
    push %edi
    call simple_shiftL_64


    movb $1, -0xc(%ebp)


    movb $1, -0xc(%ebp)
    movb $0, -0x4(%ebp)

/*
    push %ebx
    push %esi
    call simple_sub_32
*/

    movb $0, %dl

ALGORITHM_LOOP:

    cmpb $24, %dl
    je ALGORITHM_LOOP_EXIT

    push $2
    push %edi
    call simple_shiftL_64

    push $2
    push %ebx
    call simple_shiftL_32

//    movb $0, %cl
//    addb $1, (%ebx, %ecx, 1)

    addb $1, 0x0(%ebx)


/*
    movb $3, %cl
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
*/

    movb 0x3(%esi), %ah
    movb 0x2(%esi), %al
    movb 0x1(%esi), %dh
    movb 0x0(%esi), %cl


    cmpb $5, %dl
    jb DL8
    cmpb $13, %dl
    jb DL16
    cmpb $21, %dl
    jb DL24

    cmpb 0x3(%ebx), %ah
    jb X_0
    cmpb 0x3(%ebx), %ah
    ja X_1
DL24:
    cmpb 0x2(%ebx), %al
    jb X_0
    cmpb 0x2(%ebx), %al
    ja X_1
DL16:
    cmpb 0x1(%ebx), %dh
    jb X_0
    cmpb 0x1(%ebx), %dh
    ja X_1
DL8:
    cmpb 0x0(%ebx), %cl
    jb X_0



X_1:

    push %ebx
    push %esi
    call simple_sub_32

    push $1
    push %ebx
    call simple_shiftR_32

    movb -0xc(%ebp), %al
    andb $254, %al
    addb $1, %al
    movb %al, -0xc(%ebp)

    incb %dl
    jmp ALGORITHM_LOOP

X_0:

    push $1
    push %ebx
    call simple_shiftR_32

    movb -0xc(%ebp), %al
    andb $254, %al
    movb %al, -0xc(%ebp)


    incb %dl
    jmp ALGORITHM_LOOP

ALGORITHM_LOOP_EXIT:

    movb $3, %cl
    movb -0xd(%ebp), %al
    movb %al, (%ebx, %ecx, 1)


ADDING_THE_SIGN:

    push $1
    push %ebx
    call simple_shiftR_32


    movl 0x0(%ebx), %ecx
    movl 0x10(%ebp), %edi
    movl %ecx, 0x0(%edi)

    movl	%ebp, %esp
    popl    %esi
	popl	%edi
    popl    %ebp
    ret


ZERO:

    movb $0, 0x3(%ebx)
    movb $0, 0x2(%ebx)
    movb $0, 0x1(%ebx)
    movb $0, 0x0(%ebx)
    jmp ADDING_THE_SIGN