.text
.globl simple_shiftR_32
# simple_shiftL(int8* A, int8 times)
simple_shiftR_32:
  pushl	%ebp
  movl	%esp, %ebp
  pusha
  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %ecx # ile razy

  cmp $0, %ecx
  je shilfL_32_exit

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
  
    shilfL_32_exit:
    popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8