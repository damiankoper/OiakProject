.text
.globl single_div

single_div:

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
    # | znak C          | -0x4(%ebp)

    # znak
    movb $0, %cl
    movb $0, %ch
    movb 0x21(%ebp), %al 
    movb 0x17(%ebp), %ah
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

    movb $3, %cl

    movb (%esi, %ecx, 1), %ah
    movb (%edi, %ecx, 1), %al

    subb %ah, %al
    addb $127, %al

    movb %al, -0x1(%ebp)

    # mantysa

    movb $0, (%edi, %ecx, 1)
    movb $0, (%esi, %ecx, 1)
    
    push $1
    push %edi
    call simple_shiftR

    movb $2, %cl
    addb $128, (%edi, %ecx, 1)


    push $1
    push %esi
    call simple_shiftR

    addb $128, (%esi, %ecx, 1)

    push %esi
    push %edi
    call simple_div

    



    movl	%ebp, %esp
    popl    %esi
	popl	%edi
    popl    %ebp
    ret
