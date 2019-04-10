.data
  firstTime: .byte 1
.bss 
  div_result: .space 4
.text
.globl simple_div
# Tylko liczby dodatnie
# A = A/B; B = A%B
# Wynik A
# Reszta B
simple_div:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %ebx  # A
  mov 12(%ebp), %edx # B

  # A: 1 2 3 4
  # B: A B C D

  # TODO: Tutaj porównać czy A < B
  # jeśli tak to wynik = 0, reszta = A

  mov $0, %edi
  movb $0, div_result(,%edi,1)
  inc %edi
  movb $0, div_result(,%edi,1)
  inc %edi
  movb $0, div_result(,%edi,1)
  inc %edi
  movb $0, div_result(,%edi,1)
  movb $1, firstTime

  # Skalujemy A razem z B
  scaleLoopA:
    movb (%ebx, %edi, 1), %al
    andb $0x40, %al
    cmpb $0x40, %al
    je scaleLoopAEnd

    pushl $1
    pushl %ebx
    call simple_shiftL
    push $1
    push %edx
    call simple_shiftL
    jmp scaleLoopA
    scaleLoopAEnd:

  # Skalujemy B (wiemy, że A > B) i liczymy przesunięcia w %cl
  # Tyle razy wykonamy dzielenie, żeby uzyskać wszystkie bity wyniku
  xor %ecx, %ecx
  scaleLoopB:
    movb (%edx, %edi, 1), %al
    andb $0x40, %al
    cmpb $0x40, %al
    je scaleLoopBEnd

    push $1
    push %edx
    call simple_shiftL
    incb %cl
    jmp scaleLoopB
    scaleLoopBEnd:

  # Porównanie i korekcja skalowania
  movb (%ebx, %edi, 1), %ah
  movb (%edx, %edi, 1), %al
  cmpb %al, %ah
  jae div_continue

  push $1
  push %edx
  call simple_shiftR
  decb %cl
  div_continue:

  inc %ecx
  cmp $0, %ecx
  je divLoopEnd
  divLoop:
    push %ecx

    # Sprawdzamy zgodność znaków 
    movb (%ebx, %edi, 1), %al
    andb $0x80, %al  
    movb (%edx, %edi, 1), %cl  
    andb $0x80, %cl  
    cmpb %al, %cl
    pushf

    jne div_bit_zero
      # Wstawianie 1 na końcu wyniku jeśli znaki zgodne
      call setResultFirstBit
    div_bit_zero:

    cmpb $1, firstTime
    je notFirstTime
      push $1
      push %ebx
      call simple_shiftL

      # Przesuwanie wyniku w lewo o 1
      push $1
      push $div_result
      call simple_shiftL
    notFirstTime:
    movb $0, firstTime


    popf
    je subR
    jne addR

    addR:
      push %edx
      push %ebx
      call simple_add
      jmp addsubEnd

    subR:
      push %edx
      push %ebx
      call simple_sub
    addsubEnd:

    clc
    pop %ecx
    loop divLoop
  divLoopEnd:

  # Kopiujemy wynik
  mov $3, %ecx
  div_result_loop:
    movb div_result(,%ecx,1), %al
    movb %al, (%ebx, %ecx, 1)
    dec %ecx
    cmp $-1, %ecx
    jne div_result_loop

  # TODO: kopiowanie reszty
 
  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


setResultFirstBit:
  mov $0, %edi
  movb div_result(,%edi,1), %al
  orb $0x01, %al
  movb %al, div_result
  mov $3, %edi

  ret