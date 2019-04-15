.data 
  mul_result: .long 0
          .long 0
  mul_buffer: .long 0
          .long 0
.text
.globl simple_mul_32
# simple_add_32(int8* A, int8* B)
# A = H(A*B), B = L(A*B)
simple_mul_32:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %ebx  # A
  mov 12(%ebp), %ecx # B

  # A: 1 2 3 4
  # B: A B C D

  call simple_mul_32_clearmul_result

  # Pętla iterująca po B
  mov $0, %esi
  simple_mul_32_outerLoop:

    # Pętla iterująca po A
    mov $0, %edi
    simple_mul_32_innerLoop:
      pushl %edi

      # Mnożenie składowych
      movb (%ebx, %edi, 1), %al
      mulb (%ecx, %esi, 1)

      # Wstawianie wyniku już na odpowiednie miejsce bufora (z przesunięciem)
      add %si, %di
      mov %edi, %edx
      movb %al, mul_buffer(,%edx,1)
      movb %ah, 1+mul_buffer(,%edx,1)

      # Dodanie bufora do wyniku
      pushl $mul_buffer
      pushl $mul_result
      call simple_add_32_64

      call simple_mul_32_clearmul_buffer

      pop %edi
      inc %di
      cmp $4, %di
      jne simple_mul_32_innerLoop

    inc %si
    cmp $4, %si
    jne simple_mul_32_outerLoop
  
  # Wpisywanie wyniku pod wskażniki z argumentów z adresu 'mul_result'
  # Część wyższa
  mov $0, %eax
  simple_mul_32_mul_resultLoop1:
    movb mul_result(,%eax,1), %dl
    movb %edx, (%ecx, %eax, 1)

    inc %eax
    cmp $4, %eax
    jne simple_mul_32_mul_resultLoop1

  # Część niższa
  mov $4, %eax
  mov $0, %ecx
  simple_mul_32_mul_resultLoop2:
    movb mul_result(, %eax, 1), %dl
    movb %dl, (%ebx, %ecx, 1)

    inc %ecx
    inc %eax
    cmp $8, %eax
    jne simple_mul_32_mul_resultLoop2

  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


# Mali pomocnicy do czyszczenia buforów
simple_mul_32_clearmul_buffer:
  push %ecx
  mov $8, %ecx
  simple_mul_32_clearmul_bufferLoop:
    movb $0, -1+mul_buffer(,%ecx,1)
    loop simple_mul_32_clearmul_bufferLoop
  pop %ecx
  ret

simple_mul_32_clearmul_result:
  push %ecx
  mov $8, %ecx
  simple_mul_32_clearmul_resultLoop:
    movb $0, -1+mul_result(,%ecx,1)
    loop simple_mul_32_clearmul_resultLoop
  pop %ecx
  ret
  