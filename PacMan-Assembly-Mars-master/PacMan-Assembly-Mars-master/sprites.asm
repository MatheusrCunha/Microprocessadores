.include "graphics.asm"
.include "Macros.asm"
.include "control.asm"

scoreData:
.word 0
mainLoopCount:
.word 0

.text
startGame:	
	la 	$a0, pacman	# a0 = &pacman
	li	$s0, 119
	sw	$s0, 4($a0)
	li	$s0, 140
	sw	$s0, 8($a0)
	li	$s0, 0
	sw	$s0, 12($a0)
	li	$s0, 0
	sw	$s0, 16($a0)

	la 	$a0, ghost0
	li	$s0, 105
	sw	$s0, 4($a0)
	li	$s0, 105
	sw	$s0, 8($a0)
	li	$s0, -1
	sw	$s0, 12($a0)
	li	$s0, 1
	sw	$s0, 16($a0)

	la 	$a0, ghost1
	li	$s0, 105
	sw	$s0, 4($a0)
	li	$s0, 119
	sw	$s0, 8($a0)
	li	$s0, -1
	sw	$s0, 12($a0)
	li	$s0, -1
	sw	$s0, 16($a0)
	
	la 	$a0, ghost2
	li	$s0, 133
	sw	$s0, 4($a0)
	li	$s0, 105
	sw	$s0, 8($a0)
	li	$s0, 1
	sw	$s0, 12($a0)
	li	$s0, 1
	sw	$s0, 16($a0)

	la 	$a0, ghost3
	li	$s0, 133
	sw	$s0, 4($a0)
	li	$s0, 119
	sw	$s0, 8($a0)
	li	$s0, 1
	sw	$s0, 12($a0)
	li	$s0, -1
	sw	$s0, 16($a0)
	
	la 	$a0, ghost4
	li	$s0, 112
	sw	$s0, 4($a0)
	li	$s0, 112
	sw	$s0, 8($a0)
	li	$s0, -1
	sw	$s0, 12($a0)
	li	$s0, 0
	sw	$s0, 16($a0)	
	
	la 	$a0, ghost5
	li	$s0, 126
	sw	$s0, 4($a0)
	li	$s0, 112
	sw	$s0, 8($a0)
	li	$s0, 1
	sw	$s0, 12($a0)
	li	$s0, 0
	sw	$s0, 16($a0)	
	
	la 	$a0, kbBuffer
	li	$s0, 0
	sw	$s0, 0($a0)
	sw	$s0, 4($a0)
	sw	$s0, 8($a0)
	sw	$s0, 12($a0)
	
	sw	$s0, scoreData
	sw	$s0, mainLoopCount
	
	jal 	drawGridHardCoded   			# void drawGridLinear(void)
	jal 	enableKeyboardInterrupt	# void enableKeyboardInterrupt()

	#b main
	
#############################################################################################################    

main:	
	la 	$a0, pacman	# a0 = &pacman
	jal	checkGameOver
	la	$a1, kbBuffer	
	jal	moveSprite
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal  score	

	la 	$a0, ghost0	# s0 = &ghost0
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid		
	
	la 	$a0, ghost1	# s0 = &ghost1
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid		
	
	la 	$a0, ghost2	# s0 = &ghost2
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid		
	
	la 	$a0, ghost3	# s0 = &ghost3
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid		
	
	la 	$a0, ghost4	# s0 = &ghost3
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid		
	
	la 	$a0, ghost5	# s0 = &ghost3
	jal	moveGhost
	jal 	drawSprite	# void drawSprite(struct animetedSprite)
	jal	redrawGrid	
			
	la 	$a0, ghost0	# s0 = &ghost0
	lw	$a1, mainLoopCount
	addi	$a1, $a1, 1
	jal 	createMovement
	sw	$a1, mainLoopCount
	
	jal	handleGamePause
	
	DelayMs(20)
	#DelayMs(500)
   	j 	main			# goto main
 
#############################################################################################################    

#############################################################################################################    

.globl checkGameOver
checkGameOver:				# void drawSprite(struct animetedSprite)	
	
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)
	sw 	$s7, 44($sp)
	
	move	$s0,	$a0
	lw 	$s1, 4($s0)	# sprite.posX
	lw 	$s2, 8($s0)	# sprite.posY 
	div	$s1, $s1, 7
	div	$s2, $s2,	7
	addi $s0, $s0, 20	
	
	add $s7, $zero, $zero
