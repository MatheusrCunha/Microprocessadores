.data
ler: .asciiz "Entre com os elementos da linha: "
ler2: .asciiz "Entre com os elementos da coluna: "

matriz1: .space 16
matriz2: .space 16
matriz3: .space 

linhas: .space
colunas: .space
espaco: .asciiz " "
pulalinha: .asciiz "\n"
size matriz: .space 25
.text
   main:

	la $a0, matriz1
	lw $a1, size matriz
	
	jal le_matriz
	move $a0, $v0
	

le_matriz:
	
	li $t0, 0
	li $t1, 9
	loop_add:
	
		addi $v0, $zero, 5
		syscall 
		
		li $v0, 4
		la $s0, ler
		syscall
	
		addiu $sp, $sp, -16
	
	jr $ra	

imprime_matriz:

	jr $ra
determinante:

	jr $ra
	
soma:

	jr $ra
oposta:

	jr $ra
	
transposta:

	jr $ra