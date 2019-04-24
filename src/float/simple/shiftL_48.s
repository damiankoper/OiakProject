.text
.globl simple_shiftL_48
# simple_shiftL_32(int8* A, int8 times)
simple_shiftL_48:
  pushl	%ebp
	movl	%esp, %ebp
  pusha
  # Wskaźnik na składnik jest na stosie
  mov 8(%ebp), %eax
  mov 12(%ebp), %ecx # ile razy

  cmp $0, %ecx
  je shilfL_64_exit

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

    movb 3(%eax), %bl
    rclb %bl
    movb %bl, 3(%eax)
    
    movb 4(%eax), %bl
    rclb %bl
    movb %bl, 4(%eax)

    movb 5(%eax), %bl
    rclb %bl
    movb %bl, 5(%eax)

    loop timesLoop
  
  shilfL_64_exit:
  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
