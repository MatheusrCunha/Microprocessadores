.data 

.word 

	li $t0, 0x00101000
	slt $t2, $0, $t0
	bne $t2, $0, else
	j done
else:   addi, $t2, $t2, 2
done: