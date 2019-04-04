.text
.globl simple_add
# A - liczba 8b w rejestrach %ah, %al, %bh, %bl
# B - liczba 8b w rejestrach %ch, %cl, %dh, %dl
# Wynik tam gdzie A
simple_add:
  addb %dl, %bl
  adcb %dh, %bh
  adcb %cl, %al
  adcb %ch, %ah