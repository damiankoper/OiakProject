.text
.globl simple_shiftR_64
# simple_shiftr(int8* A, int8 times)
simple_shiftR_64:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  xor %ecx, %ecx

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %cl # ile razy

  timesLoop:
    clc
    movb 7(%eax), %bl
    rcrb %bl
    movb %bl, 7(%eax)

    movb 6(%eax), %bl
    rcrb %bl
    movb %bl, 6(%eax)

    movb 5(%eax), %bl
    rcrb %bl
    movb %bl, 5(%eax)

    movb 4(%eax), %bl
    rcrb %bl
    movb %bl, 4(%eax)

    movb 3(%eax), %bl
    rcrb %bl
    movb %bl, 3(%eax)

    movb 2(%eax), %bl
    rcrb %bl
    movb %bl, 2(%eax)

    movb 1(%eax), %bl
    rcrb %bl
    movb %bl, 1(%eax)

    movb (%eax), %bl
    rcrb %bl
    movb %bl, (%eax)
    
    loop timesLoop

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
