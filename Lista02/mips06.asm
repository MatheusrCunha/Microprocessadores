#Asssuma que $t0 = 0x00101000. Qual é o valor de $t2 após as seguintes instruções?
# slt $t2, $0, $t0
# bne $t2, $0, else
# j done
# else: addi $t2, $t2, 2
# done:

.text
	li $t0, 0x00101000 
	slt $t2, $0, $t0
	bne $t2, $0, else
	j done
else:
	addi $t2, $t2, 2
done:
	#resposta = $t2 = 3