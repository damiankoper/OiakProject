.section .text
.globl shift_right

shift_right:

	pushl	%ebp
	pushl	%edi

	movl	%esp, %ebp

# | uint_8 c		|  0x11(%ebp)
# | uint_8 b		|  0x10(%ebp)
# | uint_8 a		|  0xf(%ebp)
# |	uint_8 *c		|  0xe(%ebp)
# | uint_8 *b		|  0xd(%ebp)
# | uint_8 *a		|  0xc(%ebp)
# | ret addr		|  0x8(%ebp)
# | kopia EBP		|  0x4(%ebp)
# | kopia EDI		|  0x0(%ebp)

	movb 0xf(%ebp), %dl 
	movb 0x10(%ebp), %cl
	movb 0x11(%ebp), %al

	shrb $1, %dl
	rcrb $1, %cl
	rcrb $1, %al

	movb %dl, 0xc(%ebp)
	movb %cl, 0xd(%ebp)
	movb %al, 0xe(%ebp)


	movl	%ebp, %esp
	popl	%edi
	popl	%ebp
	ret 