`timescale 1ns / 1ps


`define PC_MAX 32'h00006ffc
`define PC_MIN 32'h00003000

// opcode
`define op_special 6'b000000
`define op_special2 6'b011100

`define op_addi 6'b001000
`define op_addiu 6'b001001
`define op_andi 6'b001100
`define op_ori 6'b001101
`define op_lui 6'b001111

`define op_lw 6'b100011
`define op_lh 6'b100001
`define op_lhu 6'b100101
`define op_lb 6'b100000
`define op_lbu 6'b100100

`define op_sw 6'b101011
`define op_sh 6'b101001
`define op_sb 6'b101000

`define op_beq 6'b000100
`define op_bne 6'b000101
`define op_j 6'b000010
`define op_jal 6'b000011

`define op_mfc0 11'b010000_00000
`define op_mtc0 11'b010000_00100
`define op_eret 32'b010000_1_000_0000_0000_0000_0000_011000

// functcode
`define funct_add 6'b100000
`define funct_addu 6'b100001
`define funct_sub 6'b100010
`define funct_subu 6'b100011
`define funct_and 6'b100100
`define funct_or 6'b100101
`define funct_slt 6'b101010
`define funct_sltu 6'b101011

`define funct_mult 6'b011000
`define funct_multu 6'b011001
`define funct_div 6'b011010
`define funct_divu 6'b011011
`define funct_mfhi 6'b010000
`define funct_mflo 6'b010010
`define funct_mthi 6'b010001
`define funct_mtlo 6'b010011

`define funct_madd 6'b000000
`define funct_maddu 6'b000001
`define funct_msub 6'b000100
`define funct_msubu 6'b000101

`define funct_jr 6'b001000

`define funct_syscall 6'b001100

// RegDst
`define RegDst_rt 2'd0
`define RegDst_rd 2'd1
`define RegDst_ra 2'd2

// ExtOp
`define ext_zero 2'd0
`define ext_sign 2'd1
`define ext_high 2'd2

// ALUOP
`define alu_add 4'd0
`define alu_sub 4'd1
`define alu_and 4'd2
`define alu_or 4'd3
`define alu_xor 4'd4
`define alu_slt 4'd5
`define alu_sltu 4'd6

// HILOOP
`define hilo_mult 4'd1
`define hilo_multu 4'd2
`define hilo_div 4'd3
`define hilo_divu 4'd4
`define hilo_mfhi 4'd5
`define hilo_mflo 4'd6
`define hilo_mthi 4'd7
`define hilo_mtlo 4'd8

`define hilo_madd 4'd9
`define hilo_maddu 4'd10
`define hilo_msub 4'd11
`define hilo_msubu 4'd12

// MemtoReg
`define MemtoReg_ALU 3'd0
`define MemtoReg_DM 3'd1
`define MemtoReg_PC 3'd2
`define MemtoReg_HILO 3'd3
`define MemtoReg_CP0 3'd4

// storeOP
`define store_none 2'd0
`define store_sw 2'd1
`define store_sh 2'd2
`define store_sb 2'd3

// dextOP
`define dext_lw 3'd0
`define dext_lbu 3'd1
`define dext_lb 3'd2
`define dext_lhu 3'd3
`define dext_lh 3'd4
`define dext_none 3'd5

// nPC_sel
`define npc_PC4 3'd0
`define npc_j 3'd1
`define npc_jr 3'd2
`define npc_beq 3'd3
`define npc_bne 3'd4
`define npc_eret 3'd5

// ExcCode
`define Exc_Int 5'd0
`define Exc_AdEL 5'd4
`define Exc_AdES 5'd5
`define Exc_Syscall 5'd8
`define Exc_RI 5'd10
`define Exc_Ov 5'd12
`define Exc_None 5'd0

// Addr
`define DM_begin    32'h0000_0000
`define DM_end      32'h0000_2fff
`define IM_begin    32'h0000_3000
`define IM_end      32'h0000_6fff
`define TC1_begin   32'h0000_7f00
`define TC1_end     32'h0000_7f0b
`define TC2_begin   32'h0000_7f10
`define TC2_end     32'h0000_7f1b
`define Int_begin   32'h0000_7f20
`define Int_end     32'h0000_7f23