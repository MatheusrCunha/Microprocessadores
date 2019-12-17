.include "graphics.asm"
.include "Macros.asm"
.include "control.asm"

mainLoopCount:
.word 0

.text
startGame:	
	la 	$a0, snake	# a0 = &snake
	li	$s0, 28
	sw	$s0, 4($a0)
	li	$s0, 14
	sw	$s0, 8($a0)
	li	$s0, 0
	sw	$s0, 12($a0)
	li	$s0, 0
	sw	$s0, 16($a0)
	
	la 	$a0, kbBuffer
	li	$s0, 0
	sw 	$s0, 0($a0)
	sw	$s0, 4($a0)
	sw	$s0, 8($a0)
	sw	$s0, 12($a0)
	
	sw	$s0, mainLoopCount
	
	jal 	drawGridHardCoded   		# void drawGridLinear(void)
	jal 	enableKeyboardInterrupt		# void enableKeyboardInterrupt()

	#b main
	
######################################################################################################   

main:	
	la 	$a0, snake	# a0 = &snake
	la	$a1, kbBuffer	
	jal	moveSprite
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	
	DelayMs(50)
   	j 	main			# goto main
 
######################################################################################################

######################################################################################################
.globl moveSprite
moveSprite:
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)
	sw 	$s5, 36($sp)
	sw 	$s6, 40($sp)
	sw 	$s7, 44($sp)
	
	move	$s0, $a1	# s0 = &kbBuffer	

	lw 	$s1, 4($a0)	# sprite.posX
	lw 	$s2, 8($a0)	# sprite.posY 
 	lw 	$s3, 12($a0)	# sprite.movX 
	lw 	$s4, 16($a0)	# sprite.movY 
	lw 	$s5, 0($s0)	# kbBuffer.isValid
	lw 	$s6, 4($s0)	# kbBuffer.X
	lw 	$s7, 8($s0)	# kbBuffer.Y
	
moveSpriteKbBufferIsValidCheck:	
	beq	$s5, $zero, moveSpriteKbBufferIsNotValid	# (kbBuffer.isValid == 0) ? kbBufferIsNotValid
	move	$a1, $s6 				# a1 = kbBuffer.X
	move 	$a2, $s7				# a2 = kbBuffer.Y
	add 	$s3, $zero, $s6				# sprite.movX = kbBuffer.X;
	add 	$s4, $zero, $s7				# sprite.movY = kbBuffer.Y;
	add	$s5, $zero, $zero			# kbBuffer.isValid = 0;
	b	moveSpriteDoTheThing			# if input data is valid

moveSpriteKbBufferIsNotValid:	
					# a0 = &sprite
	move	$a1, $s3		# a1 = sprite.movX
	move 	$a2, $s4		# a2 = sprite.movY

moveSpriteDoTheThing:
	add 	$s1, $s1, $s3		# sprite.posX += sprite.movX
	add 	$s2, $s2, $s4		# sprite.posY += sprite.movY
	b 	moveSpriteEnd
	
moveSpriteStopIt:		
	add	$s3, $zero, $zero	# sprite.movX = 0;
	add	$s4, $zero, $zero	# sprite.movY = 0;
	
moveSpriteEnd:

	sw 	$s1, 4($a0)	# save sprite.posX
	sw 	$s2, 8($a0)	# save sprite.posY
	sw 	$s3, 12($a0)	# save sprite.movX
	sw 	$s4, 16($a0)	# save sprite.movY
	sw 	$s5, 0($s0)	# save kbBuffer.isValid

	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	lw 	$s5, 36($sp)
	lw 	$s6, 40($sp)
	lw 	$s7, 44($sp)
	addi	$sp, $sp, 64		
    	jr  	$ra		# return
	
#############################################################################################################

#############################################################################################################    

drawGridHardCoded:		# void drawGrid(byte *grid)
	la 	$s0, grid_hard	# &grid
	li 	$s1, 0		# drawGridRows for
	la	$s2, FB_PTR	# Dysplay adress
	la 	$s3, colors	# color words adress
	li 	$s4, 0		# drawGridDrawPixelX for
	li 	$s5, 0		# drawGridDrawPixelY for
	li 	$s6, 0		# drawGridCols for
	
drawGridRows:					
	bge  $s1, GRID_ROWS, drawGridCols	
	addi $s1, $s1, 1			# s1++
				
	lb   $t1, ($s0)			# t1 = *(grid) 
	addi $s0, $s0, 1		# &grid++
	addi $t1, $t1, GRID_ID_OFFSET	# sprite.ID -= 64
	mul	$t1, $t1, SPRITE_SIZE	#
	la 	$t2,sprites
	add 	$t1, $t1, $t2 

