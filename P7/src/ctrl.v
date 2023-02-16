`timescale 1ns / 1ps

`include "constants.v"

module ctrl(
	input [31:0] instr,

    output [1:0] RegDst,
	output [1:0] ExtOP,
    output ALUSrc,
    output [3:0] ALUOP,
	output isHILO,
	output [3:0] HILOtype,
    output RegWrite,
    output [2:0] MemtoReg,
	output [1:0] storeOP,
	output [2:0] DextOP,
	output load,
	output store,
    output [2:0] nPC_sel,
	output [1:0] T_use_rs,
	output [1:0] T_use_rt,

	output mfc0,
	output mtc0,
	output eret,
	output syscall,

	output ALUAri,
	output ALUDM,

	output ErrRI
    );

	wire [5:0] op = instr[31:26];
	wire [5:0] funct = instr[5:0];

// instr
	wire add = 	(op == `op_special) & (funct == `funct_add);
	wire addu = (op == `op_special) & (funct == `funct_addu);
	wire sub = 	(op == `op_special) & (funct == `funct_sub);
	wire subu = (op == `op_special) & (funct == `funct_subu);
	wire and_ = (op == `op_special) & (funct == `funct_and);
	wire or_ = 	(op == `op_special) & (funct == `funct_or);
	wire slt = 	(op == `op_special) & (funct == `funct_slt);
	wire sltu = (op == `op_special) & (funct == `funct_sltu);

	wire mult = (op == `op_special) & (funct == `funct_mult);
	wire multu = (op == `op_special) & (funct == `funct_multu);
	wire div =  (op == `op_special) & (funct == `funct_div);
	wire divu = (op == `op_special) & (funct == `funct_divu);
	wire mfhi = (op == `op_special) & (funct == `funct_mfhi);
	wire mflo = (op == `op_special) & (funct == `funct_mflo);
	wire mthi = (op == `op_special) & (funct == `funct_mthi);
	wire mtlo = (op == `op_special) & (funct == `funct_mtlo);

	wire madd = (op == `op_special2) & (funct == `funct_madd);
	wire maddu = (op == `op_special2) & (funct == `funct_maddu);
	wire msub = (op == `op_special2) & (funct == `funct_msub);
	wire msubu = (op == `op_special2) & (funct == `funct_msubu);

	wire jr = (op == `op_special) & (funct == `funct_jr);

	wire addi = (op == `op_addi);
	wire addiu = (op == `op_addiu);
	wire andi = (op == `op_andi);
	wire ori = 	(op == `op_ori);
	wire lui = (op == `op_lui);

	wire lw = (op == `op_lw);
	wire lh = (op == `op_lh);
	wire lhu = (op == `op_lhu);
	wire lb = (op == `op_lb);
	wire lbu = (op == `op_lbu);

	assign load = lw | lh | lhu | lb | lbu;

	wire sw = (op == `op_sw);
	wire sh = (op == `op_sh);
	wire sb = (op == `op_sb);

	assign store = sw | sh | sb;

	wire beq = 	(op == `op_beq);
	wire bne = 	(op == `op_bne);
	wire j = 	(op == `op_j);
	wire jal = (op == `op_jal);

	assign mfc0 = (instr[31:21] == `op_mfc0);
	assign mtc0 = (instr[31:21] == `op_mtc0);
	assign eret = (instr == `op_eret);
	assign syscall = (op == `op_special && funct == `funct_syscall);

	wire nop = (instr == 32'h0);

	assign ALUAri = add | addi | sub;
	assign ALUDM = load | store;

	assign ErrRI = !(add | addu | sub | subu | and_ | or_ | slt | sltu | 
						mult | multu | div | divu | mfhi | mflo | mthi | mtlo | madd | maddu | msub | msubu |
						jr | addi | addiu | andi | ori | lui | load | store | beq | bne | j | jal |
						mfc0 | mtc0 | eret | syscall | nop);

// control signal
	assign RegDst = (add | addu | sub | subu | and_ | or_ | slt | sltu | mfhi | mflo) ? `RegDst_rd :
					(jal) ? `RegDst_ra : 
					`RegDst_rt;

	assign ExtOP = (addi | addiu | load | store | beq | bne) ? `ext_sign :
				   (lui) ? `ext_high :
				   `ext_zero;

	assign ALUSrc = (addi | addiu | andi | ori | load | store | lui) ? 1'b1 :
					1'b0;

	assign ALUOP = 	(sub | subu) ? 	`alu_sub :
					(and_ | andi) ? `alu_and :
				   	(or_ | ori) ? 	`alu_or :
					(slt) ? 		`alu_slt :
					(sltu) ? 		`alu_sltu :
				   	`alu_add;

    assign isHILO = mult | multu | div | divu | mfhi | mflo | mthi | mtlo | madd | maddu | msub | msubu;

	assign HILOtype = 	(mult) ? 	`hilo_mult :
						(multu) ? 	`hilo_multu :
						(div) ? 	`hilo_div :
						(divu) ? 	`hilo_divu :
						(mfhi) ? 	`hilo_mfhi :
						(mflo) ? 	`hilo_mflo :
						(mthi) ? 	`hilo_mthi :
						(mtlo) ? 	`hilo_mtlo :
						(madd) ?	`hilo_madd :
						(maddu) ? 	`hilo_maddu :
						(msub) ? 	`hilo_msub :
						(msubu) ?	`hilo_msubu :
						4'd0;

	assign RegWrite = (add | addu | sub | subu | and_ | or_ | slt | sltu | mfhi | mflo | addi | addiu | andi | ori | load | lui | jal | mfc0) ? 1'b1 : 1'b0;

	assign MemtoReg = (load) ? `MemtoReg_DM :
					  (jal) ? `MemtoReg_PC :
					  (mfhi | mflo) ? `MemtoReg_HILO :
					  (mfc0) ? `MemtoReg_CP0 :
					  `MemtoReg_ALU;

	assign storeOP =	(sw) ? `store_sw :
						(sh) ? `store_sh :
						(sb) ? `store_sb :
						`store_none;

	assign DextOP = (lb) ? `dext_lb :
					(lbu) ? `dext_lbu :
					(lh) ? `dext_lh :
					(lhu) ? `dext_lhu :
					(lw) ? `dext_lw :
					`dext_none;

	assign nPC_sel = 	(beq) ? `npc_beq :
						(bne) ? `npc_bne :
					 	(jal | j) ? `npc_j :
					 	(jr) ? `npc_jr :
						(eret) ? `npc_eret :
					 	`npc_PC4;

	assign T_use_rs = 	(beq | bne | jr) ? 2'd0 :
						(addi | addiu | andi | ori | load | store) ? 2'd1 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu | mult | multu | div | divu | mthi | mtlo | madd | maddu | msub | msubu) ? 2'd1 :
						2'd3;

	assign T_use_rt =	(beq | bne) ? 2'd0 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu | mult | multu | div | divu | madd | maddu | msub | msubu) ? 2'd1 :
						(store | mtc0) ? 2'd2 :
						2'd3;

endmodule
