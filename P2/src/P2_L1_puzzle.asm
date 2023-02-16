.data

puzzle: .word 0 : 49

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

.macro getIndex(%ans, %i, %j)     # get (i * m + j) * 4
    mult %i, $s1
    mflo %ans
    add %ans, %ans, %j
    sll %ans, %ans, 2
.end_macro

.macro push(%src)
    sw %src, 0($sp)
    addi $sp, $sp, -4
.end_macro

.macro pop(%des)
    addi $sp, $sp, 4
    lw %des, 0($sp) 
.end_macro

.macro assign2(%i, %j)
    mult %i, $s1
    mflo $t7
    add $t7, $t7, %j
    sll $t7, $t7, 2
    li $t8, 2
    sw $t8, puzzle($t7)
.end_macro

.macro assign0(%i, %j)
    mult %i, $s1
    mflo $t7
    add $t7, $t7, %j
    sll $t7, $t7, 2
    sw $zero, puzzle($t7)
.end_macro

.text
# s0 = n
scanfInteger($s0)
# s1 = m
scanfInteger($s1)
################# read puzzle #########################
li $t0, 0                     # use t0 as i

in_i:
beq $t0, $s0, in_i_end        # end when t0 == n
li $t1, 0                     # use t1 as j

in_j:
beq $t1, $s1, in_j_end        # end when t1 == m
scanfInteger($t2)
getIndex($t3, $t0, $t1)
sw $t2, puzzle($t3)
addi $t1, $t1, 1
j in_j

in_j_end:
addi $t0, $t0, 1
j in_i

in_i_end:
################## read start and end #################
# s2 = startx - 1
scanfInteger($s2)
addi $s2, $s2, -1
# s3 = starty - 1
scanfInteger($s3)
addi $s3, $s3, -1
# s4 = endx - 1
scanfInteger($s4)
addi $s4, $s4, -1
# s5 = endy - 1
scanfInteger($s5)
addi $s5, $s5, -1
################### main ###################
move $s6, $zero
move $a0, $s2
move $a1, $s3
jal Puzzle

printInteger($s6)
end
######################################
################### Puzzle Function ###################
Puzzle:
push($ra)
push($t1)
push($t0)

move $t0, $a0
move $t1, $a1
################### i == endx - 1 ? ##############
bne $t0, $s4, judge_end       # i != endx go to judge_end
judge:
beq $t1, $s5, getRoad         # j == endy go to getRoad
j judge_end
getRoad:
addi $s6, $s6, 1
j Puzzle_end

judge_end:
######################################
ifGoUp:
addi $t2, $t0, -1             # t2 = i - 1
slt $t3, $t2, $zero           # t3 = (i - 1 >= 0) 0 : 1
beq $t3, $zero, isPassageUp
j ifGoDown

isPassageUp:
getIndex($t3, $t2, $t1)
lw $t3, puzzle($t3)
beq $t3, $zero, goUp
j ifGoDown

goUp:
# puzzle[i][j] = 2
assign2($t0, $t1)
# dfs(i - 1, j)
move $a0, $t2
move $a1, $t1
jal Puzzle
# puzzle[i][j] = 0
assign0($t0, $t1)
##############################################
ifGoDown:
addi $t2, $t0, 2              # t2 = i + 2
slt $t3, $s0, $t2             # t3 = (n >= i + 2) 0 : 1
beq $t3, $zero, isPassageDown
j ifGoLeft

isPassageDown:
addi $t2, $t2, -1             # t2 = i + 1
getIndex($t3, $t2, $t1)
lw $t3, puzzle($t3)
beq $t3, $zero, goDown
j ifGoLeft

goDown:
# puzzle[i][j] = 2
assign2($t0, $t1)
# dfs(i + 1, j)
move $a0, $t2
move $a1, $t1
jal Puzzle
# puzzle[i][j] = 0
assign0($t0, $t1)
#####################################################
ifGoLeft:
addi $t2, $t1, -1               # t2 = j - 1
slt $t3, $t2, $zero             # t3 = (j - 1 >= 0) 0 : 1
beq $t3, $zero, isPassageLeft
j ifGoRight

isPassageLeft:
getIndex($t3, $t0, $t2)
lw $t3, puzzle($t3)
beq $t3, $zero, goLeft
j ifGoRight

goLeft:
# puzzle[i][j] = 2
assign2($t0, $t1)
# dfs(i, j - 1)
move $a0, $t0
move $a1, $t2
jal Puzzle
# puzzle[i][j] = 0
assign0($t0, $t1)
#####################################################
ifGoRight:
addi $t2, $t1, 2                # t2 = j + 2
slt $t3, $s1, $t2               # t3 = (j + 2 <= m) ? 0 : 1
beq $t3, $zero, isPassageRight
j Puzzle_end

isPassageRight:
addi $t2, $t2, -1
getIndex($t3, $t0, $t2)
lw $t3, puzzle($t3)
beq $t3, $zero, goRight
j Puzzle_end

goRight:
# puzzle[i][j] = 2
assign2($t0, $t1)
# dfs(i, j + 1)
move $a0, $t0
move $a1, $t2
jal Puzzle
# puzzle[i][j] = 0
assign0($t0, $t1)
#####################################################
Puzzle_end:
pop($t0)
pop($t1)
pop($ra)
jr $ra