checkGameOverLoop:			
	bge  $s7, NUMBER_OF_GHOSTS, checkGameOverEnd
	addi $s7, $s7, 1	# s7++

	lw 	$s3, 4($s0)	# sprite.posX
	lw 	$s4, 8($s0)	# sprite.posY 
	div	$s3, $s3, 7
	div	$s4, $s4,	7
	addi $s0, $s0, 20
	
	bne	$s1, $s3, checkGameOverLoop
	bne	$s2, $s4, checkGameOverLoop
	
	printString("\n GAME OVER! \n")
	EndProgram

checkGameOverEnd:

	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	lw 	$s7, 44($sp)
	
	addi	$sp, $sp, 64		
    	jr  	$ra				# return
    	
#############################################################################################################	

#############################################################################################################    

.globl redrawGrid
redrawGrid:				# void drawSprite(struct animetedSprite)	
	
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
	
	##################### sprite.name
	lw 	$s0, 4($a0)	# sprite.posX
	lw 	$s1, 8($a0)	# sprite.posY 
	lw 	$s2, 12($a0)	# sprite.movX
	lw 	$s3, 16($a0)	# sprite.movY 
	add 	$s4, $zero, $zero	# s4 = 0
	la 	$s5, sprites 	# s3 = &sprites
	la 	$s6, colors	# s4 = &colors
	la	$s7, FB_PTR	# Dysplay adress
	
	lw 	$t0, 4($a0)	# sprite.posX
	lw 	$t1, 8($a0)	# sprite.posY 
	beq 	$s2, -1, redrawGridPosXIsMinusOne
	beq 	$s2,  1, redrawGridPosEnd
redrawGridCheckPosY:
	lw 	$t0, 4($a0)	# sprite.posX
	lw 	$t1, 8($a0)	# sprite.posY 
	beq 	$s3, -1, redrawGridPosYIsMinusOne
	beq 	$s3,  1, redrawGridPosEnd
	b	redrawGridEnd

redrawGridPosXIsMinusOne:
	addi	$t0, $s0, 6
	b	redrawGridPosEnd

redrawGridPosYIsMinusOne:
	addi	$t1, $s1, 6
	b	redrawGridPosEnd

redrawGridPosEnd:

	div 	$t2, $t0, X_SCALE
	mfhi $t5
	div 	$t3, $t1, Y_SCALE
	mfhi $t6
	mul 	$t6, $t6, X_SCALE
		
	la	$t9, grid
	mul 	$t4, $t3, GRID_ROWS
	add  $t4, $t4, $t2
	add 	$t9, $t9, $t4
	lb	$t4, ($t9)
	add 	$t4, $t4, GRID_ID_OFFSET
	
	#la	$t8, sprites
	mul 	$t4, $t4, SPRITE_SIZE
	add	$t4, $t4, $t5
	add	$t4, $t4, $t6
	add 	$t4, $t4, $s5
	#lb	$t6, ($t4)
	
	#FB_PTR	# Dysplay adress
	mul 	$t5, $t1, 1024		# posY * FB_YRES
	mul 	$t6, $t0, 4		# posX * 4
	add 	$t5, $t6, $t5
	add	$t5, $t5, $s7

	beq 	$s2, -1, redrawGridSpriteColBegin
	beq 	$s2,  1, redrawGridSpriteColBegin
	beq 	$s3, -1, redrawGridSpriteRowBegin
	beq 	$s3,  1, redrawGridSpriteRowBegin
	b	redrawGridPosEnd

redrawGridSpriteColBegin:
	add	$s2, $zero, $zero
	
redrawGridSpriteColLoop:	
	bge 	$s4, Y_SCALE, redrawGridCheckPosY
	addi	$s4, $s4, 1

	lb	$t6, ($t4)
	addi	$t4, $t4, 7	# &sprite += 7
	
	sll	$t6, $t6, 2	# color id * 4
	add	$t6, $t6, $s6 	# color id += &color 
	lw 	$t6,	($t6)

	sw	$t6, ($t5)
	addi	$t5, $t5, 1024	#draw next X pixel
	
	# compensate display pointer adress to draw the next pixel
	b redrawGridSpriteColLoop

