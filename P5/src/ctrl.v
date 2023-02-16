`timescale 1ns / 1ps

`include "constants.v"

module ctrl(
    input [5:0] op,
    input [5:0] funct,
	
    output [1:0] RegDst,
	output [1:0] ExtOP,
    output ALUSrc,
    output [3:0] ALUOP,
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

	wire jr = (op == `op_special) & (funct == `funct_jr);

	wire addi = (op == `op_addi);
	wire addiu = (op == `op_addiu);
	wire andi = (op == `op_andi);
	wire ori = 	(op == `op_ori);
	wire lui = (op == `op_lui);

	wire lw = (op == `op_lw);
	wire lh = (op == `op_lh);
	wire lb = (op == `op_lb);

	wire sw = (op == `op_sw);
	wire sh = (op == `op_sh);
	wire sb = (op == `op_sb);

	wire beq = 	(op == `op_beq);
	wire bne = 	(op == `op_bne);
	wire j = 	(op == `op_j);
	wire jal = (op == `op_jal);

// control signal
	assign RegDst = (add | addu | sub | subu | and_ | or_ | slt | sltu) ? `RegDst_rd :
					(jal) ? `RegDst_ra : 
					`RegDst_rt;

	assign ExtOP = (addi | addiu | lw | lh | lb | sw | sh | sb | beq | bne) ? `ext_sign :
				   (lui) ? `ext_high :
				   `ext_zero;

	assign ALUSrc = (addi | addiu | andi | ori | lw | lh | lb | sw | sh | sb | lui) ? 1'b1 :
					1'b0;

	assign ALUOP = 	(sub | subu) ? `alu_sub :
					(and_ | andi) ? `alu_and :
				   	(or_ | ori) ? `alu_or :
					(slt) ? `alu_slt :
					(sltu) ? `alu_sltu :
				   	`alu_add;

	assign RegWrite = (add | addu | sub | subu | and_ | or_ | slt | sltu | addi | addiu | andi | ori | lw | lh | lb | lui | jal) ? 1'b1 : 1'b0;

	assign MemtoReg = (lw | lh | lb) ? 2'd1 :
					  (jal) ? 2'd2 :
					  2'd0;

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
						(addi | addiu | andi | ori | lw | lh | lb | sw | sh | sb) ? 2'd1 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu) ? 2'd1 :
						2'd3;

	assign T_use_rt =	(beq | bne) ? 2'd0 :
						(add | addu | sub | subu | and_ | or_ | slt | sltu) ? 2'd1 :
						(sw | sh | sb) ? 2'd2 :
						2'd3;

endmodule
