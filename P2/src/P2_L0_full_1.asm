.data

symbol: .space 28
array: .space 28

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

.macro getIndex(%ans, %i)
    move %ans, %i
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

.text
# scanf("%d", &n)
scanfInteger($s0)             # s0 is n

li $t0, 0                     # use t0 as index
move $a0, $t0
jal FullArray
end

############### FullArray Function ###############
FullArray:
push($ra)
push($t0)
push($t1)

move $t0, $a0
############################
slt $s1, $t0, $s0             # s1 = (index < n) ? 1 : 0
beq $s1, $zero, print         # if (index >= n) go to print
# i = 0
li $t1, 0                     # use t1 as i
loop:
beq $t1, $s0, FullArray_end   # end when i == n
getIndex($t2, $t1)
lw $t3, symbol($t2)           # t3 = symbol[i]
beq $t3, $zero, if_symbol     # if (symbol[i] == 0) go to if_symbol

if_symbol_end:
# i++
addi $t1, $t1, 1
j loop

############################
FullArray_end:
pop($t1)
pop($t0)
pop($ra)

jr $ra
##################################################
if_symbol:
# array[index] = i + 1
addi $t3, $t1, 1              # t3 = i + 1
getIndex($t2, $t0)
sw $t3, array($t2)            # array[index] = t3
# symbol[i] = 1
li $t3, 1                     # t3 = 1
getIndex($t2, $t1)
sw $t3, symbol($t2)           # symbol[i] = t3
# FullArray(index + 1)
addi $a0, $t0, 1
jal FullArray
# symbol[i] = 0
getIndex($t2, $t1)
sw $zero, symbol($t2)         # symbol[i] = 0
j if_symbol_end

print:
# i = 0
li $t1, 0                     # use t1 as i
print_begin:
beq $t1, $s0, print_end       # end when i == n
# printf("%d ", array[i])
getIndex($t2, $t1)
lw $t3, array($t2)
printInteger($t3)
# i++
addi $t1, $t1, 1
j print_begin

print_end:
printEnter
j FullArray_end
