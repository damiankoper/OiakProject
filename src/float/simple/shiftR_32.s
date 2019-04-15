.text
.globl simple_shiftR_32
# simple_shiftr(int8* A, int8 times)
simple_shiftR_32:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  xor %ecx, %ecx

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %cl # ile razy

  timesLoop:
    clc
    # Index bajta
    mov $3, %edx
    movb (%eax, %edx, 1), %bl
    rcrb %bl
    movb %bl, (%eax, %edx, 1)

    dec %edx
    movb (%eax, %edx, 1), %bl
    rcrb %bl
    movb %bl, (%eax, %edx, 1)

    dec %edx
    movb (%eax, %edx, 1), %bl
    rcrb %bl
    movb %bl, (%eax, %edx, 1)

    dec %edx
    movb (%eax, %edx, 1), %bl
    rcrb %bl
    movb %bl, (%eax, %edx, 1)
    
    loop timesLoop

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
