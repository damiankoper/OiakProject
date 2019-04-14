.data
buffer: .space 8
.text
.globl floatToHalf
# floatToHalf(int8* floatSrc, int8* halfDest)
# Konwersja wedle ustaleń nie podlega ograniczeniu 8b
floatToHalf:
  pushl	%ebp
  movl	%esp, %ebp
  pusha

  movl 8(%ebp), %eax
  movl 12(%ebp), %ebx
  movups (%eax), %xmm2
  # Bardzo fajna instrukcja
  # Zaokrąglanie do parzystej 0x00 w imm8
  VCVTPS2PH $0b00000011, %xmm2, buffer
  
  mov buffer, %ax
  mov %ax, (%ebx)
  

  popa
	movl	%ebp, %esp
	popl	%ebp
	ret $8
