.include "graphics.inc"

#Snake Information
snakeHeadX: 	.word 4
snakeHeadY:	.word 2
snakeTailX:	.word 3
snakeTailY:	.word 2
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
	jal enableKeyboardInterrupt	# void enableKeyboardInterrupt()
	
	li $s1, 5 
	
aaa:
	bge $s1, 35, fim
	li $a0, 26
	lw $a1, snakeHeadX
	lw $a2, snakeHeadY
	li $a3, 0
	li $s0, 1
	jal animated_sprite
	
	add $a1, $a1, $a3
	add $a2, $a2, $s0
	
	sw $a1, snakeHeadX
	sw $a2, snakeHeadY
	
	
	li $a0, 25
	lw $a1, snakeTailX
	lw $a2, snakeTailY
	li $a3, 0
	li $s0, 1
	jal animated_sprite
	
	add $a1, $a1, $a3
	add $a2, $a2, $s0
	
	sw $a1, snakeTailX
	sw $a2, snakeTailY
	
	add $s1, $s1, 1
	
	li $a0, 250
	li $v0, 32
	syscall
	
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


#animated_sprite(id, x, y, mov_x, mov_y)	
.globl animated_sprite
animated_sprite:

	addi	$sp, $sp, -36
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	sw	$s0, 16($sp)
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)
	sw	$ra, 32($sp)
	
	move $s1, $a2
	move $a2, $a0
	move $a0, $a1
	move $a1, $s1
	
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
	lw	$a3, 12($sp)
	lw	$s0, 16($sp)
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	
	jr $ra
	
############################################################################################################# 	
enableKeyboardInterrupt:  	  	  	
.ktext 0x80000180  

#Create Interuptions Stack 
  	move $k0, $at      # $k0 = $at 
  	la   $k1, kernelRegisters    
  	sw   $k0, 0($k1)   
  	sw   $v0, 4($k1)
  	sw   $v1, 8($k1)
  	sw   $a0, 16($k1)
  	sw   $a1, 20($k1)
 	sw   $a2, 24($k1)
  	sw   $a3, 28($k1)
 	#sw   $t0, 32($k1)
	#sw   $t1, 36($k1) 
	#sw   $t2, 40($k1)
	#sw   $t3, 44($k1)
	#sw   $t4, 48($k1)
  	#sw   $t5, 52($k1)
	#sw   $t6, 56($k1)
	#sw   $t7, 60($k1)
	#sw   $s0, 64($k1)
	#sw   $s1, 68($k1)
	#sw   $s2, 72($k1)
	#sw   $s3, 76($k1) 
	#sw   $s4, 80($k1)
	#sw   $s5, 84($k1)
	#sw   $s6, 88($k1)
	#sw   $s7, 92($k1)
	#sw   $t8, 96($k1)
	#sw   $t9, 100($k1)
	sw   $gp, 104($k1)
	sw   $sp, 108($k1)
	sw   $fp, 112($k1)
	sw   $ra, 116($k1)
	mfhi $k0
  	sw   $k0, 120($k1)
  	mflo $k0
  	sw	$k0, 124($k1)
	
	mfc0	$s0, $13
	andi	$s0, 0xFC
	srl	$s0, $s0, 2

  	la 	$s1, jtable	#load andress of vector
  	add 	$s1, $s1, $s0 	# jtable adress
  	lw	$s1, 0($s1)	# Carrego valor do elemento em $a1
  	jr 	$s1
  
case0:

	la  	$s0, kbBuffer	# Load Sprite adress , Sprite Name
	lw 	$s1, 0($s0) 	# Load kbBuffer.isValid
 	lw 	$s2, 4($s0)	# Load kbBuffer.x
 	lw 	$s3, 8($s0)	# Load kbBuffer.y
	lw 	$s4, 12($s0)	# Load kbBuffer.isPaused
	
	la 	$s7, 0xffff0004  	# Load keyboard info on $s1 to the right address
	lw 	$s7, ($s7)		# Load keyboard data from 0xffff0004
	
	beq 	$s7,100, hwInterruptGoRight	# Key d, go Right
	beq 	$s7, 68, hwInterruptGoRight	# Key D, go Right
	beq 	$s7, 97, hwInterruptGoLeft	# Key a, go Left
	beq 	$s7, 65, hwInterruptGoLeft	# Key A, go Left
	beq 	$s7,119, hwInterruptGoUp	# Key w, go Up
	beq 	$s7, 87, hwInterruptGoUp	# Key W, go Up
	beq 	$s7,115, hwInterruptGoDown	# Key s, go Down
	beq 	$s7, 83, hwInterruptGoDown	# Key S, go Down
	beq 	$s7, 32, hwInterruptPause	# Key Space, Pause game
	beq 	$s7, 10, hwInterruptEnter	# Key Enter, Restart game if paused
	b   	interruptEnd
    
