.include "graphics.inc"
.data
#Screen 
screenWidth: 	.word 36
screenHeight: 	.word 36
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
	li $t0, 100
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

.globl main
main:
	# CHAMA DRAW GRID
	li $a0, GRID_ROWS
        li $a1, GRID_COLS
        la $a2, grid_easy
        jal draw_grid  

DrawRightLoop:
	#check for collision before moving to next pixel
	lw $a0, snakeHeadX
	lw $a1, snakeHeadY
	lw $a2, direction	
	#draw head in new position, move X position right
	lw $t0, snakeHeadX
	lw $t1, snakeHeadY
	addiu $t0, $t0, 1
	add $a0, $t0, $zero
	add $a1, $t1, $zero
	lw $v0, screenWidth 	#Store screen width into $v0
	mul $v0, $v0, $a1	#multiply by y position
	add $v0, $v0, $a0	#add the x position
	mul $v0, $v0, 4		#multiply by 4
	add $v0, $v0, 0x1004000	#add heap pointer from bitmap display
	add $a0, $v0, $zero
	
	
	sw  $t0, snakeHeadX
	j UpdateTailPosition #head updated, update tail

######################################################
# Update Snake Tail Position
######################################################

UpdateTailPosition:
	lw $t2, tailDirection	
    	beq  $t2, 100, MoveTailRight

MoveTailRight:
	#get the screen coordinates of the next direction change
	lw $t8, locationInArray
	#get the base address of the coordinate array
	la $t0, directionChangeAddressArray
	#go to the correct index of array
	add $t0, $t0, $t8
	#get the data from the array
	lw $t9, 0($t0)
	#get current tail position
	lw $a0, snakeTailX
	lw $a1, snakeTailY
	#if the length needs to be increased
	#do not change coordinates
	beq $s1, 1, IncreaseLengthRight
	#change tail position
	addiu $a0, $a0, 1
	#store new tail position
	sw $a0, snakeTailX
    	
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

	add	$s0, $a0, $zero		# x = a0 + 0 -> a0 = posi��o x passada para a fun��o
	addi	$s1, $s0, 7		# x_max = x + 7		cada bloco � composto por 7 pixels
	add	$s2, $a1, $zero		# y = a1 + 0 -> a0 = posi��o y passada para a fun��o
	addi	$s3, $s2, 7		# y_max = y + 7		cada bloco � composto por 7 pixels
	
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
	addi	$sp, $sp, 40				#apaga a pilha ao mover o pointer para a posi��o acima da sua origem

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
.globl mostra_cor:
mostra_cor:
	
	sll	$t0, $a0, 2	#byte da cor *4 transforma inteiro
	la	$t1, colors	#t1 = &colors
	add	$t2, $t0, $t1	# t2 = endere�o base de colors mais o valor do da cor desejada
	lw	$v0, ($t2)
	jr	$ra

# animated sprite (int id, char x, char y, char mov_x, char mov_y)
.globl animated_sprite
animated_sprite:
	
	
	