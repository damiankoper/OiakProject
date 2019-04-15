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
  movb (%ebx), %dl
  addb %dl, (%eax)
  
  movb 1(%ebx), %dl
  adcb %dl, 1(%eax)
  
  movb 2(%ebx), %dl
  adcb %dl, 2(%eax)

  movb 3(%ebx), %dl
  adcb %dl, 3(%eax)

  movb 4(%ebx), %dl
  adcb %dl, 4(%eax)

  movb 5(%ebx), %dl
  adcb %dl, 5(%eax)

  movb 6(%ebx), %dl
  adcb %dl, 6(%eax)

  movb 7(%ebx), %dl
  adcb %dl, 7(%eax)

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
