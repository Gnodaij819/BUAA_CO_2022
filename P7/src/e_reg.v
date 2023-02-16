`timescale 1ns / 1ps

`include "constants.v"

module e_reg(
    input clk,
    input reset,
    input Req,
    input Stall,

    input [31:0] PC_in,
    input [31:0] instr_in,

    input ALUSrc_in,
    input [3:0] ALUOP_in,
    input [3:0] HILOtype_in,
    input RegWrite_in,
    input [2:0] MemtoReg_in,
    input [1:0] storeOP_in,
    input [2:0] DextOP_in,
    input load_in,
    input store_in,

    input [4:0] A1_in,
    input [4:0] A2_in,
    input [4:0] rd_in,
    input [31:0] GRF_RD1_in,
    input [31:0] GRF_RD2_in,
    input [4:0] A3_in,
    input [31:0] EXT_Result_in,

    input isBD_in,
    input mfc0_in,
    input mtc0_in,
    input eret_in,

    input ALUAri_in,
    input ALUDM_in,

    input [4:0] ExcCode_in,

    output reg [31:0] PC_out,
    output reg [31:0] instr_out,
    output reg [1:0] T_new,

    output reg ALUSrc_out,
    output reg [3:0] ALUOP_out,
    output reg [3:0] HILOtype_out,
    output reg RegWrite_out,
    output reg [2:0] MemtoReg_out,
    output reg [1:0] storeOP_out,
    output reg [2:0] DextOP_out,
    output reg load_out,
    output reg store_out,

    output reg [4:0] A1_out,
    output reg [4:0] A2_out,
    output reg [4:0] rd_out,
    output reg [31:0] GRF_RD1_out,
    output reg [31:0] GRF_RD2_out,
    output reg [4:0] A3_out,
    output reg [31:0] EXT_Result_out,

    output reg isBD_out,
    output reg mfc0_out,
    output reg mtc0_out,
    output reg eret_out,

    output reg ALUAri_out,
    output reg ALUDM_out,

    output reg [4:0] ExcCode_out
    );

    wire [5:0] op = instr_in[31:26];
    wire [5:0] funct = instr_in[5:0];

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
	wire lhu = (op == `op_lhu);
	wire lb = (op == `op_lb);
	wire lbu = (op == `op_lbu);

	wire load = lw | lh | lhu | lb | lbu;

	wire sw = (op == `op_sw);
	wire sh = (op == `op_sh);
	wire sb = (op == `op_sb);

	wire store = sw | sh | sb;

	wire beq = 	(op == `op_beq);
	wire bne = 	(op == `op_bne);
	wire j = 	(op == `op_j);
	wire jal = (op == `op_jal);

	wire mfc0 = (instr_in[31:21] == `op_mfc0);
	wire mtc0 = (instr_in[31:21] == `op_mtc0);
	wire eret = (instr_in == `op_eret);
	wire syscall = (op == `op_special && funct == `funct_syscall);

	wire nop = (instr_in == 32'h0);


    always @(posedge clk) begin
        if (reset | Stall | Req) begin
            //PC_out <= Stall ? PC_in : (Req ? 32'h0000_4180 : 32'b0);
            //PC_out <= Req ? 32'h0000_4180 : (Stall ? PC_in : 32'b0);
            PC_out <= reset ? 32'b0 : (Req ? 32'h0000_4180 : PC_in);
            instr_out <= 32'b0;
            T_new <= 2'b0;

            ALUSrc_out <= 1'b0;
            ALUOP_out <= 4'b0;
            HILOtype_out <= 4'd0;
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 3'b0;
            storeOP_out <= 2'd0;
            DextOP_out <= 3'd0;
            load_out <= 1'b0;
            store_out <= 1'b0;

            A1_out <= 5'b0;
            A2_out <= 5'b0;
            rd_out <= 5'd0;
            GRF_RD1_out <= 32'b0;
            GRF_RD2_out <= 32'b0;
            A3_out <= 5'b0;
            EXT_Result_out <= 32'b0;

            isBD_out <= Stall ? isBD_in : 1'b0;
            mfc0_out <= 1'b0;
            mtc0_out <= 1'b0;
            eret_out <= 1'b0;

            ALUAri_out <= 1'b0;
            ALUDM_out <= 1'b0;

            ExcCode_out <= 5'd0;
        end
        else begin
            PC_out <= PC_in;
            instr_out <= instr_in;
            if (mult | multu | div | divu | mtlo | mthi | jr | lui | store | beq | bne | j | jal | mtc0 | eret | syscall) begin
                T_new <= 2'd0;
            end else if (add | addu | sub | subu | and_ | or_ | slt | sltu | mflo | mfhi | addi | addiu | andi | ori) begin
                T_new <= 2'd1;
            end else if (load | mfc0) begin
                T_new <= 2'd2;
            end else begin
                T_new <= 2'd3;
            end


            // case (op)
            //     `op_special: begin
            //         case (funct)
            //             `funct_add: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_addu: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_sub: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_subu: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_and: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_or: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_slt: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_sltu: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_mflo: begin
            //                 T_new <= 2'd1;
            //             end
            //             `funct_mfhi: begin
            //                 T_new <= 2'd1;
            //             end
            //             default: begin
            //                 T_new <= 2'd0;
            //             end
            //         endcase
            //     end
            //     `op_addi: begin
            //         T_new <= 2'd1;
            //     end
            //     `op_addiu: begin
            //         T_new <= 2'd1;
            //     end
            //     `op_andi: begin
            //         T_new <= 2'd1;
            //     end
            //     `op_ori: begin
            //         T_new <= 2'd1;
            //     end
            //     `op_lui: begin
            //         T_new <= 2'd0;
            //     end 
            //     `op_lw: begin
            //         T_new <= 2'd2;
            //     end
            //     `op_lh: begin
            //         T_new <= 2'd2;
            //     end
            //     `op_lhu: begin
            //         T_new <= 2'd2;
            //     end
            //     `op_lb: begin
            //         T_new <= 2'd2;
            //     end
            //     `op_lbu: begin
            //         T_new <= 2'd2;
            //     end
            //     `op_sw: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_sh: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_sb: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_beq: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_bne: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_j: begin
            //         T_new <= 2'd0;
            //     end
            //     `op_jal: begin
            //         T_new <= 2'd0;
            //     end   
            //     default: begin
            //         T_new <= 2'd2;
            //     end
            // endcase

            ALUSrc_out <= ALUSrc_in;
            ALUOP_out <= ALUOP_in;
            HILOtype_out <= HILOtype_in;
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            storeOP_out <= storeOP_in;
            DextOP_out <= DextOP_in;
            load_out <= load_in;
            store_out <= store_in;

            A1_out <= A1_in;
            A2_out <= A2_in;
            rd_out <= rd_in;
            GRF_RD1_out <= GRF_RD1_in;
            GRF_RD2_out <= GRF_RD2_in;
            A3_out <= A3_in;
            EXT_Result_out <= EXT_Result_in;

            isBD_out <= isBD_in;
            mfc0_out <= mfc0_in;
            mtc0_out <= mtc0_in;
            eret_out <= eret_in;

            ALUAri_out <= ALUAri_in;
            ALUDM_out <= ALUDM_in;

            ExcCode_out <= ExcCode_in;
        end
    end

endmodule
