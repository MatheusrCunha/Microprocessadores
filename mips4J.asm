
	addi $s6, $s4, 0
	addi $t1, $s3, 0
	add $s6, $s6, $t1
	lw $s7, 32
	beq $s7, $s6, label
label:
