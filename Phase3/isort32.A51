lui $t0 0x1001
addiu $t1 $zero 0x0060
ori $v1 $zero 0xDEAD

here: sw $v1 0x0080($t0)
addi $t1 $t1 -1
addiu $t0 $t0 0x0004
addu $v0 $v1 $v1
xor $v0 $v1 $v0
xori $v1 $v0 0xBEEF
bne $zero $t1 here

addi $t0 $zero 0x0004
addi $t1 $zero 0x0060
addu $t1 $t1 $t1
addu $t1 $t1 $t1

loop: slt $t2 $t0 $t1
beq $t2 $zero stay
add $t3 $zero $t0
lw $t4 0x0080($t0)

goto2: slt $t2 $zero $t3
beq $t2 $zero goto
addi $t5 $t3 -4
lw $t6 0x0080($t5)
sltu $t2 $t6 $t4
beq $t2 $zero goto
sw $t6 0x0080($t3)
addu $t3 $zero $t5
beq $zero $zero goto2

goto: sw $t4 0x0080($t3)
addi $t0 $t0 0x0004
beq $zero $zero loop

stay: beq $zero $zero stay
