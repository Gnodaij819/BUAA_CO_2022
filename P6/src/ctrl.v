`timescale 1ns / 1ps

`include "constants.v"

module ctrl(
    input [5:0] op,
    input [5:0] funct,

    output [1:0] RegDst,
	output [1:0] ExtOP,
    output ALUSrc,
    output [3:0] ALUOP,
	output isHILO,
	output [3:0] HILOtype,
    output RegWrite,
    output [1:0] MemtoReg,
	output [1:0] storeOP,
	output [2:0] DextOP,
    output [2:0] nPC_sel,
	output [1:0] T_use_rs,
	output [1:0] T_use_rt
    );
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

	wire jr = (op == `op_special) & (funct == `funct_jr);

	wire addi = (op == `op_addi);
	wire addiu = (op == `op_addiu);
	wire andi = (op == `op_andi);
	wire ori = 	(op == `op_ori);
	wire lui = (op == `op_lui);

	wire lw = (op == `op_lw);
	wire lh = (op == `op_lh);
	wire lb = (op == `op_lb);

	wire load = lw | lh | lb;

	wire sw = (op == `op_sw);
	wire sh = (op == `op_sh);
	wire sb = (op == `op_sb);

	wire store = sw | sh | sb;

	wire beq = 	(op == `op_beq);
	wire bne = 	(op == `op_bne);
	wire j = 	(op == `op_j);
	wire jal = (op == `op_jal);

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

    assign isHILO = mult | multu | div | divu | mfhi | mflo | mthi | mtlo;

	assign HILOtype = 	(mult) ? 	`hilo_mult :
						(multu) ? 	`hilo_multu :
						(div) ? 	`hilo_div :
						(divu) ? 	`hilo_divu :
						(mfhi) ? 	`hilo_mfhi :
						(mflo) ? 	`hilo_mflo :
						(mthi) ? 	`hilo_mthi :
						(mtlo) ? 	`hilo_mtlo :
						4'd0;

	assign RegWrite = (add | addu | sub | subu | and_ | or_ | slt | sltu | mfhi | mflo | addi | addiu | andi | ori | load | lui | jal) ? 1'b1 : 1'b0;

	assign MemtoReg = (load) ? `MemtoReg_DM :
					  (jal) ? `MemtoReg_PC :
					  (mfhi | mflo) ? `MemtoReg_HILO :
					  `MemtoReg_ALU;

	assign storeOP =	(sw) ? `store_sw :
						(sh) ? `store_sh :
						(sb) ? `store_sb :
						`store_none;

	assign DextOP = (lb) ? `dext_lb :
					(lh) ? `dext_lh :
					`dext_lw;

	assign nPC_sel = 	(beq) ? `npc_beq :
						(bne) ? `npc_bne :
					 	(jal | j) ? `npc_j :
					 	(jr) ? `npc_jr :
					 	`npc_PC4;

	assign T_use_rs = 	(beq | bne | jr) ? 2'd0 :
						(addi | addiu | andi | ori | load | store) ? 2'd1 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu | mult | multu | div | divu | mthi | mtlo) ? 2'd1 :
						2'd3;

	assign T_use_rt =	(beq | bne) ? 2'd0 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu | mult | multu | div | divu) ? 2'd1 :
						(store) ? 2'd2 :
						2'd3;

endmodule