drawGridDrawPixelX:
	bge  $s4, X_SCALE, drawGridDrawPixelY	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s4, $s4, 1
	lb 	$t2, ($t1)
	addi	$t1, $t1, 1	# &sprite++
	sll	$t2, $t2, 2	# color id * 4
	add	$t2, $t2, $s3 	# color id += &color 
	lw 	$t2, ($t2)
	sw	$t2, ($s2)
	addi	$s2, $s2, 4
	# compensate display pointer adress to draw the next pixel
	b drawGridDrawPixelX
		
drawGridDrawPixelY:
	bge  $s5, Y_SCALE, drawGridDrawSprite	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s5, $s5, 1	
	add	$s4, $zero, $zero
	addi	$s2, $s2, 996 # s2 += (256-7)*4
	# compensate display pointer adress to draw the next pixel line
	b drawGridDrawPixelX

drawGridDrawSprite:
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	addi	$s2, $s2, -7168 # s2 += -256*4*7
	# compensate display pointer adress to draw the next sprite
	b drawGridRows
	
drawGridCols:	
	bge  $s6, GRID_COLS, drawGridEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s6, $s6, 1
	add	$s5, $zero, $zero
	add	$s4, $zero, $zero
	add	$s1, $zero, $zero
	addi	$s2, $s2, 6160 #s2 += (256*7*4)-(36*7*4)
	# compensate display pointer adress to draw the next sprite line
	b drawGridRows
	
drawGridEnd:	
	jr $ra
	
#############################################################################################################    

#############################################################################################################    

.globl drawSprite
drawSprite:				# void drawSprite(struct animetedSprite)	
	
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)
	sw 	$s5, 36($sp)
	sw 	$s6, 40($sp)
	sw 	$s7, 44($sp)
	
	##################### a0 = &snake			# sprite.name
	lw 	$s0, 0($a0)	# s0 = snake[0]		# sprite.id
	lw 	$s1, 4($a0)	# s1 = snake[1]		# sprite.posX
	lw 	$s2, 8($a0)	# s2 = snake[2]		# sprite.posY 
	la 	$s3, sprites 	# s3 = &sprites
	la 	$s4, colors	# s4 = &colors
	add 	$s5, $zero, $zero	# s5 = 0
	la	$s6, FB_PTR	# Dysplay adress
	add 	$s7, $zero, $zero	# s7 = 0
	
	mul	$s1, $s1, 4 	#256 * 4
	add 	$s6, $s6, $s1
	mul	$s2, $s2, 1024 	#256 * 4
	add 	$s6, $s6, $s2
	
	mul 	$t0, $s0, SPRITE_SIZE	# t0 = sprite.id * 49
	add 	$s3, $t0, $s3		# &sprites += sprite.id * 49

drawSpritePixelX:	
	bge 	$s5, X_SCALE, drawSpritePixelY	# ((s3 <= 49) ? drawSpriteEnd)
	addi	$s5, $s5, 1

	lb 	$t2, ($s3)
	addi	$s3, $s3, 1	# &sprite++
	sll	$t2, $t2, 2	# color id * 4
	add	$t2, $t2, $s4 	# color id += &color 
	lw 	$t2, ($t2)
	sw	$t2, ($s6)
	addi	$s6, $s6, 4
	# compensate display pointer adress to draw the next pixel
	b drawSpritePixelX
		
drawSpritePixelY:	
	bge  $s7, 6, drawSpriteEnd		# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	addi	$s7, $s7, 1	
	add	$s5, $zero, $zero
	addi	$s6, $s6, 996 # s2 += (256-7)*4 
	# compensate display pointer adress to draw the next pixel line
	b drawSpritePixelX
	
drawSpriteEnd:
	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	lw 	$s5, 36($sp)
	lw 	$s6, 40($sp)
	lw 	$s7, 44($sp)
	
	addi	$sp, $sp, 64		
    	jr  	$ra		# return
    	
#############################################################################################################	

#############################################################################################################

 enableKeyboardInterrupt:
	li 	$t0, 0xffff0002	# t0 = 0xffff0002
	sw 	$t0, 0xffff0000	# *((uint32_t) 0xffff0000) = t0
	jr   	$ra		# return

#############################################################################################################    

############################################################################################################# 	
    	  	  	
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
 	sw   $t0, 32($k1)
	sw   $t1, 36($k1) 
	sw   $t2, 40($k1)
	sw   $t3, 44($k1)
	sw   $t4, 48($k1)
  	sw   $t5, 52($k1)
	sw   $t6, 56($k1)
	sw   $t7, 60($k1)
	sw   $s0, 64($k1)
	sw   $s1, 68($k1)
	sw   $s2, 72($k1)
	sw   $s3, 76($k1) 
	sw   $s4, 80($k1)
	sw   $s5, 84($k1)
	sw   $s6, 88($k1)
	sw   $s7, 92($k1)
	sw   $t8, 96($k1)
	sw   $t9, 100($k1)
	sw   $gp, 104($k1)
	sw   $sp, 108($k1)
	sw   $fp, 112($k1)
	sw   $ra, 116($k1)
	mfhi $k0
  	sw   $k0, 120($k1)
  	mflo $k0
  	sw   $k0, 124($k1)
  	
