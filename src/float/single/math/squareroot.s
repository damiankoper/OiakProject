.section .text
.globl squareroot

single_squareRoot:

	pushl	%ebp
	pushl	%edi
	movl	%esp, %ebp

	subl 	$0xe, %esp

# | float a			|  0x10(%ebp)
# | float *wynik    |  0xc(%ebp) 
# | ret addr		|  0x8(%ebp)
# | kopia EBP		|  0x4(%ebp)
# | kopia EDI		|  0x0(%ebp)
# | Liczba			| -0x4(%ebp)
# | Qi  			| -0x8(%ebp)
# | Ri              | -0xc(%ebp)
# | licznik_q       | -0xd(%ebp)
# | licznik_r       | -0xe(%ebp)

# Sprawdzam czy liczba jest dodatnia
    movb 0x13(%ebp), %al # d
    movb 0x12(%ebp), %cl # c
    shlb $1, %cl
    rclb $1, %al
    jc UNDOABLE

# Sprawdzam czy wykładnik jest parzysty

    subb $127, %al
    movb %al, %cl
    shrb $1, %cl
    jc ODD
    jmp EVEN

UNDOABLE:

    movl	%ebp, %esp
	popl	%edi
	popl	%ebp
	ret

ODD:

subb $1, %al
shrb $1, %al
addb $127, %al

movb %al, -0x1(%ebp)

# wykładnik gotowy
# Przesunięcie mantysy w lewo żeby pozbyć się najstarszego bitu, który jest częścią wykładnika
movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp)

jmp FIRST_CASE

EVEN:

shrb $1, %al
addb $127, %al

movb %al, -0x1(%ebp)

# wykładnik gotowy
# Przesunięcie mantysy w lewo żeby pozbyć się najstarszego bitu, który jest częścią wykładnika
movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp)

jmp SECOND_CASE

FIRST_CASE:

movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %al # a

shrb $1, %al
rcrb $1, %dl
rcrb $1, %cl

movb $1, %al
rclb $1, %al

# W al są teraz dwie pierwsze cyfry mantysy, te przed przecinkiem. Dwie bo skalowaliśmy mantyse

# Tu zapisywany będzie aktualny wynik pierwiastkowania mantysy
movb $0, -0x8(%ebp)
movb $0, -0x7(%ebp)
movb $0, -0x6(%ebp)
movb $1, -0x5(%ebp)


subb $1, %al


# Tu zapisywana będzie aktualna reszta

movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl
rclb $1, %al

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl
rclb $1, %al

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp)


movb $0, -0xc(%ebp)
movb $0, -0xb(%ebp)
movb $0, -0xa(%ebp)
movb %al, -0x9(%ebp)


xor %dh, %dh
jmp HARD

SECOND_CASE:

# Tu zapisywany będzie aktualny wynik pierwiastkowania mantysy
movb $0, -0x8(%ebp)
movb $0, -0x7(%ebp)
movb $0, -0x6(%ebp)
movb $1, -0x5(%ebp)

xor %al, %al

movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl
rclb $1, %al

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl
rclb $1, %al

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp)

# Tu zapisywana będzie aktualna reszta
movb $0, -0xc(%ebp)
movb $0, -0xb(%ebp)
movb $0, -0xa(%ebp)
movb %al, -0x9(%ebp)

HARD:

cmpb $22, %dh
je HARD_EXIT

movb -0x8(%ebp), %al
movb -0x7(%ebp), %ah
movb -0x6(%ebp), %cl
movb -0x5(%ebp), %dl

shlb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

shlb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

addb $1, %dl
adcb $0, %cl
adcb $0, %ah
adcb $0, %al

# W rejestrach mam teraz (2 * Qi * 2 + 1)*1. Porównuje to z aktualną resztą

movb -0xc(%ebp), %ch
cmpb %ch, %al
jb X_1
cmpb %al, %ch
jb X_0

movb -0xb(%ebp), %al
cmpb %al, %ah
jb X_1
cmpb %ah, %al
jb X_0

movb -0xa(%ebp), %al
cmpb %al, %cl
jb X_1
cmpb %cl, %al
jb X_0

movb -0x9(%ebp), %al
cmpb %al, %dl
jb X_1
cmpb %dl, %al
jb X_0
jmp X_1

X_1:
movb $20, %al
addb $255, %al

