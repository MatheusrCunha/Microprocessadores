.data 


.text

.globl main


main:

	# la $s0, 0x10008000

	lw $t0, 0($gp) # $t0 <- mem[ox10008000]
	lw $t1, 4($gp) #$t1 <- mem[0x100000004]
	add $t0, $t1, $t0
	sw $t0, 8($gp)
	
	
	
