.bss 
  result: .space 8
.text
.globl simple_mul
# A - liczba 8b w rejestrach %ah, %al, %bh, %bl
# B - liczba 8b w rejestrach %ch, %cl, %dh, %dl
# Wynik A:B
simple_mul:
  