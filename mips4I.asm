
	li $s3, 10
	li $s4, 5
	li $t1, 8
	
	sub $t4, $s3, $s4
	lw $s7, ($t1)
	lw $s6, ($t4)
	
	beq $s7, $s6, label
label:

