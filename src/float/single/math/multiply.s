.section .text
.globl multiply

# Mantysa ma (razem z niejawną 1) 24 bity = 3 bajty
# W mnożeniu długość liczby się podwoi (nie licząc liczb nieznormalizowanych),
# więc trzeba zapisać najbardziej znaczące bity i odjąć przesunięcie (24 bity)
# od końcowego wykładnika.
multiply:
	pushl	%ebp
	pushl	%edi
	movl	%esp, %ebp

	subl	$0xc, %esp		# 3*int (3*4 bajty)

# | float b			| 0x14(%ebp)
# | float a			| 0x10(%ebp)
# | float* wynik	|  0xc(%ebp)
# | ret addr		|  0x8(%ebp)
# | kopia EBP		|  0x4(%ebp)
# | kopia EDI		|  0x0(%ebp)
# | C				| -0x4(%ebp)
# | D				| -0x8(%ebp)
# | E				| -0xc(%ebp)


# Wykładnik: E = Ea + Eb - 24
# Ea
	movb	0x12(%ebp), %dl
	shlb	$1, %dl		# MSB bajtu = LSB wykładnika, trafi do CF
	movb	0x13(%ebp), %dl
	rclb	$1, %dl
# Eb
	movb	0x16(%ebp), %cl
	shlb	$1, %cl		# MSB bajtu = LSB wykładnika, trafi do CF
	movb	0x17(%ebp), %cl
	rclb	$1, %cl
# E
# Bias powinien zostać odjęty z obu i dodany do wyniku. Wystarczy odjąć raz
# -1 bo jawne jedynki są częścią całkowitą mantysy
	subb	$127-1, %dl	# potencjalny underflow	-> subnormal jeśli w kolejnej
						# linijce nie będzie overflow
	addb	%cl, %dl	# potencjalny overflow -> inf

# Mnożenie mantys
# X = a * b
#
#              a2 a1 a0
#            * b2 b1 b0
#----------------------
#           Cc C2 C1 c0		# duże litery to iloczyn + przeniesienie
#        Dc D2 D1 d0
#   + Ec E2 E1 e0
#----------------------
#     X2 X1 X0 x1 x2 x3		# X trafi do wyniku, x liczone do przeniesienia

# c0
	movb	0x10(%ebp), %al
	movb	0x14(%ebp), %cl
	mulb	%cl
	movb	%al, -0x4(%ebp)
	movb	%ah, %ch		# przeniesienie c0 -> C1
# C1
	movb	0x11(%ebp), %al
	mulb	%cl
	addb	%ch, %al		# przeniesienie c0 -> C1
	movb	%al, -0x3(%ebp)
	movb	%ah, %ch		# przeniesienie C1 -> C2
# C2
	movb	0x12(%ebp), %al
	orb		$0x80, %al		# niejawna jedynka
	mulb	%cl
	addb	%ch, %al		# przeniesienie C1 -> C2
	movb	%al, -0x2(%ebp)
# Cc
	movb	%ah, -0x1(%ebp)

# d0
	movb	0x10(%ebp), %al
	movb	0x15(%ebp), %cl
	mulb	%cl
	movb	%al, -0x8(%ebp)
	movb	%ah, %ch
# D1
	movb	0x11(%ebp), %al
	mulb	%cl
	addb	%ch, %al
	movb	%al, -0x7(%ebp)
	movb	%ah, %ch
# D2
	movb	0x12(%ebp), %al
	orb		$0x80, %al
	mulb	%cl
	addb	%ch, %al
	movb	%al, -0x6(%ebp)
# Dc
	movb	%ah, -0x5(%ebp)

# e0
	movb	0x10(%ebp), %al
	movb	0x16(%ebp), %cl
	orb		$0x80, %cl
	mulb	%cl
	movb	%al, -0xc(%ebp)
	movb	%ah, %ch
# E1
	movb	0x11(%ebp), %al
	mulb	%cl
	addb	%ch, %al
	movb	%al, -0xb(%ebp)
	movb	%ah, %ch
# E2
	movb	0x12(%ebp), %al
	orb		$0x80, %al
	mulb	%cl
	addb	%ch, %al
	movb	%al, -0xa(%ebp)
# Ec
	movb	%ah, -0x9(%ebp)

# D = D + (C >> 8)
	movb	-0x3(%ebp), %al
	addb	%al, -0x8(%ebp)
	movb	-0x2(%ebp), %al
	adcb	%al, -0x7(%ebp)
	movb	-0x1(%ebp), %al
	adcb	%al, -0x6(%ebp)
	adcb	$0, -0x5(%ebp)
# X = E + (D >> 8)
	movb	-0x7(%ebp), %al
	addb	%al, -0xc(%ebp)
	movb	-0x6(%ebp), %al
	adcb	%al, -0xb(%ebp)
	movb	-0x5(%ebp), %al
	adcb	%al, -0xa(%ebp)
	adcb	$0, -0x9(%ebp)

# X = ah, al, ch, cl
# Dobre miejsce na zaokrąglanie
	movb	-0x9(%ebp), %ah
	movb	-0xa(%ebp), %al
	movb	-0xb(%ebp), %ch
	movb	-0xc(%ebp), %cl
# Ze względu na ujawnione 1 w wyniku 1 będzie na MSB albo MSB-1
	shlb	$1, %ah		# test MSB i zrobienie miejsca na wykładnik
	jc		2f
# Nie ma na MSB, trzeba przesunąć całą liczbę i zmniejszyć wykładnik
1:
	shrb	$1, %ah
	shlb	$1, %cl
	rclb	$1, %ch
	rclb	$1, %al
	rclb	$1, %ah
	subb	$1, %dl
	shlb	$1, %ah
	jnc		1b

2:
# S = Sa ^ Sb
	movb	0x13(%ebp), %dh
	xorb	0x17(%ebp), %dh

	shlb	$1, %dh
	rcrb	$1, %dl
	rcrb	$1, %ah
# wynik = dl, ah, al, ch
	movl	0xc(%ebp), %edi
	movb	%dl, 0x3(%edi)
	movb	%ah, 0x2(%edi)
	movb	%al, 0x1(%edi)
	movb	%ch, 0x0(%edi)

	movl	%ebp, %esp
	popl	%edi
	popl	%ebp
	ret

