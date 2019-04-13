.text
.globl half_abs
half_abs:
# Rejestry EBP, EBX, ESI i EDI muszą zostać zachowane jeśli są używane
	pushl	%ebp
	pushl	%edi
# Po zapisaniu wszystkich używanych rejestrów kopiuje się ESP do EBP, względem
# którego liczone są adresy argumentów (EBP nie zmienia się, ESP może)
	movl	%esp, %ebp

# Przykład rezerwowania pamięci na zmienne lokalne - tutaj nieużywane
	subl	$0x8, %esp		# 2*int (2*4 bajty)

# W tym momencie stos wygląda tak:
# | float arg (LE)	|
# | float* wynik	|
# | ret addr		|
# | kopia EBP		|
# | kopia EDI		| <- EBP pokazuje tutaj
# | lokalna_1		|
# | lokalna_2		| <- ESP pokazuje tutaj

# Wyciągamy adres wyniku ze stosu do EDI
	movl	0xc(%ebp), %edi

# Kopiujemy 3 młodsze bajty bez zmieniania ich
	movb	0x10(%ebp), %al
	movb	%al, 0x0(%edi)
	movb	0x11(%ebp), %al
	movb	%al, 0x1(%edi)
	movb	0x12(%ebp), %al
	movb	%al, 0x2(%edi)

# W najstarszym bajcie jest znak, czyścimy go jeśli jest ustawiony
	movb	0x13(%ebp), %al
	andb	$0x7f, %al		# sign = 0, reszta jak była
	movb	%al, 0x3(%edi)

# Sprzątanie - zwykle coś nowego znajdzie się na stosie, żeby się tego pozbyć
# przywracamy kopię zapisaną w EBP, nie musimy liczyć ile trzeba dodać
	movl	%ebp, %esp

# Pamiętamy o przywróceniu kopii rejestrów w odwrotnej kolejności niż były
# zapisywane na stosie
	popl	%edi
	popl	%ebp

# Wynik jest zwracany w EAX (int) lub ST0 (float/double), żaden z nich nie ma
# 8 bitów więc musiał zostać użyty wskaźnik do przekazania całego wyniku
	ret
