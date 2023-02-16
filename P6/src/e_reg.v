`timescale 1ns / 1ps

`include "constants.v"

module e_reg(
    input clk,
    input reset,
    input Stall,
    input HILO_BUSY,
    input isHILO,

    input [31:0] PC_in,
    input [5:0] op,
    input [5:0] funct,
    input [4:0] shamt_in,

    input ALUSrc_in,
    input [3:0] ALUOP_in,
    input [3:0] HILOtype_in,
    input RegWrite_in,
    input [1:0] MemtoReg_in,
    input [1:0] storeOP_in,
    input [2:0] DextOP_in,

    input [4:0] A1_in,
    input [4:0] A2_in,
    input [31:0] GRF_RD1_in,
    input [31:0] GRF_RD2_in,
    input [4:0] A3_in,
    input [31:0] EXT_Result_in,

    output reg [31:0] PC_out,
    output reg [4:0] shamt_out,
    output reg [1:0] T_new,

    output reg ALUSrc_out,
    output reg [3:0] ALUOP_out,
    output reg [3:0] HILOtype_out,
    output reg RegWrite_out,
    output reg [1:0] MemtoReg_out,
    output reg [1:0] storeOP_out,
    output reg [2:0] DextOP_out,

    output reg [4:0] A1_out,
    output reg [4:0] A2_out,
    output reg [31:0] GRF_RD1_out,
    output reg [31:0] GRF_RD2_out,
    output reg [4:0] A3_out,
    output reg [31:0] EXT_Result_out
    );

    always @(posedge clk) begin
        if (reset | Stall | (HILO_BUSY & isHILO)) begin
            PC_out <= 32'b0;
            shamt_out <= 5'b0;
            T_new <= 2'b0;

            ALUSrc_out <= 1'b0;
            ALUOP_out <= 4'b0;
            HILOtype_out <= 4'd0;
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 2'b0;
            storeOP_out <= 2'd0;
            DextOP_out <= 3'd0;

            A1_out <= 5'b0;
            A2_out <= 5'b0;
            GRF_RD1_out <= 32'b0;
            GRF_RD2_out <= 32'b0;
            A3_out <= 5'b0;
            EXT_Result_out <= 32'b0;
        end
        else begin
            PC_out <= PC_in;
            shamt_out <= shamt_in;
            case (op)
                `op_special: begin
                    case (funct)
                        `funct_add: begin
                            T_new <= 2'd1;
                        end
                        `funct_addu: begin
                            T_new <= 2'd1;
                        end
                        `funct_sub: begin
                            T_new <= 2'd1;
                        end
                        `funct_subu: begin
                            T_new <= 2'd1;
                        end
                        `funct_and: begin
                            T_new <= 2'd1;
                        end
                        `funct_or: begin
                            T_new <= 2'd1;
                        end
                        `funct_slt: begin
                            T_new <= 2'd1;
                        end
                        `funct_sltu: begin
                            T_new <= 2'd1;
                        end
                        `funct_mflo: begin
                            T_new <= 2'd1;
                        end
                        `funct_mfhi: begin
                            T_new <= 2'd1;
                        end
                        default: begin
                            T_new <= 2'd0;
                        end
                    endcase
                end
                `op_addi: begin
                    T_new <= 2'd1;
                end
                `op_addiu: begin
                    T_new <= 2'd1;
                end
                `op_andi: begin
                    T_new <= 2'd1;
                end
                `op_ori: begin
                    T_new <= 2'd1;
                end
                `op_lui: begin
                    T_new <= 2'd0;
                end 
                `op_lw: begin
                    T_new <= 2'd2;
                end
                `op_lh: begin
                    T_new <= 2'd2;
                end
                `op_lb: begin
                    T_new <= 2'd2;
                end
                `op_sw: begin
                    T_new <= 2'd0;
                end
                `op_sh: begin
                    T_new <= 2'd0;
                end
                `op_sb: begin
                    T_new <= 2'd0;
                end
                `op_beq: begin
                    T_new <= 2'd0;
                end
                `op_bne: begin
                    T_new <= 2'd0;
                end
                `op_j: begin
                    T_new <= 2'd0;
                end
                `op_jal: begin
                    T_new <= 2'd0;
                end   
                default: begin
                    T_new <= 2'd0;
                end
            endcase

            ALUSrc_out <= ALUSrc_in;
            ALUOP_out <= ALUOP_in;
            HILOtype_out <= HILOtype_in;
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            storeOP_out <= storeOP_in;
            DextOP_out <= DextOP_in;

            A1_out <= A1_in;
            A2_out <= A2_in;
            GRF_RD1_out <= GRF_RD1_in;
            GRF_RD2_out <= GRF_RD2_in;
            A3_out <= A3_in;
            EXT_Result_out <= EXT_Result_in;
        end
    end

endmodule
