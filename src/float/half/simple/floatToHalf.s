.text
.globl floatToHalf
# floatToHalf(int8* floatSrc, int8* halfDest)
# A = A + B
# a0a1 = a0a1 + b0b1
floatToHalf:
  pushl	%ebp
  movl	%esp, %ebp
  pusha



  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
