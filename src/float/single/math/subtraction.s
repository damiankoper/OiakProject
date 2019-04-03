.text
.globl single_sub
single_sub:

	pushl	%ebp
	pushl	%edi
	movl	%esp, %ebp

	subl 	$0x5, %esp

# | float a			|  0x14(%ebp)
# | float b			|  0x10(%ebp)
# | float *wynik    |  0xc(%ebp) 
# | ret addr		|  0x8(%ebp)
# | kopia EBP		|  0x4(%ebp)
# | kopia EDI		|  0x0(%ebp)
# | A				| -0x4(%ebp)
# | Znak  			| -0x5(%ebp)

# Wyrównanie wykładników	

# Wykładnik 1

	xor %eax, %eax

	movb 0x13(%ebp), %al # d
	movb 0x12(%ebp), %dl # c

	shlb $1, %dl
	rclb $1, %al

# al - wykładnik 1

	movb 0x17(%ebp), %cl # d
	movb 0x16(%ebp), %dl # c

	shlb $1, %dl
	rclb $1, %cl

# cl - wykładnik 2

# Wyrównanie wykładników
	xor %dh, %dh

	cmpb %al, %cl
	jb CHECK_SIGN_SECOND
	jmp CHECK_SIGN_FIRST

CHECK_SIGN_FIRST:

	movb 0x17(%ebp), %dl
	shlb $1, %dl
	jc UJEMNA_FIRST
	jmp FIRST_EXP

CHECK_SIGN_SECOND:

	movb 0x17(%ebp), %dl
	shlb $1, %dl
	jc UJEMNA_SECOND
	jmp SECOND_EXP

UJEMNA_FIRST:

	xor %dl, %dl
	movb $1, %dl
	movb %dl, -0x5(%ebp)
	jmp FIRST_EXP

UJEMNA_SECOND:

	xor %dl, %dl
	movb $1, %dl
	movb %dl, -0x5(%ebp)

SECOND_EXP:

	cmpb %al, %cl
	je SECOND_M

	addb $1, %cl
	addb $1, %dh
	jmp SECOND_EXP

FIRST_EXP:

	cmpb %al, %cl
	je FIRST_M

	addb $1, %al
	addb $1, %dh
	jmp FIRST_EXP

# w dh - potrzebna ilość przesunięć mantysy

FIRST_M:

# zapisanie wykładnika 

	movb %cl, -0x1(%ebp)

	movb 0x10(%ebp), %dl # a
	movb 0x11(%ebp), %cl # b
	movb 0x12(%ebp), %al # c

# przesunięcie w lewo dodające ukrytą jedynke
	rclb $1, %al
	cmpb $255, %ah
	rcrb $1, %al

# M - ccccccccbbbbbbbbaaaaaaa

	xor %ch, %ch	

	jmp SHIFTING_FIRST

SECOND_M:

	movb %cl, -0x1(%ebp)

	movb 0x14(%ebp), %dl # a
	movb 0x15(%ebp), %cl # b
	movb 0x16(%ebp), %al # c

# przesunięcie dodające ukrytą jedynke
	rclb $1, %al
	cmpb $255, %ah
	rcrb $1, %al

# M - ccccccccbbbbbbbbaaaaaaa

	xor %ch, %ch	

	jmp SHIFTING_SECOND

SHIFTING_FIRST:

	cmpb %ch, %dh
	je SHIFTING_FIRST_EXIT

	shrb $1, %al
	rcrb $1, %cl
	rcrb $1, %dl

	addb $1, %ch
	jmp SHIFTING_FIRST

SHIFTING_SECOND:

	cmpb %ch, %dh
	je SHIFTING_SECOND_EXIT

	shrb $1, %al
	rcrb $1, %cl
	rcrb $1, %dl

	addb $1, %ch
	jmp SHIFTING_SECOND

SHIFTING_FIRST_EXIT:	

	movb %al, -0x2(%ebp) # c
	movb %cl, -0x3(%ebp) # b
	movb %dl, -0x4(%ebp) # a

	movb 0x16(%ebp), %al # c2 
	movb 0x15(%ebp), %cl # b2
	movb 0x14(%ebp), %dl # a2		

