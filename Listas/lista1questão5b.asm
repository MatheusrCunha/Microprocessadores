.data

.text
	li $t0, 0xaaaaaaaa
	li $t1, 0x12345678
	srl $t2, $t1, 3
	andi $t2, $t2, 0xFFEF

# Resposta = $t2 = 0x00008acf