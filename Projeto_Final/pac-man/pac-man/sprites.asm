.include "graphics.inc"

.text
.globl main
main:
	# CHAMA DRAW GRID
    #$li $a0, 35
    #li $a1, 35
    #la $a2, grid
    #jal draw_grid    
    #hlt: b hlt

	# TESTE DRAW SPRITE
    li   $t8,0
    li   $t9,0
    main2:
    move $a0,$t8
    move $a1,$t9
    li   $a2,14
    jal  draw_sprite
    addi $t8, $t8, 1
	
	## DELAY(50)
    li $v0, 32
    li $a0, 50
    syscall
	
	##=========
    b main2
    
    
# draw_grid(width, height, grid_table)
.globl draw_grid
draw_grid:

	jr   $ra


# draw_sprite(X, Y, sprite_id)
.globl draw_sprite
draw_sprite:

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
