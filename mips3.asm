.text

	lw $t0, 0($gp) # $t0 <- mem[ox10008000]
	lw $t1, 4($gp)
	sub $t0, $t0, $t1
	sw $t0, 8($gp)