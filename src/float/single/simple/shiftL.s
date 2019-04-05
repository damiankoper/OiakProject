.text
.globl simple_shiftL
# simple_shiftL(int8* A, int8 times)
simple_shiftL:
  pushl	%ebp
	movl	%esp, %ebp

  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %ecx # ile razy
  clc

  timesLoop:
    # Index bajta
    mov $0, %edx
    movb (%eax, %edx, 1), %bl
    rclb %bl
    movb %bl, (%eax, %edx, 1)

    inc %edx
    movb (%eax, %edx, 1), %bl
    rclb %bl
    movb %bl, (%eax, %edx, 1)

    inc %edx
    movb (%eax, %edx, 1), %bl
    rclb %bl
    movb %bl, (%eax, %edx, 1)

    inc %edx
    movb (%eax, %edx, 1), %bl
    rclb %bl
    movb %bl, (%eax, %edx, 1)
    
    loop timesLoop

	movl	%ebp, %esp
	popl	%ebp
	ret $8
