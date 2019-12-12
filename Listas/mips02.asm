
#Faça um programa para testar se o conteúdo das posições 0x00 e 0x04 são iguais e, em caso positivo,
#armazene o valor na posição 0x08.

.text
	lw $t0, 0($gp)
	lw $t1, 4($gp)
	bne $t0, $t1, end
	sw $t0, 8($gp)
end:

	