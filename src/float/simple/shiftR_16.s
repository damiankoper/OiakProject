.text
.globl simple_shiftR_16
# simple_shiftr(int8* A, int8 times)
simple_shiftR_16:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  xor %ecx, %ecx

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %cl # ile razy

  timesLoop:
    clc
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
