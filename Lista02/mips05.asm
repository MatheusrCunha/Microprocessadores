#Faça um laço que seja executado 10 vezes.

.text

	li $t0, 0
loop:
	addi $t0, $t0, 1  #i = i + 1
	blt $t0, 9, loop

