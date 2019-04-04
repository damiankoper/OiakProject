.text
.globl simple_sub
# A - liczba 8b w rejestrach %ah, %al, %bh, %bl
# B - liczba 8b w rejestrach %ch, %cl, %dh, %dl
# Wynik tam gdzie A
simple_sub:
  subb %dl, %bl
  sbbb %dh, %bh
  sbbb %cl, %al
  sbbb %ch, %ah