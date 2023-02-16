`timescale 1ns / 1ps

module w_reg(
    input clk,
    input reset,
    input Req,

    input [31:0] PC_in,
    input [1:0] T_new_in,

    input RegWrite_in,
    input [2:0] MemtoReg_in,

    input [4:0] A3_in,
    input [31:0] ALU_C_in,
    input [31:0] HILO_in,
    input [31:0] DM_RD_in,
    input [31:0] CP0_RD_in,

    output reg [31:0] PC_out,
    output reg [1:0] T_new_out,

    output reg RegWrite_out,
    output reg [2:0] MemtoReg_out,

    output reg [4:0] A3_out,
    output reg [31:0] ALU_C_out,
    output reg [31:0] HILO_out,
    output reg [31:0] DM_RD_out,
    output reg [31:0] CP0_RD_out
    );

    always @(posedge clk) begin
        if (reset | Req) begin
            PC_out <= 32'b0;
            T_new_out <= 2'd0;

            MemtoReg_out <= 3'b0;
            RegWrite_out <= 1'b0;

            A3_out <= 5'b0;
            ALU_C_out <= 32'b0;
            HILO_out <= 32'b0;
            DM_RD_out <= 32'b0;
            CP0_RD_out <= 32'b0;
        end
        else begin
            PC_out <= PC_in;
            T_new_out <= (T_new_in == 2'd0) ? T_new_in : T_new_in - 2'd1;

            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;

            A3_out <= A3_in;
            ALU_C_out <= ALU_C_in;
            HILO_out <= HILO_in;
            DM_RD_out <= DM_RD_in;
            CP0_RD_out <= CP0_RD_in;
        end
    end

endmodule
