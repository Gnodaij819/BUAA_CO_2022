.data
matrix1: .space 256
matrix2: .space 256
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

.macro getIndex(%ans, %i, %j)     # get (i * n + j) * 4
    mult %i, $s0
    mflo %ans
    add %ans, %ans, %j
    sll %ans, %ans, 2
.end_macro

.text
################# scanf n ######################
scanfInteger($s0)             # s0 is n
################################################
################# read matrix1 #################
li $t0, 0                     # use t0 as i

in1_i:
beq $t0, $s0, in1_i_end       # end when t0 == n
li $t1, 0                     # use t1 as j

in1_j:
beq $t1, $s0, in1_j_end       # end when t1 == n
scanfInteger($t2)
getIndex($t3, $t0, $t1)
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
beq $t0, $s0, in2_i_end       # end when t0 == n
li $t1, 0                     # use t1 as j

in2_j:
beq $t1, $s0, in2_j_end       # end when t1 == n
scanfInteger($t2)
getIndex($t3, $t0, $t1)
sw $t2, matrix2($t3)
addi $t1, $t1, 1
j in2_j

in2_j_end:
addi $t0, $t0, 1
j in2_i

in2_i_end:
#################################################

li $t0, 0                      # use t0 as i

get_i:
beq $t0, $s0, get_i_end        # end when t0 == n
li $t1, 0                      # use t1 as j

get_j:
beq $t1, $s0, get_j_end        # end when t1 == n

################## get c(i,j) ##################
li $t2, 0                      # use t2 as k
li $s4, 0                      # s4 is c(i,j)

get_value:
beq $t2, $s0, get_value_end
getIndex($t3, $t0, $t2)
lw $s1, matrix1($t3)
getIndex($t3, $t2, $t1)
lw $s2, matrix2($t3)
mult $s1, $s2
mflo $s3
add $s4, $s4, $s3
addi $t2, $t2, 1
j get_value

get_value_end:
printInteger($s4)
addi $t1, $t1, 1
j get_j

get_j_end:
printEnter
addi $t0, $t0, 1
j get_i

get_i_end:

end
