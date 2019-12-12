
#############################################################################################################

.macro SysLock
	vasckuadgfvuioqblavifeuvblo: 
	b vasckuadgfvuioqblavifeuvblo
.end_macro

#############################################################################################################

.macro EndProgram
    li $v0, 10
    syscall
.end_macro

#############################################################################################################

.macro DelayMs (%microsecs)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)

	addi	$a0, $zero, %microsecs
	li 	$v0, 32
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

#' Be aware: this macro modifies $v0 register value
.macro getInt () 

	li   $v0, 5
	syscall
	
.end_macro

#############################################################################################################

.macro printInt (%number)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)

	add	$a0, $zero, %number
	li 	$v0, 1
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

.macro printIntAdress (%register)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)

	add 	$a0, $zero, %register
	li 	$v0, 1
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

#' Be aware: doesnt work on ktext space 
.macro printString (%str)
.data
mStr:	.asciiz 	%str
.align 2
.text
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)
	
	la $a0, mStr
	li $v0, 4
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

.macro printStringAdress (%register)
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$v0, 4($sp)
	
	la $a0, %register
	li $v0, 4
	syscall
	
	lw 	$a0, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

#' Be aware: this macro modifies $v0 register value
.macro generateRadomMovement () 
	addi $sp, $sp, -8
	sw 	$a0, 0($sp)
	sw 	$a1, 4($sp)

	li $a1, 3
	li $v0, 42
	syscall
	addi	$v0, $a0, -1
	
	lw 	$a0, 0($sp)
	lw 	$a1, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################

.macro printDouble (%register)
	addi $sp, $sp, -8
	sw 	$f12, 0($sp)
	sw 	$v0, 4($sp)
	
	add.d	$f12, $zero, %register
	li $v0, 3
	syscall
	
	lw 	$f12, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################


#############################################################################################################

.macro printFloat (%register)
	addi $sp, $sp, -8
	s.s 	$f12, 0($sp)
	sw 	$v0, 4($sp)
	
	
	mov.s	$f12, %register
	li $v0, 2
	syscall
	
	l.s 	$f12, 0($sp)
	lw 	$v0, 4($sp)
	addi $sp, $sp, 8
.end_macro

#############################################################################################################


#############################################################################################################

#' Be aware: this macro modifies $f0 register value

.macro getFloat ()
	addi	$sp, $sp, -8
	sw 	$v0, 0($sp)

	li 	$v0, 6
	syscall
	
	lw 	$v0, 0($sp)
	addi 	$sp, $sp, 8
	
	.end_macro

#############################################################################################################

	
