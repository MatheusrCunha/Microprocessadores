.include "graphics.inc"

#Snake Information
snakeHeadX: 	.word 5
snakeHeadY:	.word 3
snakeTailX:	.word 4
snakeTailY:	.word 3
direction:	.word 97 #initially moving up
tailDirection:	.word 97
# direction variable
# 119 - moving up - W
# 115 - moving down - S
# 97 - moving left - A
# 100 - moving right - D
# numbers are selected due to ASCII characters

#this array stores the screen coordinates of a direction change
#once the tail hits a position in this array, its direction is changed
#this is used to have the tail follow the head correctly
directionChangeAddressArray:	.word 0:100
#this stores the new direction for the tail to move once it hits
#an address in the above array
newDirectionChangeArray:	.word 0:100
#stores the position of the end of the array (multiple of 4)
arrayPosition:			.word 0
locationInArray:		.word 0

.text  
.globl main
main:
	# CHAMA DRAW GRID
	li $a0, GRID_ROWS
	li $a1, GRID_COLS
	la $a2, grid_hard
	jal draw_grid
	
	li $s1, 5 
	
aaa:
	bge $s1, 35, fim
	li $a0, 26
	lw $a1, snakeHeadX
	lw $a2, snakeHeadY
	li $a3, 1
	li $s0, 0
	jal animated_sprite
	
	add $a1, $a1, $a3
	add $a2, $a2, $s0
	
	sw $a1, snakeHeadX
	sw $a2, snakeHeadY
	
	
	li $a0, 25
	lw $a1, snakeTailX
	lw $a2, snakeTailY
	li $a3, 1
	li $s0, 0
	jal animated_sprite
	
	add $a1, $a1, $a3
	add $a2, $a2, $s0
	
	sw $a1, snakeTailX
	sw $a2, snakeTailY
	
	add $s1, $s1, 1
	
	j aaa
fim:
	li $v0, 10
	syscall
	
	
	    
######################################################
# Initialize Variables
######################################################
Init:

	li $t0, 5
	sw $t0, snakeHeadX
	li $t0, 4
	sw $t0, snakeTailX
	li $t0, 3
	sw $t0, snakeTailY
	sw $t0, snakeHeadY
	li $t0, 97
	sw $t0, direction
	sw $t0, tailDirection
	sw $zero, arrayPosition
	sw $zero, locationInArray
	
ClearRegisters:

	li $v0, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
    
# draw_grid(width, height, grid_table)
.globl draw_grid
draw_grid:
	addi	$sp, $sp, -40
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	sw	$s2, 20($sp)
	sw	$s3, 24($sp)
	sw	$s4, 28($sp)
	sw	$ra, 32($sp)		#pilha inicializada
	
	add	$s1, $a0, $zero		# x_max = largura passada
	add	$s2, $zero, $zero	# y = 0
	add	$s3, $a1, $zero		# y_max = altura passada
	add	$s4, $a2, $zero		
	
d_for_y:
	bge	$s2, $s3 end_d_for_y
	li	$s0, 0			# x = 0
	
	d_for_x:
		lb	$t0, ($s4)
		addi	$a2, $t0, -64
		
		bge	$s0, $s1, end_d_for_x
		
		mul	$a0, $s0, X_SCALE
		mul	$a1, $s2, Y_SCALE
		jal	draw_sprite
		
		addi	$s0, $s0, 1
		addi	$s4, $s4, 1
		
		j	d_for_x
	
	end_d_for_x:
		addi	$s2, $s2, 1
		
		j	d_for_y

end_d_for_y:
	lw	$a0, ($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	lw	$s3, 24($sp)
	lw	$s4, 28($sp)
	lw	$ra, 32($sp)				
	addi	$sp, $sp, 40
	
	
	jr   $ra


# draw_sprite(X, Y, sprite_id)
.globl draw_sprite
draw_sprite:

	addi	$sp, $sp, -40
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	sw	$s2, 20($sp)
	sw	$s3, 24($sp)
	sw	$s4, 28($sp)
	sw	$ra, 32($sp)		#pilha inicializada

	add	$s0, $a0, $zero		# x = a0 + 0 -> a0 = posição x passada para a função
	addi	$s1, $s0, 7		# x_max = x + 7		cada bloco é composto por 7 pixels
	add	$s2, $a1, $zero		# y = a1 + 0 -> a0 = posição y passada para a função
	addi	$s3, $s2, 7		# y_max = y + 7		cada bloco é composto por 7 pixels
	
	la	$t0, sprites		# t0 = &sprite
	mul	$t1, $a2, SPRITE_SIZE	# t1 = sprite_id * tamanho maximo
	add	$s4, $t0, $t1		


#for (y = y0; y < (y0+7); y++)	
for_y:
	bge	$s2, $s3, end_for_y
	
	for_x:
		bge	$s0, $s1, end_for_x
		
		lb	$a0, ($s4)			#carrega em a0 o valor do byte i
		jal	mostra_cor
		
		add	$a0, $s0, $zero
		add	$a1, $s2, $zero
		add	$a2, $v0, $zero
		jal	set_pixel			#set_pixel(a0 = x, a1 = y, a2 = cor
		
		addi	$s0, $s0, 1
		addi	$s4, $s4, 1
		
		j	for_x
	
	end_for_x:
		add	$s0, $s0, -7			#x = x0
		add	$s2, $s2,  1			# y++ -> x retorna ao valor inicial e y aumenta
		
		j	for_y

end_for_y:
	lw	$a0, ($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	lw	$s3, 24($sp)
	lw	$s4, 28($sp)
	lw	$ra, 32($sp)				#carrega o valor armazenado na pilha para os registradores
	addi	$sp, $sp, 40				#apaga a pilha ao mover o pointer para a posição acima da sua origem

    	jr   $ra

# set_pixel(X, Y, color)
.globl set_pixel
set_pixel:
   la  $t0, FB_PTR
   mul $a1, $a1, FB_XRES
   add $a0, $a0, $a1
   sll $a0, $a0, 2
   add $a0, $a0, $t0
   sw  $a2, 0($a0)
   jr  $ra
   
# mostra_cor(byte cor)
# a0 = byte cor
.globl mostra_cor
mostra_cor:
	
	sll	$t0, $a0, 2	#byte da cor *4 transforma inteiro
	la	$t1, colors	#t1 = &colors
	add	$t2, $t0, $t1	# t2 = endereço base de colors mais o valor do da cor desejada
	lw	$v0, ($t2)
	jr	$ra


0
#animated_sprite(id, x, y, mov_x, mov_y)	
.globl animated_sprite
animated_sprite:

	addi	$sp, $sp, -32
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$s0, 12($sp)
	sw	$s1, 16($sp)
	sw	$s2, 20($sp)
	sw	$s3, 24($sp)
	sw	$ra, 28($sp)
	
	move $s1, $a2
	move $a2, $a0
	move $a0, $a1
	move $a1, $s1
	
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	
	mul $a0, $a0, 7
	mul $a1, $a1, 7
	
	li $s2, 0
	li $s3, 7
	
loop_animated:	

	bge $s2, $s3, fim_animated
	
	add $a0, $a0, $a3
	add $a1, $a1, $s0
	
	jal draw_sprite
	
	addi $s2, $s2, 1
	
	j loop_animated
	
fim_animated:
	
	lw	$a0, ($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$s0, 12($sp)
	lw	$s1, 16($sp)
	lw	$s2, 20($sp)
	lw	$s3, 24($sp)
	lw	$ra, 28($sp)
	addi	$sp, $sp, 32
	
	jr $ra
	
