.data

ans: .space 4000

.macro end
    li $v0, 10
    syscall
.end_macro

.macro scanfInteger(%i)
    li $v0, 5
    syscall
    move %i, $v0
.end_macro

.macro printInteger(%i)
	move $a0, %i
	li $v0, 1
	syscall
.end_macro

.macro getIndex(%ans, %i)
    move %ans, %i
    sll %ans, %ans, 2
.end_macro

.text
scanfInteger($s0)
# int digit = 0
li $s1, 0                # use s1 as digit
# int carry = 0
li $s2, 0                # use s2 as carry
# int s3 = 10
li $s3, 10
# ans[0] = 1
getIndex($t2, $s1)
li $v0, 1                
sw $v0, ans($t2)
#######################################################
li $t0, 2                # use t0 as i
loop:
slt $t2, $s0, $t0        # t2 = (n < i) ? 1 : 0
bne $t2, $zero, print

li $t1, 0                # use t1 as j
cal:
slt $t2, $s1, $t1        # t2 = (digit < j) ? 1 : 0
bne $t2, $zero, carry

# tmp = ans[j] * i + carry
getIndex($t2, $t1)
lw $t3, ans($t2)
mult $t3, $t0
mflo $t3
add $t3, $t3, $s2
# s[j] = tmp % 10
div $t3, $s3
mfhi $t3
sw $t3, ans($t2)
# carry = tmp / 10
mflo $s2
addi $t1, $t1, 1
j cal

carry:
beq $s2, $zero, carry_end
# ans[j] = carry % 10
div $s2, $s3
mfhi $t3
getIndex($t2, $t1)
sw $t3, ans($t2)
# carry = carry / 10
mflo $s2
# j++
addi $t1, $t1, 1
j carry

carry_end:
# digit = j - 1
addi $s1, $t1, -1
# i++
addi $t0, $t0, 1
j loop

print:
# i = digit
move $t0, $s1
print_begin:
bltz $t0, print_end
getIndex($t1, $t0)
lw $t2, ans($t1)
printInteger($t2)
# i--
addi $t0, $t0, -1
j print_begin

print_end:
end