movb -0x8(%ebp), %al
movb -0x7(%ebp), %ah
movb -0x6(%ebp), %cl
movb -0x5(%ebp), %dl

rclb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0x8(%ebp)
movb %ah, -0x7(%ebp)
movb %cl, -0x6(%ebp)
movb %dl, -0x5(%ebp)

shrb $1, %al
rcrb $1, %ah
rcrb $1, %cl
rcrb $1, %dl


shlb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

shlb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

addb $1, %dl
adcb $0, %cl
adcb $0, %ah
adcb $0, %al

movb -0x9(%ebp), %ch
subb %dl, %ch
movb %ch, -0x9(%ebp)

movb -0xa(%ebp), %dl
sbbb %cl, %dl
movb %dl, -0xa(%ebp)

movb -0xb(%ebp), %dl
sbbb %ah, %dl
movb %dl, -0xb(%ebp)

movb -0xc(%ebp), %dl
sbbb %al, %dl
movb %dl, -0xc(%ebp)

# reszta odjęta i zapisana wyzej. Teraz dodaje kolejne dwie pozycje mantysy do reszty :(
# pierwsza pozycja
movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp) 

movb -0xc(%ebp), %al
movb -0xb(%ebp), %ah
movb -0xa(%ebp), %cl
movb -0x9(%ebp), %dl

rclb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0xc(%ebp)
movb %ah, -0xb(%ebp)
movb %cl, -0xa(%ebp)
movb %dl, -0x9(%ebp)

# druga
movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp) 

movb -0xc(%ebp), %al
movb -0xb(%ebp), %ah
movb -0xa(%ebp), %cl
movb -0x9(%ebp), %dl

rclb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0xc(%ebp)
movb %ah, -0xb(%ebp)
movb %cl, -0xa(%ebp)
movb %dl, -0x9(%ebp)


addb $1, %dh
jmp HARD

X_0:
# Przesuwam dodając 0. Od reszty nie musze nic odejmować, więc później dodaje do niej po 
# prostu kolejne dwie pozycje mantysy
movb -0x8(%ebp), %al
movb -0x7(%ebp), %ah
movb -0x6(%ebp), %cl
movb -0x5(%ebp), %dl

shlb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0x8(%ebp)
movb %ah, -0x7(%ebp)
movb %cl, -0x6(%ebp)
movb %dl, -0x5(%ebp)

# Teraz dodaje kolejne dwie pozycje mantysy do reszty :(
# pierwsza pozycja

movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp) 

movb -0xc(%ebp), %al
movb -0xb(%ebp), %ah
movb -0xa(%ebp), %cl
movb -0x9(%ebp), %dl

rclb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0xc(%ebp)
movb %ah, -0xb(%ebp)
movb %cl, -0xa(%ebp)
movb %dl, -0x9(%ebp)

# druga
movb 0x12(%ebp), %cl # c
movb 0x11(%ebp), %dl # b
movb 0x10(%ebp), %ch # a

shlb $1, %ch
rclb $1, %dl
rclb $1, %cl

movb %cl, 0x12(%ebp)
movb %dl, 0x11(%ebp)
movb %ch, 0x10(%ebp) 

movb -0xc(%ebp), %al
movb -0xb(%ebp), %ah
movb -0xa(%ebp), %cl
movb -0x9(%ebp), %dl

rclb $1, %dl
rclb $1, %cl
rclb $1, %ah
rclb $1, %al

movb %al, -0xc(%ebp)
movb %ah, -0xb(%ebp)
movb %cl, -0xa(%ebp)
movb %dl, -0x9(%ebp)

addb $1, %dh
jmp HARD

HARD_EXIT:

    movb -0x7(%ebp), %ah
    movb -0x6(%ebp), %cl
    movb -0x5(%ebp), %dl

SHIFTING:

    shlb $1, %dl
    rclb $1, %cl
    rclb $1, %ah

    jc SHIFTING_EXIT
    JMP SHIFTING    

SHIFTING_EXIT:

    movb -0x1(%ebp), %al

    shrb $1, %al
    rcrb $1, %ah
    rcrb $1, %cl
    rcrb $1, %dl

    movl	0xc(%ebp), %edi
	movb	%al, 0x3(%edi)
	movb	%ah, 0x2(%edi)
	movb	%cl, 0x1(%edi)
	movb	%dl, 0x0(%edi)

	movl	%ebp, %esp
	popl	%edi
	popl	%ebp
	ret