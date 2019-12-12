
.data

.text
	li $t0, 0xAAAAAAAA
	li $t1, 0x12345678
	sll $t2, $t0, 4
	addi $t2, $t2, -1
	
	
	
#  Resposta = $t2 = 0xaaaaaa9f
	