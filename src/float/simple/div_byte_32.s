.data 
  one: .long 1
.text
.globl simple_div_byte_32
# Tylko liczby dodatnie
# A = A/B;
# Wynik A
# Bez reszty
simple_div_byte_32:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %esi  # A
  mov 12(%ebp), %edi # B


  movb 3(%esi), %bl
  andb $0x80, %bl
  cmpb $0x80, %bl
  je NEG_A
  jmp NEG_A_END
  NEG_A:
  notb (%esi)
  notb 1(%esi)
  notb 2(%esi)
  notb 3(%esi)

  push $one
  push %esi
  call simple_add_32
  NEG_A_END:


  # A: 1 2 3 4
  # B:       A 

  movb $0, %ah
  movb 3(%esi), %al
  divb (%edi)
  movb %al, 3(%esi)

  movb 2(%esi), %al
  divb (%edi)
  movb %al, 2(%esi)

  movb 1(%esi), %al
  divb (%edi)
  movb %al, 1(%esi)

  movb (%esi), %al
  divb (%edi)
  movb %al, (%esi)

  cmpb $0x80, %bl
  je NEG_A1
  jmp NEG_A1_END
  NEG_A1:
  notb (%esi)
  notb 1(%esi)
  notb 2(%esi)
  notb 3(%esi)
  
  push $one
  push %esi
  call simple_add_32
  NEG_A1_END:

  popa
	movl %ebp, %esp
	popl %ebp
	ret $8