hwInterruptGoRight:

	li  	$s2, 1	#x
	li  	$s3, 0	#y
	li  	$s4, 0	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptGoLeft:

	li  	$s2, -1	#x
	li  	$s3, 0	#y
	li  	$s4, 0	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptPause:
	
	beq $s4, 0, hwInterruptPauseIsZero
	beq $s4, 1, hwInterruptPauseIsOne
	
hwInterruptPauseIsZero:
	li  	$s4, 1	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptPauseIsOne:	
	li  	$s4, 0	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptEnter:

	beq 	$s4, 0, hwInterruptEnd	
	
	add	$s1, $zero, $zero	# s1 = 0;
 	sw 	$s1, 0($s0) 	# kbBuffer.isValid = 0;
 	sw 	$s1, 4($s0)	# kbBuffer.x = 0;
 	sw 	$s1, 8($s0)	# kbBuffer.y = 0;
	sw 	$s1, 12($s0)	# kbBuffer.isPaused = 0;
	
	la	$k0, startGame
	mtc0	$k0, $14      # EPC = point to next instruction 
	eret

hwInterruptGoUp:

	li  	$s2, 0	#x
	li  	$s3, -1	#y
	li  	$s4, 0	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptGoDown:
	li  	$s2, 0	#x
	li  	$s3, 1	#y
	li  	$s4, 0	#isPaused
 	b 	hwInterruptEnd
 	
hwInterruptEnd:

 	addi	$s1, $zero, 1	# s1 = 1;
 	sw 	$s1, 0($s0) 	# kbBuffer.isValid = 1;
 	sw 	$s2, 4($s0)	# kbBuffer.x = s2;
 	sw 	$s3, 8($s0)	# kbBuffer.y = s3;
	sw 	$s4, 12($s0)	# kbBuffer.isPaused = s4;
 	
	b   	interruptEnd
	
interruptEnd:
#Restore Interuptions Stack 
	la    	$k1, kernelRegisters
	lw    	$k0, 0($k1)
	lw    	$v0, 4($k1)
	lw    	$v1, 8($k1)
	lw    	$a0, 16($k1)
	lw    	$a1, 20($k1)
	lw    	$a2, 24($k1)
	lw    	$a3, 28($k1)
	#lw    	$t0, 32($k1)
	#lw    	$t1, 36($k1) 
	#lw    	$t2, 40($k1)
	#lw    	$t3, 44($k1)
	#lw    	$t4, 48($k1)
	#lw    	$t5, 52($k1)
	#lw    	$t6, 56($k1)
	#lw    	$t7, 60($k1)
	#lw    	$s0, 64($k1)
	#lw    	$s1, 68($k1)
	#lw    	$s2, 72($k1)
	#lw    	$s3, 76($k1) 
	#lw    	$s4, 80($k1)
	#lw    	$s5, 84($k1)
	#lw    	$s6, 88($k1)
	#lw    	$s7, 92($k1)
	#lw    	$t8, 96($k1)
	#lw    	$t9, 100($k1)
	lw    	$gp, 104($k1)
	lw    	$sp, 108($k1)
	lw    	$fp, 112($k1)
	lw    	$ra, 116($k1)
	lw    	$k0, 120($k1)
	mthi  	$k0
	lw    	$k0, 124($k1)
	mtlo  	$k0
	#mfc0  	$k0, $14      # $k0 = EPC 
	#addiu 	$k0, $k0, 4   # Increment $k0 by 4 
	#mtc0  	$k0, $14      # EPC = point to next instruction 
	#eret
	
	# the default interruption return does not work with this project,
	# since the edited values cant be changed betwen pacman main funtions. 

	la	$k0, main
	mtc0	$k0, $14      # EPC = point to next instruction 
	eret
	
.kdata
jtable: .word case0

.align 2
# Excepion String Table
stringGenericEx: 	.asciiz "\n Exception Occurred: "
stringHWInterruptEx:	.asciiz "HW Interrupt\n"
stringHere: 	.asciiz "here!\n"
.align 2
kernelRegisters: .space    256
	
