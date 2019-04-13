.data 
  mul_result: .long 0
  mul_buffer: .long 0
.text
.globl simple_mul
# simple_add(int8* A, int8* B)
# A = H(A*B), B = L(A*B)
simple_mul:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %ebx  # A
  mov 12(%ebp), %ecx # B

  # A: 1 2 3 4
  # B: A B C D

  call simple_mul_clearmul_result

  # Pętla iterująca po B
  mov $0, %esi
  simple_mul_outerLoop:

    # Pętla iterująca po A
    mov $0, %edi
    simple_mul_innerLoop:
      pushl %edi

      # Mnożenie składowych
      movb (%ebx, %edi, 1), %al
      mulb (%ecx, %esi, 1)

      # Wstawianie wyniku już na odpowiednie miejsce bufora (z przesunięciem)
      add %si, %di
      mov %edi, %edx
      movb %al, mul_buffer(,%edx,1)
      inc %edx
      movb %ah, mul_buffer(,%edx,1)

      # Dodanie bufora do wyniku
      pushl $mul_buffer
      pushl $mul_result
      call simple_add_32

      call simple_mul_clearmul_buffer

      pop %edi
      inc %di
      cmp $2, %di
      jne simple_mul_innerLoop

    inc %si
    cmp $2, %si
    jne simple_mul_outerLoop
  
  # Wpisywanie wyniku pod wskażniki z argumentów z adresu 'mul_result'
  # Część wyższa
  mov $0, %eax
  simple_mul_mul_resultLoop1:
    movb mul_result(,%eax,1), %dl
    movb %edx, (%ecx, %eax, 1)

    inc %eax
    cmp $2, %eax
    jne simple_mul_mul_resultLoop1

  # Część niższa
  mov $2, %eax
  mov $0, %ecx
  simple_mul_mul_resultLoop2:
    movb mul_result(, %eax, 1), %dl
    movb %dl, (%ebx, %ecx, 1)

    inc %ecx
    inc %eax
    cmp $4, %eax
    jne simple_mul_mul_resultLoop2

  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


# Mali pomocnicy do czyszczenia buforów
simple_mul_clearmul_buffer:
  pusha
  mov $4, %ecx

  simple_mul_clearmul_bufferLoop:
    dec %ecx
    movb $0, mul_buffer(,%ecx,1)
    inc %ecx
    loop simple_mul_clearmul_bufferLoop
  popa
  ret

simple_mul_clearmul_result:
  pusha
  mov $4, %ecx

  simple_mul_clearmul_resultLoop:
    dec %ecx
    movb $0, mul_result(,%ecx,1)
    inc %ecx
    loop simple_mul_clearmul_resultLoop
  popa
  ret
  