# przesunięcie dodające ukrytą jedynke
	rclb $1, %al
	cmpb $255, %ah
	rcrb $1, %al

	jmp CHECK_SIGN_BEFORE_ADDING

SHIFTING_SECOND_EXIT:	

	movb %al, -0x2(%ebp) # c
	movb %cl, -0x3(%ebp) # b
	movb %dl, -0x4(%ebp) # a

	movb 0x12(%ebp), %al # c2 
	movb 0x11(%ebp), %cl # b2
	movb 0x10(%ebp), %dl # a2		

	# przesunięcie dodające ukrytą jedynke
	shlb $1, %al
	cmpb $255, %ah
	rcrb $1, %al

	jmp CHECK_SIGN_BEFORE_ADDING

CHECK_SIGN_BEFORE_ADDING:

	movb 0x13(%ebp), %dh
	movb 0x17(%ebp), %ah
	shlb $1, %dh
	movb $0, %dh
	adcb $0, %dh
	shlb $1, %ah
	movb $0, %ah
	adcb $0, %ah

	cmp %ah, %dh
	je OTHER_ADDING
	jmp ADDING


OTHER_ADDING:

	movb -0x4(%ebp), %ch
	subb %ch,%dl
	movb %dl, -0x4(%ebp)
	movb -0x3(%ebp), %dl
	sbbb %dl,%cl
	movb %cl, -0x3(%ebp)
	movb -0x2(%ebp), %cl
	sbbb %cl, %al
	movb %al, -0x2(%ebp)

	movb $0, %dh
	movb $0, %ch

	movb -0x1(%ebp), %al # d
	movb -0x2(%ebp), %ah # c
	movb -0x3(%ebp), %cl # b
	movb -0x4(%ebp), %dl # a
M:

	shlb $1, %dl
	rclb $1, %cl
	rclb $1, %ah
	jc EXP
	addb $1, %dh
	jmp M

EXP:

	cmpb %ch, %dh
	je EXP_EXIT
	subb $1, %al
	addb $1, %ch
	jmp EXP

EXP_EXIT:

	movb %al, -0x1(%ebp)
	movb %ah, -0x2(%ebp)
	movb %cl, -0x3(%ebp)
	movb %dl, -0x4(%ebp)

	jmp ADDING_THE_SIGN

ADDING:

	movb -0x4(%ebp), %ch
	addb %ch,%dl
	movb %dl, -0x4(%ebp)
	movb -0x3(%ebp), %dl
	adcb %dl,%cl
	movb %cl, -0x3(%ebp)
	movb -0x2(%ebp), %cl
	adcb %cl, %al
	movb %al, -0x2(%ebp)

	jc SHIFT_EXP
	jmp HIDING_THE_ONE


SHIFT_EXP:

	movb -0x1(%ebp), %al
	add $1, %al
	movb %al, -0x1(%ebp)
	
	movb -0x2(%ebp), %ah # c
	movb -0x3(%ebp), %cl # b
	movb -0x4(%ebp), %dl # a 

	shrb $1, %al
	rcrb $1, %ah
	rcrb $1, %cl
	rcrb $1, %dl

# Sprawdzenie czy będzie ujemna czy dodatnia, jak ujemna to zmieniam znak

	movb -0x5(%ebp), %dh
	cmp $1, %dh
	je CHANGE_SIGN
	jmp RESULT

HIDING_THE_ONE:

	movb -0x1(%ebp), %al # exponent
	movb -0x2(%ebp), %ah # c
	movb -0x3(%ebp), %cl # b
	movb -0x4(%ebp), %dl # a 

	shlb $1, %dl
	rclb $1, %cl
	shlb $1, %ah

ADDING_THE_SIGN:

	shrb $1, %al
	rcrb $1, %ah
	rcrb $1, %cl
	rcrb $1, %dl

	movb -0x5(%ebp), %dh
	cmp $1, %dh
	je CHANGE_SIGN
	jmp RESULT

CHANGE_SIGN:

	addb $128, %al

RESULT:

	movl	0xc(%ebp), %edi
	movb	%al, 0x3(%edi)
	movb	%ah, 0x2(%edi)
	movb	%cl, 0x1(%edi)
	movb	%dl, 0x0(%edi)

	movl	%ebp, %esp
	popl	%edi
	popl	%ebp
	ret 