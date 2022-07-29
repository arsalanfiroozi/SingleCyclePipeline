addi $sp, $0, 0
addi $t0, $0, 1
addi $t1, $0, 1
addi $t3, $0, 15
loop: sw $t1, 64($sp)
addi $sp, $sp, 4
add $t2, $t1, $t0
add $t0, $t1, 0
add $t1, $t2, 0
addi $t3, $t3, -1
beq $t3, $0, done
beq $0, $0, loop
done: beq $0, $0, done