.data

matrix1: .space 400
matrix2: .space 400
space: .asciiz " "
enter: .asciiz  "\n"

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
    la $a0, space
    li $v0, 4
    syscall
.end_macro

.macro printEnter
    la $a0, enter
    li $v0, 4
    syscall
.end_macro

.macro getIndex(%ans, %i, %j, %row)     # get (i * n + j) * 4
    mult %i, %row
    mflo %ans
    add %ans, %ans, %j
    sll %ans, %ans, 2
.end_macro

.text

scanfInteger($s0)             # s0 is m1
scanfInteger($s1)             # s1 is n1
scanfInteger($s2)             # s2 is m2
scanfInteger($s3)             # s3 is n2
sub $s4, $s0, $s2
addi $s4, $s4, 1                   # s4 is m1 - m2 + 1
sub $s5, $s1, $s3
addi $s5, $s5, 1                   # s5 is n1 - n2 + 1

################# read matrix1 #################
li $t0, 0                     # use t0 as i

in1_i:
beq $t0, $s0, in1_i_end       # end when t0 == m1
li $t1, 0                     # use t1 as j

in1_j:
beq $t1, $s1, in1_j_end       # end when t1 == n1
scanfInteger($t2)
getIndex($t3, $t0, $t1, $s1)
sw $t2, matrix1($t3)
addi $t1, $t1, 1
j in1_j

in1_j_end:
addi $t0, $t0, 1
j in1_i

in1_i_end:
##################################################
#################### read matrix2 ################
li $t0, 0                     # use t0 as i

in2_i:
beq $t0, $s2, in2_i_end       # end when t0 == m2
li $t1, 0                     # use t1 as j

in2_j:
beq $t1, $s3, in2_j_end       # end when t1 == n2
scanfInteger($t2)
getIndex($t3, $t0, $t1, $s3)
sw $t2, matrix2($t3)
addi $t1, $t1, 1
j in2_j

in2_j_end:
addi $t0, $t0, 1
j in2_i

in2_i_end:
#################################################
li $t0, 0                     # use t0 as i

get_i:
beq $t0, $s4, get_i_end        # end when t0 == m1 - m2 + 1 
li $t1, 0                      # use t1 as j

get_j:
beq $t1, $s5, get_j_end        # end when t1 == n1 - n2 + 1
li $s6, 0                      # s6 is g(i,j)
################## get g(i,j) ##################
li $t2, 0                      # use t2 as k

get_k:
beq $t2, $s2, get_k_end

li $t3, 0                      # use t3 as l

get_l:
beq $t3, $s3, get_l_end
add $t4, $t0, $t2              # use t4 as i + k
add $t5, $t1, $t3              # use t5 as j + l
getIndex($s7, $t4, $t5, $s1)
lw $t6, matrix1($s7)
getIndex($s7, $t2, $t3, $s3)
lw $t7, matrix2($s7)
mult $t6, $t7
mflo $s7
add $s6, $s6, $s7
addi $t3, $t3, 1
j get_l

get_l_end:
addi $t2, $t2, 1
j get_k

get_k_end:
printInteger($s6)
addi $t1, $t1, 1
j get_j

get_j_end:
printEnter
addi $t0, $t0, 1
j get_i

get_i_end:
end
