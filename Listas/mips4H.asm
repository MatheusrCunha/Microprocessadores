

	li $s0, 100
	li $s1, 300
	
	bgt $s0,$s1, label
	
	addi $s0, $s0, 0 
	exit
label;
	addi $s1, $s1, 0
exit:
