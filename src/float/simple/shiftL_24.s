.text
.globl simple_shiftL_24
# simple_shiftL_32(int8* A, int8 times)
simple_shiftL_24:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %ecx # ile razy

  timesLoop:
    clc
    movb (%eax), %bl
    rclb %bl
    movb %bl, (%eax)

    movb 1(%eax), %bl
    rclb %bl
    movb %bl, 1(%eax)

    movb 2(%eax), %bl
    rclb %bl
    movb %bl, 2(%eax)
    
    loop timesLoop

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
