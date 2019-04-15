.data
buffer: .space 16
.text
.globl halfToFloat
# floatToHalf(int8* halfSrc, int8* floatDest)
# Konwersja wedle ustaleń nie podlega ograniczeniu 8b
halfToFloat:
  pushl	%ebp
  movl	%esp, %ebp
  pusha

  movl 8(%ebp), %eax
  movl 12(%ebp), %ebx
  mov (%eax), %eax
  mov %eax, buffer
  movups buffer, %xmm2
  # Bardzo fajna instrukcja
  VCVTPH2PS %xmm2, %xmm1
  
  movups %xmm1, buffer
  mov buffer, %eax
  mov %eax, (%ebx)
  

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
