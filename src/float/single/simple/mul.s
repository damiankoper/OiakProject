.data 
  result: .long 0
          .long 0
  buffer: .long 0
          .long 0
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

  call simple_mul_clearResult

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
      movb %al, buffer(,%edx,1)
      inc %edx
      movb %ah, buffer(,%edx,1)

      # Dodanie bufora do wyniku
      pushl $buffer
      pushl $result
      call simple_add_64

      call simple_mul_clearBuffer

      pop %edi
      inc %di
      cmp $4, %di
      jne simple_mul_innerLoop

    inc %si
    cmp $4, %si
    jne simple_mul_outerLoop

  # Wpisywanie wyniku pod wskażniki z argumentów z adresu 'result'
  # Część wyższa
  mov $0, %eax
  simple_mul_resultLoop1:
    movb result(,%eax,1), %dl
    movb %edx, (%ecx, %eax, 1)

    inc %eax
    cmp $4, %eax
    jne simple_mul_resultLoop1

  # Część niższa
  mov $4, %eax
  mov $0, %ecx
  simple_mul_resultLoop2:
    movb result(, %eax, 1), %dl
    movb %dl, (%ebx, %ecx, 1)

    inc %ecx
    inc %eax
    cmp $8, %eax
    jne simple_mul_resultLoop2

  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


# Mali pomocnicy do czyszczenia buforów
simple_mul_clearBuffer:
  pusha
  mov $8, %ecx

  simple_mul_clearBufferLoop:
    dec %ecx
    movb $0, buffer(,%ecx,1)
    inc %ecx
    loop simple_mul_clearBufferLoop
  popa
  ret

simple_mul_clearResult:
  pusha
  mov $8, %ecx

  simple_mul_clearResultLoop:
    dec %ecx
    movb $0, result(,%ecx,1)
    inc %ecx
    loop simple_mul_clearResultLoop
  popa
  ret
  