.data

a: .space 160
enter: .asciiz "\n"
plus: .asciiz "+"

.macro end
	li $v0, 10
	syscall
.end_macro

.macro scanfInt(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro printInt(%ans)
	li $v0, 1
	move $a0, %ans
	syscall
.end_macro

.macro printEnter
	la $a0, enter
	li $v0, 4
	syscall
.end_macro

.macro printPlus
	la $a0, plus
	li $v0, 4
	syscall
.end_macro

.macro getIndex(%ans, %i)
	sll %ans, %i, 2
.end_macro

.macro push(%i)
	sw %i, 0($sp)
	addi $sp, $sp, -4
.end_macro

.macro pop(%i)
	addi $sp, $sp, 4
	lw %i, 0($sp)
.end_macro


.text
scanfInt($s0)               # s0 is n
li $t1, 1
move $a0, $s0
move $a1, $t1
jal js
end

js:
push($ra)
push($t0)
push($t1)
push($t2)
push($t3)
push($t4)

move $t0, $a0            	    # use t0 as s
move $t1, $a1			    	# use t1 as t

beq $t0, $zero, print           # if (s == 0) go to print

li $t2, 1               	    # use t2 as i
loop:
slt $t3, $t0, $t2         	    # t3 = (s < i) ? 1 : 0
bne $t3, $zero, loop_end        # end when s < i
addi $t4, $t1, -1        	    # t4 = t - 1
getIndex($t3, $t4)
lw $t3, a($t3)
slt $t3, $t2, $t3        	    # t3 = (i < a[t - 1]) ? 1 : 0
bne $t3, $zero, next
slt $t3, $t2, $s0               # t3 = (i < n) ? 1 : 0
beq $t3, $zero, next
# a[t] = i
getIndex($t3, $t1)
sw $t2, a($t3)
# s = s - i
sub $t0, $t0, $t2
# js(s, t + 1)
addi $t4, $t1, 1                # t4 = t + 1
move $a0, $t0
move $a1, $t4
jal js
# s = s + i
add $t0, $t0, $t2
# i++
addi $t2, $t2, 1
j loop

loop_end:
pop($t4)
pop($t3)
pop($t2)
pop($t1)
pop($t0)
pop($ra)
jr $ra

next:
# i++
addi $t2, $t2, 1
j loop

print:
addi $t4, $t1, -1              # use t4 as t   (t4 = t - 1)
li $t2, 1                      # use t2 as i
print_begin:
beq $t2, $t4, print_end        # end when i = t
getIndex($t3, $t2)
lw $t3, a($t3)
printInt($t3)
printPlus
# i++
addi $t2, $t2, 1
j print_begin

print_end:
getIndex($t3, $t4)
lw $t3, a($t3)
printInt($t3)
printEnter
# int i = 1
li $t2, 1
j loop
