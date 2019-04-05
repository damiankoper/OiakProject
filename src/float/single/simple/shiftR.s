.text
.globl simple_shiftR
# simple_shiftr(int8* A, int8 times)
simple_shiftR:
  pushl	%ebp
	movl	%esp, %ebp

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %ecx # ile razy
  clc

  timesLoop:
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

	movl	%ebp, %esp
	popl	%ebp
	ret $8