printStringAdress(stringGenericEx)
	
	mfc0	$s0, $13
	andi	$s0, 0xFC
	srl	$s0, $s0, 2

  	la 	$s1, jtable	#load andress of vector
  	add 	$s1, $s1, $s0 	# jtable adress
  	lw	$s1, 0($s1)	# Carrego valor do elemento em $a1
  	jr 	$s1
  
case0:
	printStringAdress(stringHWInterruptEx)

	la  	$s0, kbBuffer	# Load Sprite adress , Sprite Name
	lw 	$s1, 0($s0) 	# Load kbBuffer.isValid
 	lw 	$s2, 4($s0)	# Load kbBuffer.x
 	lw 	$s3, 8($s0)	# Load kbBuffer.y
	lw 	$s4, 12($s0)	# Load kbBuffer.isPaused
	
	la 	$s7, 0xffff0004 # Load keyboard info on $s1 to the right address
	lw 	$s7, ($s7)	# Load keyboard data from 0xffff0004
	
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

case4:

	printStringAdress(stringLoadErrorEx)
    	b   	interruptEnd
	
case5:

	printStringAdress(stringStoreErrorEx)
    	b   	interruptEnd
	
case6:

	printStringAdress(stringBusInstErrorEx)
    	b   	interruptEnd
	
case7:

	printStringAdress(stringBusLSErrorEx)
    	b   	interruptEnd
	
case8:

	printStringAdress(stringInvalidSyscallEx)
    	b   	interruptEnd
	
case9:

	printStringAdress(stringBreakPointEx)
    	b   	interruptEnd
	
case10:

	printStringAdress(stringReservedEx)
    	b   	interruptEnd
	
case12:

	printStringAdress(stringArithmeticEx)
    	b   	interruptEnd
	
case13:

	printStringAdress(stringTrapEx)
    	b   	interruptEnd 
	
case1:
case2:
case3:
case11:
case14:

	printStringAdress(stringInvalidEx)
    	b   	interruptEnd
    
case15:

	printStringAdress(stringFloatInstEx)
    	b   	interruptEnd

default:

	printStringAdress(stringOutOfRangeEx)
	
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
	lw    	$t0, 32($k1)
	lw    	$t1, 36($k1) 
	lw    	$t2, 40($k1)
	lw    	$t3, 44($k1)
	lw    	$t4, 48($k1)
	lw    	$t5, 52($k1)
	lw    	$t6, 56($k1)
	lw    	$t7, 60($k1)
	lw    	$s0, 64($k1)
	lw    	$s1, 68($k1)
	lw    	$s2, 72($k1)
	lw    	$s3, 76($k1) 
	lw    	$s4, 80($k1)
	lw    	$s5, 84($k1)
	lw    	$s6, 88($k1)
	lw    	$s7, 92($k1)
	lw    	$t8, 96($k1)
	lw    	$t9, 100($k1)
	lw    	$gp, 104($k1)
	lw    	$sp, 108($k1)
	lw    	$fp, 112($k1)
	lw    	$ra, 116($k1)
	lw    	$k0, 120($k1)
	mthi  	$k0
	lw    	$k0, 124($k1)
	mtlo  	$k0

	la	$k0, main
	mtc0	$k0, $14      # EPC = point to next instruction 
	eret
	
.kdata
jtable: .word case0, case1, case2, case3, case4, case5, case6, case7, case8, case9, case10, case11, case12, case13, case14, case15, default

.align 2
# Excepion String Table
stringGenericEx: 	.asciiz "\n Exceção ocorrida: "
stringHWInterruptEx:	.asciiz "Interrupção de Hardware\n"	  
stringLoadErrorEx: 	.asciiz "Address Error caused by load or instruction fetch\n"
stringStoreErrorEx: 	.asciiz "Address Error caused by store instruction\n"
stringBusInstErrorEx: 	.asciiz "Bus error on instruction fetch\n"
stringBusLSErrorEx: 	.asciiz "Bus error on data load or store\n"
stringInvalidSyscallEx: .asciiz "Error caused by invalid Syscall\n"
stringBreakPointEx: 	.asciiz "Error caused by Break instruction\n"
stringReservedEx: 	.asciiz "Reserved instruction error\n"
stringArithmeticEx:	.asciiz "Erro de overflow\n"
stringTrapEx: 		.asciiz "Error caused by trap instruction\n"
stringInvalidEx: 	.asciiz "Invalid Exception\n"
stringFloatInstEx: 	.asciiz "Error caused by floating_point instruction\n"
stringOutOfRangeEx: 	.asciiz "Out Of Range\n"
stringHere: 	.asciiz "here!\n"
.align 2
kernelRegisters: .space    256