redrawGridSpriteRowBegin:
	add	$s4, $zero, $zero
redrawGridSpriteRowLoop:
	bge 	$s4, X_SCALE, redrawGridEnd	# ((s3 <= 49) ? drawSpriteEnd)
	addi	$s4, $s4, 1

	lb	$t6, ($t4)
	addi	$t4, $t4, 1	# &sprite += 7
	
	sll	$t6, $t6, 2	# color id * 4
	add	$t6, $t6, $s6 	# color id += &color 
	lw 	$t6,	($t6)

	sw	$t6, ($t5)
	addi	$t5, $t5, 4	#draw next X pixel
	
	b redrawGridSpriteRowLoop
	
redrawGridEnd:

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
    	jr  	$ra				# return
    	
#############################################################################################################	

#############################################################################################################

.globl handleGamePause
handleGamePause:		# (void)score(&sprite)
	addi $sp, $sp, -64
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s4, 20($sp)

handleGamePauseLoop:
	la  	$s0, kbBuffer	# Load Sprite adress , Sprite Name
	lw 	$s4, 12($s0)	# Load kbBuffer.isPaused
	#DelayMs(20)
	bne $s4, $zero, handleGamePauseLoop
	
handleGamePauseEnd:
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s4, 20($sp)
	
	addi $sp, $sp, 64
	jr 	$ra				# return
		  	  	
#############################################################################################################    

#############################################################################################################

.globl score
 score:		# (void)score(&sprite)
	addi $sp, $sp, -64
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s4, 20($sp)
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	

	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	la 	$s4,	grid
	
	div $s0, $s0, X_SCALE	# tPosX /= 7;
	div $s1, $s1, Y_SCALE	# tPosY /= 7;
	
	mul	$s1, $s1, GRID_COLS	# tPosY *= 35;
	add	$s0, $s0, $s1		# tPosX += tPosY;
	
	add	$s0, $s0,	$s4		# (tPosX + tPosY) += &grid 
	lb	$s1, ($s0)		# load grid[tPosX][tPosY];	
	
	lw	$t1, scoreData		# load score int
	
	beq 	$s1, $zero, scoreEnd
	beq 	$s1, 64, scoreTenPoins
	beq 	$s1, 65, scoreTenPoins
	beq 	$s1, 66, scoreThousandPoins
	beq 	$s1, 68, scoreHundredPoins
	b 	scoreSetGridToZero
	
scoreTenPoins:

	addi $t1, $t1, 10 
	b 	scoreSetGridToZero

scoreThousandPoins:

	addi $t1, $t1, 1000 
	b 	scoreSetGridToZero

scoreHundredPoins:

	addi $t1, $t1, 100
	b 	scoreSetGridToZero
	
scoreSetGridToZero:

	add 	$t0, $zero, $zero
	sb	$t0, ($s0)		# grid[tPosX][tPosY] = 0;
	
	printString("\n Score: ")
	printInt($t1)
	beq 	$t1, 7410, scoreYouWon
	b	scoreEnd
	
scoreYouWon:
printString("\n\n CONGRATULATIONS!!! \n YOU GOT IT ALL!!! \n\n ")
EndProgram
	
scoreEnd:

	sw 	$t1, scoreData
	
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s4, 20($sp)
	
	addi $sp, $sp, 64
	jr 	$ra				# return		

#############################################################################################################

#########################################################################################################

.globl createMovement
createMovement:

	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)

	move	$s0, $a0	# s0 = &sprite

	ble	$a1,	100, createMovementEnd	
	addi	$a1, $zero, 50
	
	add 	$s1, $zero, $zero	
createMovementLoop:			
	bge  $s1, NUMBER_OF_GHOSTS, createMovementEnd	# ((i => 1225) ? goto drawGridExit)
	addi $s1, $s1, 1			# s1++
						
	lw 	$s3, 12($s0)	# sprite.movX 
	lw 	$s4, 16($s0)	# sprite.movY 

	generateRadomMovement()
	add $s3, $zero, $v0
	generateRadomMovement()
	add $s4, $zero, $v0
	
	sw 	$s3, 12($s0)	# sprite.movX 
	sw 	$s4, 16($s0)	# sprite.movY 
	
	addi $s0, $s0, 20 	# 
								
	b createMovementLoop

