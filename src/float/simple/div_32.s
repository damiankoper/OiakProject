.data
  R: .long 1
  Rbuff: .long 0
.bss 
  Q: .space 4
  Qbuff: .space 4
  Dbuff: .space 4
.text
.globl simple_div_32
simple_div_32:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  # Wskaźniki na składniki są na stosie 
  mov 8(%ebp), %ebx  # N - nominator
  mov 12(%ebp), %edx # D - denominator

  push $Q
  push %ebx
  call copyFromTo

  push %edx
  call byteDiv

  # Oblicz pierwszą resztę
  push %edx
  push $R
  call simple_add_32

  # Jeśli ABS(R)>=D
  divLoop:
    # ABS

    push $Rbuff
    push $R
    call copyFromTo

    cmpb $0, R+3
    jge isPositive

    movb $0, Rbuff
    movb $0, Rbuff+1
    movb $0, Rbuff+2
    movb $0, Rbuff+3
    
    push $R
    push $Rbuff
    call simple_sub_32
    isPositive:

    # >= D
    mov $3, %ecx
    cmpLoop:
      movb Rbuff(,%ecx,1), %al
      cmpb %al, (%edx, %ecx, 1)
      ja divLoopEnd
      jb cmpLoopEnd
      dec %ecx
      cmp $-1, %ecx
      jne cmpLoop
    cmpLoopEnd:

    # Body:
    push $R
    push %ebx
    call copyFromTo

    push $Qbuff
    push $Q
    call copyFromTo

    push $Dbuff
    push %edx
    call copyFromTo
    
    push $Dbuff
    push $Qbuff
    call simple_mul_32

    push $Dbuff
    push $R
    call simple_sub_32

    push $Qbuff
    push $Q
    call copyFromTo

    push $Q
    push $R
    call copyFromTo

    push %edx
    call byteDiv

    sarb Q+3
    rcrb Q+2
    rcrb Q+1
    rcrb Q

    push $Qbuff
    push $Q
    call simple_add_32

    jmp divLoop
  divLoopEnd:
 
  push %ebx
  push $Q
  call copyFromTo

  push %edx
  push $R
  call copyFromTo

  popa
	movl %ebp, %esp
	popl %ebp
	ret $8


copyFromTo:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  mov 8(%ebp), %edx
  mov 12(%ebp), %ebx

    movb (%edx), %al
    movb %al, (%ebx)
    movb 1(%edx), %al
    movb %al, 1(%ebx)
    movb 2(%edx), %al
    movb %al, 2(%ebx)
    movb 3(%edx), %al
    movb %al, 3(%ebx)

  popa
	movl %ebp, %esp
	popl %ebp
  ret $8


byteDiv:
  pushl	%ebp
	movl	%esp, %ebp
  pusha

  mov 8(%ebp), %edx  

  # Szukanie pierwszego niezerowego bajtu(cyfry) dzielnika
  mov $4, %ecx
  findFirstNonZero:
    cmpb $0, -1(%edx, %ecx, 1)
    jne calcQ
  loop findFirstNonZero

  # Oblicz Q
  calcQ:
    lea -1(%edx, %ecx, 1), %eax
    push %eax
    push $Q
    call simple_div_byte_32

  # Przesuń w prawo o 8*(ecx-1)
  dec %ecx
  cmp $0, %ecx
  je doNotShift
  shiftBytewise:
    movb Q+1, %al
    movb %al, Q
    movb Q+2, %al
    movb %al, Q+1
    movb Q+3, %al
    movb %al, Q+2

    cmpb $0, Q+3 
    jl negative2
      movb $0, Q+3
    jmp endsign2
    negative2:
      movb $0xff, Q+3
    endsign2:

    loop shiftBytewise
  doNotShift:
  popa
	movl %ebp, %esp
	popl %ebp
  ret $4