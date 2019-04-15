.text
.globl simple_sub_16
# simple_add(int8* A, int8* B)
# A = A - B
# a0a1 = a0a1 - b0b1
simple_sub_16:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %eax
  mov 12(%ebp), %ebx

  # Index bajta
  movb (%ebx), %dl
  subb %dl, (%eax)

  movb 1(%ebx), %dl
  sbbb %dl, 1(%eax)

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