createMovementEnd:

	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	addi	$sp, $sp, 64		
    	jr  	$ra				# return
	
#########################################################################################################

#########################################################################################################

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
	move	$a1, $s6 						# a1 = kbBuffer.X
	move $a2, $s7						# a2 = kbBuffer.Y
	jal	checkWall						# always (x,0) or (0,y) being x|y -> (int)(-1 to 1)
	bge	$v0,	69, moveSpriteKbBufferIsNotValid		# (returnNextId(struct sprite) > 69) ? goto moveSpriteEnd
	
	add 	$s3, $zero, $s6				# sprite.movX = kbBuffer.X;
	add 	$s4, $zero, $s7				# sprite.movY = kbBuffer.Y;
	add	$s5, $zero, $zero				# kbBuffer.isValid = 0;
	b	moveSpriteDoTheThing			# if input data is valid

moveSpriteKbBufferIsNotValid:	
									# a0 = &sprite
	move	$a1, $s3						# a1 = sprite.movX
	move $a2, $s4						# a2 = sprite.movY
	jal	checkWall						# always (x,0) or (0,y) being x|y -> (int)(-1 to 1)
	bge	$v0,	69, moveSpriteStopIt			# (returnNextId(struct sprite) > 69) ? goto moveSpriteEnd

moveSpriteDoTheThing:
	add 	$s1, $s1, $s3			# sprite.posX += sprite.movX
	add 	$s2, $s2, $s4			# sprite.posY += sprite.movY
	b 	moveSpriteEnd
	
moveSpriteStopIt:		
	add	$s3, $zero, $zero				# sprite.movX = 0;
	add	$s4, $zero, $zero				# sprite.movY = 0;
	
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
    	jr  	$ra				# return
	
#############################################################################################################

#########################################################################################################

