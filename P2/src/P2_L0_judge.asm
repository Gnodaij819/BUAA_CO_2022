.data

String: .space 80

.macro scanfInteger(%i)
    li $v0, 5
    syscall
    move %i, $v0
.end_macro

.macro scanfChar(%i)
    li $v0, 12
    syscall
    move %i, $v0
.end_macro

.macro getIndex(%ans, %i)
    move %ans, %i
    sll %ans, %ans, 2
.end_macro

.macro end
    li $v0, 10
    syscall
.end_macro

.text

########## read n ############
scanfInteger($s0)            # s0 is n
div $s1, $s0, 2              # times of judge
#############################
########## read String ######
li $t0, 0                    # use t0 as i
in_c:
beq $t0, $s0, in_c_end       # end when t0 == n
scanfChar($t1)               # scanf char
getIndex($t2, $t0)
sw $t1, String($t2)
addi $t0, $t0, 1
j in_c

in_c_end:
################################
li $t0, 0
move $t1, $s0
sub $t1, $t1, 1

judge:
beq $t0, $s1, judge_end
getIndex($t2, $t0)
lw $s2, String($t2)
getIndex($t3, $t1)
lw $s3, String($t3)
bne $s2, $s3, error
addi $t0, $t0, 1
sub $t1, $t1, 1
j judge


error:
li $a0, 0
li $v0, 1
syscall
end

judge_end:
li $a0, 1
li $v0, 1
syscall
end
