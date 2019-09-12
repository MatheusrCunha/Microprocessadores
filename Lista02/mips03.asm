#Faça um programa que leia o conteúdo das posições 0x00 e 0x04, e armazene o maior deles na
#posição 0x08.

.text 
	li $t0, 0
	li $t1, 2
	#lw $t0, 0($gp)
	#lw $t1, 4($gp)
	
	bgt $t0, $t1, desvia
	sw $t1, 8($gp)
	j end
desvia:
	sw $t0, 8($gp)
end:    