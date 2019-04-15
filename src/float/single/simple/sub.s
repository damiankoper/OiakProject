.text
.globl simple_sub
# simple_add(int8* A, int8* B)
# A = A - B
# a0a1a2a3 = a0a1a2a3 - b0b1b2b3
simple_sub:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %eax
  mov 12(%ebp), %ebx

  movb (%ebx), %dl
  subb %dl, (%eax)

  movb 1(%ebx), %dl
  sbbb %dl, 1(%eax)

  movb 2(%ebx), %dl
  sbbb %dl, 2(%eax)

  movb 3(%ebx), %dl
  sbbb %dl, 3(%eax)

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
