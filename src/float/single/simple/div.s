.bss 
  result: .space 4
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
  movb $0, result(,%edi,1)
  inc %edi
  movb $0, result(,%edi,1)
  inc %edi
  movb $0, result(,%edi,1)
  inc %edi
  movb $0, result(,%edi,1)

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

  # Dzielenie nieodtwarzające

    push %edx
    push %ebx
    call simple_sub

  divLoop:
    push %ecx
    # Sprawdzamy zgodność znaków 
    movb (%ebx, %edi, 1), %al
    andb $0x80, %al  
    movb (%edx, %edi, 1), %cl  
    andb $0x80, %cl  
    pushf # zachowanie flag 

    push $1
    push %ebx
    call simple_shiftL

    popf # przywrócenie flag
    cmpb %al, %cl
    je subR
    jne addR

    addR:
        push %ebx
        push %edx
        call simple_add
        jmp addsubEnd
    subR:
        push %edx
        push %ebx
        call simple_sub

        # Wstawianie 1 na końcu wyniku
        mov $0, %edi
        movb result(,%edi,1), %al
        orb $0x01, %al
        movb $0x32, result
        mov $3, %edi
    addsubEnd:

    # Przesuwanie wyniku w lewo o 1
    push $1
    push $result
    call simple_shiftL

    pop %ecx
    loop divLoop  


  popa
	movl %ebp, %esp
	popl %ebp
	ret $8
