.text
.globl simple_add_64
# simple_add(int8* A, int8* B)
# A = A + B
# a0a1a2a3 = a0a1a2a3 + b0b1b2b3
simple_add_64:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %eax
  mov 12(%ebp), %ebx

  # Index bajta
  mov $0, %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)

  inc %ecx
  movb (%ebx, %ecx, 1), %dl
  adcb %dl, (%eax, %ecx, 1)
  
  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
