

	li $s1, 100
	li $s0, 200
	blt $s0, $s1, label
	addi $s2, $s1, 0
	j end
label:
	addi $s2, $s0, 0
end:
