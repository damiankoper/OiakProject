.data
  firstTime: .byte 1
  xShift: .byte 0
.bss 
  div_result: .space 4
.text
.globl simple_div_64
# Tylko liczby dodatnie
# A = A/B; B = A%B
# Wynik A
# Reszta B
simple_div_64:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %ebx  # A
  mov 12(%ebp), %edx # B

  # A: 1 2 3 4
  # B: A B C D

  movb $0, div_result
  movb $0, div_result+1
  movb $0, div_result+2
  movb $0, div_result+3
  movb $0, div_result+4
  movb $0, div_result+5
  movb $0, div_result+6
  movb $0, div_result+7
  movb $1, firstTime
  movb $0, xShift

  # Sprawdzenie czy A < B
  mov $7, %edi
  div_cmpZeroLoop:
    movb (%ebx, %edi, 1), %ah
    movb (%edx, %edi, 1), %al
    cmpb %al, %ah
    ja div_ZeroContinue
    je div_ZeroIf

    # Kopiujemy resztę
    mov $7, %ecx
    div_result_zero_loop1:
      movb (%ebx, %ecx, 1), %al
      movb %al, (%edx, %ecx, 1)
      dec %ecx
      cmp $-1, %ecx
      jne div_result_zero_loop1

    # Kopiujemy wynik
    mov $7, %ecx
    div_result_zero_loop2:
      movb $0, (%ebx, %ecx, 1)
      dec %ecx
      cmp $-1, %ecx
      jne div_result_zero_loop2

    jmp divEnd

    div_ZeroIf:

    dec %edi
    cmp $-1, %edi
    jne div_cmpZeroLoop
  div_ZeroContinue:

  # Skalujemy A razem z B
  scaleLoopA:
    movb 7(%ebx), %al
    andb $0x20, %al
    cmpb $0x20, %al
    je scaleLoopAEnd

    incb xShift
    pushl $1
    pushl %ebx
    call simple_shiftL_64
    push $1
    push %edx
    call simple_shiftL_64
    jmp scaleLoopA
    scaleLoopAEnd:

  # Skalujemy B (wiemy, że A > B) i liczymy przesunięcia w %cl
  # Tyle razy wykonamy dzielenie, żeby uzyskać wszystkie bity wyniku
  xor %ecx, %ecx
  scaleLoopB:
    movb 7(%edx), %al
    andb $0x20, %al
    cmpb $0x20, %al
    je scaleLoopBEnd

    incb xShift
    push $1
    push %edx
    call simple_shiftL_64
    incb %cl
    jmp scaleLoopB
    scaleLoopBEnd:

  # Porównanie i korekcja skalowania
  mov $7, %edi
  div_cmpLoop:
    movb (%ebx, %edi, 1), %ah
    movb (%edx, %edi, 1), %al
    cmpb %al, %ah
    jb div_adjust_scale
    jae div_continue
    dec %edi
    cmp $-1, %edi
    jne div_cmpLoop
  div_adjust_scale:
    decb xShift
    push $1
    push %edx
    call simple_shiftR_64
    decb %cl
  div_continue:
  
  inc %ecx
  cmp $0, %ecx
  je divLoopEnd
  mov $7, %edi
  divLoop:
    push %ecx
  
    call compareAndAddBit

    cmpb $1, firstTime
    je notFirstTime
      push $1
      push %ebx
      call simple_shiftL_64

      # Przesuwanie wyniku w lewo o 1
      push $1
      push $div_result
      call simple_shiftL_64
    notFirstTime:
    movb $0, firstTime

    call compare
    je subR
    jne addR

    addR:
      push %edx
      push %ebx
      call simple_add_64
      jmp addsubEnd

    subR:
      push %edx
      push %ebx
      call simple_sub_64
    addsubEnd:

    clc
    pop %ecx
    loop divLoop
  divLoopEnd:

  call compareAndAddBit

  # Przywracamy resztę
  movb 3(%ebx), %al
  andb $0x80, %al  
  cmpb $0x80, %al 
  jne div_reminder_gt_zero
    push %edx
    push %ebx
    call simple_add_64
  div_reminder_gt_zero:

  push xShift
  push %ebx
  call simple_shiftR_64

  # Kopiujemy resztę
  mov $7, %ecx
  div_reminder_loop:
    movb (%ebx,%ecx,1), %al
    movb %al, (%edx, %ecx, 1)
    dec %ecx
    cmp $-1, %ecx
    jne div_reminder_loop

  # Kopiujemy wynik
  mov $7, %ecx
  div_result_loop:
    movb div_result(,%ecx,1), %al
    movb %al, (%ebx, %ecx, 1)
    dec %ecx
    cmp $-1, %ecx
    jne div_result_loop

  divEnd:
 
  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


###################### END

compareAndAddBit:
  call compare
  jne div_bit_zero
    # Wstawianie 1 na końcu wyniku jeśli znaki zgodne
    call setResultFirstBit
  div_bit_zero:
  ret

setResultFirstBit:
  movb div_result, %al
  orb $0x01, %al
  movb %al, div_result
  ret

compare:
  # Sprawdzamy zgodność znaków 
  movb 7(%ebx), %al
  andb $0x80, %al  
  movb 7(%edx), %cl  
  andb $0x80, %cl  
  cmpb %al, %cl
  ret