.globl moveGhost
moveGhost:
	addi $sp, $sp, -64		#allocate 8 bytes on stack
	sw 	$ra, 12($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 20($sp)
	sw 	$s2, 24($sp)
 	sw 	$s3, 28($sp)
	sw 	$s4, 32($sp)

	sw 	$a1, 52($sp)
	sw 	$a2, 56($sp)

	##################### a0 = &sprite			
	lw 	$s0, 0($a0)	# sprite.id
	lw 	$s1, 4($a0)	# sprite.posX
	lw 	$s2, 8($a0)	# sprite.posY 
 	lw 	$s3, 12($a0)	# sprite.movX 
	lw 	$s4, 16($a0)	# sprite.movY 
	
	bne	$s3, $zero, moveGhostCheckWallX 	# (!s1) ? goto moveGhostCheckWallX
	bne	$s4, $zero, moveGhostCheckWallY	# (!s2) ? goto moveGhostCheckWallY
	b	moveGhostEnd
	
moveGhostCheckWallX:

	move	$a1, $s3 		# a1 = animatedSprite.movX;
	move	$a2, $zero	# a2 = 0;
	jal	checkWall
	bge	$v0,	69,	moveGhostCheckWallY	# (returnNextId(struct sprite) > 69) ? goto moveGhostEnd
	add 	$s1, $s1, $s3	# sprite.posX += sprite.movX
	sw 	$s1, 4($a0)	# sprite.posX
	
moveGhostCheckWallY:

	move	$a1, $zero	# a1 = 0;
	move	$a2, $s4		# a2 = animatedSprite.movY;
	jal	checkWall
	bge	$v0,	69,	moveGhostEnd	# (returnNextId(struct sprite) > 69) ? goto moveGhostEnd
	add 	$s2, $s2, $s4	# sprite.posY += sprite.movY
	sw 	$s2, 8($a0)	# sprite.posY 
	
moveGhostEnd:

	lw 	$ra, 12($sp)
	lw 	$s0, 16($sp)
	lw 	$s1, 20($sp)
	lw 	$s2, 24($sp)
 	lw 	$s3, 28($sp)
	lw 	$s4, 32($sp)
	
	lw 	$a1, 52($sp)
	lw 	$a2, 56($sp)

	addi	$sp, $sp, 64		
    	jr  	$ra				# return
	
#############################################################################################################

#############################################################################################################

.globl checkWall
 checkWall:		# (int grid.id)checkWall(&grid, movX , movY )
	addi $sp, $sp, -64
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	sw 	$s4, 20($sp)
	
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	
	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	move	$s2, $a1		# s2 = animatedSprite.movX;
	move	$s3, $a2		# s3 = animatedSprite.movY;
	la 	$s4,	grid

checkWallCheckUpLeft:
	jal 	checkWallMain
	add	$t0, $zero, $v0	

checkWallCheckUpRight:
	add 	$s0, $s0,	6 		# tPosX=animatedSprite.posX + 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallCheckDownRight
	add	$t0, $zero, $v0
	
checkWallCheckDownRight:
	add 	$s1, $s1,	6 		# tPosY=animatedSprite.posY + 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallCheckDownbLeft
	add	$t0, $zero, $v0	

checkWallCheckDownbLeft:
	add	$s0, $s0, -6 		# tPosX=animatedSprite.posX - 6;
	jal 	checkWallMain
	
	sgt	$t1, $v0, $t0
	beq	$t1, $zero, checkWallEnd
	add	$t0, $zero, $v0
	j	checkWallEnd
	
checkWallMain:	

	add $t2, $s0, $s2		# tPosX += animatedSprite.movX;
	add $t3, $s1, $s3		# tPosY += animatedSprite.movY;
	
	div $t2, $t2, X_SCALE	# tPosX /= 7;
	div $t3, $t3, Y_SCALE	# tPosY /= 7;
	
	mul	$t3, $t3, GRID_COLS	# tPosY *= 35;
	add	$t2, $t2, $t3		# tPosX += tPosY;
	
	add	$t2, $t2,	$s4		# (tPosX + tPosY) += &grid 
	lb	$v0, ($t2)		# v0 = grid[tPosX][tPosY];	
	jr 	$ra				# return	
	
checkWallEnd:
	add	$v0, $zero, $t0
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	lw 	$s3, 16($sp)
	lw 	$s4, 20($sp)
	
	addi $sp, $sp, 64
	jr 	$ra				# return		

#############################################################################################################

#############################################################################################################    

.globl returnNextId
 returnNextId:		# int ID returnNextId(X,Y, *gride)
	addi $sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	sw 	$s4, 20($sp)
	
#animated_sprite (%name, %id, %pos_x, %pos_y, %mov_x, %mov_y)
#		ofset:	&  ,  0  ,   4  ,    8  ,   12  ,  16	
	lw	$s0, 4($a0) 	# s0 = animatedSprite.posX;
	lw	$s1, 8($a0) 	# s1 = animatedSprite.posY;
	lw	$s2, 12($a0)	# s2 = animatedSprite.movX;
	lw	$s3, 16($a0)	# s3 = animatedSprite.movY;
	la 	$s4,	grid
	
	beq 	$s2, -1, returnNextIdIfPosX	# animatedSprite.movX == -1 ? goto returnNextIdIfPosX;
	beq 	$s3, -1, returnNextIdIfPosY	# animatedSprite.movY == -1 ? goto returnNextIdIfPosY;
	b returnNextIdElse

returnNextIdIfPosX:
	add $s0, $s0, 6 		# tPosX=animatedSprite.posX + 6;
	b returnNextIdElse
	
returnNextIdIfPosY:
	add $s1, $s1, 6		# tPosY=animatedSprite.posY + 6;
	b returnNextIdElse

returnNextIdElse:	
	div $s0, $s0, X_SCALE	# tPosX /= 7;
	div $s1, $s1, Y_SCALE	# tPosY /= 7;
	
	add $s0, $s0, $s2		# tPosX += animatedSprite.movX;
	add $s1, $s1, $s3		# tPosY += animatedSprite.movY;
	
	mul	$s1, $s1, GRID_COLS	# tPosY *= 35;
	add	$s0, $s0, $s1		# tPosX += tPosY;
	
	add	$s4, $s0,	$s4			# tPosX += &grid 
	lb	$v0, ($s4)			# v0 = grid[tPosX][tPosY];	

	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	lw 	$s3, 16($sp)
	lw 	$s4, 20($sp)
	addi $sp, $sp, 24	
	jr 	$ra				# return
	
#############################################################################################################

#############################################################################################################    

drawGridHardCoded:		# void drawGrid(byte *grid)
	la 	$s0, grid		# &grid
	li 	$s1, 0		# drawGridRows for
	la	$s2, FB_PTR	# Dysplay adress
	la 	$s3, colors	# color words adress
	li 	$s4, 0		# drawGridDrawPixelX for
	li 	$s5, 0		# drawGridDrawPixelY for
	li 	$s6, 0		# drawGridCols for
	
drawGridRows:					
	bge  $s1, GRID_ROWS, drawGridCols	# ((i => 1225) ? goto drawGridExit)
	addi $s1, $s1, 1			# s1++
				
	lb   $t1, ($s0)			# t1 = *(grid) 
	addi $s0, $s0, 1			# &grid++
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
	addi	$s2, $s2, 6188 #s2 += (256*7*4)-(35*7*4)
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
	
	##################### a0 = &pacman			# sprite.name
	lw 	$s0, 0($a0)	# s0 = pacman[0]		# sprite.id
	lw 	$s1, 4($a0)	# s1 = pacman[1]		# sprite.posX
	lw 	$s2, 8($a0)	# s2 = pacman[2]		# sprite.posY 
	la 	$s3, sprites 	# s3 = &sprites
	la 	$s4, colors	# s4 = &colors
	add 	$s5, $zero, $zero	# s5 = 0
	la	$s6, FB_PTR	# Dysplay adress
	add 	$s7, $zero, $zero	# s7 = 0
	
	mul	$s1,	$s1, 4 #256 * 4
	add 	$s6,	$s6,	$s1
	mul	$s2,	$s2, 1024 #256 * 4
	add 	$s6,	$s6,	$s2
	
	mul 	$t0, $s0, SPRITE_SIZE	# t0 = sprite.id * 49
	add 	$s3, $t0, $s3			# &sprites += sprite.id * 49

drawSpritePixelX:	
	bge 	$s5, X_SCALE, drawSpritePixelY	# ((s3 <= 49) ? drawSpriteEnd)
	#bge 	$s5, 6, drawSpritePixelY	# ((s3 <= 49) ? drawSpriteEnd)
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
	#bge  $s7, Y_SCALE, drawSpriteEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
	bge  $s7, 6, drawSpriteEnd	# ((t => 7) ? goto drawGridDrawPixelXEnd()	
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
    	jr  	$ra				# return
    	
#############################################################################################################	

#############################################################################################################

 enableKeyboardInterrupt:
	li 	$t0, 0xffff0002	# t0 = 0xffff0002
	#add 	$t0, $zero, 0x00000002	# t0 = 0xffff0002
	sw 	$t0, 0xffff0000		# *((uint32_t) 0xffff0000) = t0
	jr   $ra					# return

#############################################################################################################    

############################################################################################################# 	
    	  	  	
.ktext 0x80000180  

#Create Interuptions Stack 
  	move	$k0, $at      # $k0 = $at 
  	la	$k1, kernelRegisters    
  	sw	$k0, 0($k1)   
  	sw	$v0, 4($k1)
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
	
	la 	$s7, 0xffff0004  	# Load keyboard info on $s1 to the right address
	lw 	$s7, ($s7)		# Load keyboard data from 0xffff0004
	
	beq 	$s7,100, hwInterruptGoRight	# Key d, go Right
	beq 	$s7, 68, hwInterruptGoRight	# Key D, go Right
	beq 	$s7, 97, hwInterruptGoLeft	# Key a, go Left
	beq 	$s7, 65, hwInterruptGoLeft	# Key A, go Left
	beq 	$s7,119, hwInterruptGoUp		# Key w, go Up
	beq 	$s7, 87, hwInterruptGoUp		# Key W, go Up
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
jtable: .word case0, case1, case2, case3, case4, case5, case6, case7, case8, case9, case10, case11, case12, case13, case14, case15, default

.align 2
# Excepion String Table
stringGenericEx: 	.asciiz "\n Exception Occurred: "
stringHWInterruptEx:	.asciiz "HW Interrupt\n"	  
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
