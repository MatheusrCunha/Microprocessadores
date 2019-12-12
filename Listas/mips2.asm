.text 
	lw $t0, 0($gp) # $t0 <- mem[ox10008000]
	lw $t1, 4($gp) #$t1 <- mem[0x100008004]
	lw $t2, 8($gp)
	add $t0, $t1, $t0
	add $t0, $t2, $t0
	sw $t0, 12($gp)