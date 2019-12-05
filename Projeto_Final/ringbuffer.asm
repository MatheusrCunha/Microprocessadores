.eqv RINGBUFFER_SIZE 4

.macro alloc_ringbuffer (%name)
.data
%name: .space 12
       .space RINGBUFFER_SIZE
.end_macro

#===========================================	
# void rb_init(t_ringbuffer * rbuf)
rb_init:
	sw $zero, 0($a0) #rd
	sw $zero, 4($a0) #wr
	sw $zero, 8($a0) #size
	jr $ra
#===========================================	
# bool rb_empty(t_ringbuffer * rbuf)
rb_empty:
	li $v0, 1
	lw $t0, 8($a0) # $t0 = rbuf->size
	beq $t0, $zero, rb_empty_end
	li $v0, 0
rb_empty_end:
	jr $ra
#===========================================
# bool rb_full(t_ringbuffer * rbuf)
rb_full:
	li $v0, 1
	lw $t0, 8($a0) # $t0 = rbuf->size
	li $t1, RINGBUFFER_SIZE
	beq $t0, $t1, rb_full_end
	li $v0, 0
rb_full_end:
	jr $ra
#===========================================
# Stack
# ra    4 (sp)
# a0    0 (sp)
# ------------------------------------------
# char rb_read(t_ringbuffer * rbuf)
rb_read:
	addi $sp, $sp, -8   # Alocando uma pilha com 8 bytes (4 para a0, 4 para ra)
	sw   $ra, 4($sp)    # Salvo o registrador RA na pilha
	
	jal rb_empty
	bne $v0, $zero, rb_read_empty_true
	
	#rbuf->size--;
	lw   $t0, 8($a0)
	addi $t0, $t0, -1
	sw   $t0, 8($a0)
	
	#tmp = rbuf->buf[rbuf->rd];
	addi $t0, $a0, 12 # t0 = rbuf->buf[]	
	lw   $t1, 0($a0)  # t1 = rbuf->rd
	add  $t0, $t0, $t1
	lb   $v0, 0($t0)   
	
	#rbuf->rd = (rbuf->rd + 1) % MAX_SIZE;
	addi $t1, $t1, 1
	li   $t0, RINGBUFFER_SIZE
	div  $t1, $t0
	mfhi $t1
	sw   $t1, 0($a0)
	
	b    rb_read_end
	
rb_read_empty_true:
	li $v0, 0

rb_read_end:	
	lw   $ra, 4($sp)      # Restauro o valor do RA	
	addi $sp, $sp, 8      # Desaloco a pilha 
	jr $ra
	
#===========================================
# Stack
# ra   4(sp)
# a0   0(sp)
#-------------------------------------------
#bool write(t_ringbuffer * rbuf, char byte)
rb_write:
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	
	jal rb_full
	bne $v0, $zero, rb_write_full_true
	
	#rbuf->size++;
	lw   $t0, 8($a0)
	addi $t0, $t0, 1
	sw   $t0, 8($a0)
	
	# rbuf->buf[rbuf->wr] = byte;
	addi $t0, $a0, 12 # t0 = rbuf->buf[]	
	lw   $t1, 4($a0)  # t1 = rbuf->wr
	add  $t0, $t0, $t1
	sb   $a1, 0($t0)
	
	#rbuf->wr = (rbuf->wr + 1) % MAX_SIZE;
	addi $t1, $t1, 1
	li   $t0, RINGBUFFER_SIZE
	div  $t1, $t0
	mfhi $t1
	sw   $t1, 4($a0)
	
	li   $v0, 1
	b    rb_write_end

rb_write_full_true:
	move $v0, $zero

rb_write_end:
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	jr   $ra

#===========================================