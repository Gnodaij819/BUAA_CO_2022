`timescale 1ns / 1ps

`include "constants.v"

module d_reg(
    input clk,
    input reset,
    input Req,
    input Stall,
    input flush,

    input [31:0] instr_in,
    input [31:0] PC_in,
    input [4:0] ExcCode_in,
    input isBD_in,
    
    output reg [31:0] instr_out,
    output reg [31:0] PC_out,
    output reg [4:0] ExcCode_out,
    output reg isBD_out
    );

    always @(posedge clk) begin
        if (reset | (flush && (~Stall)) | Req) begin
            instr_out <= 32'b0;
            //PC_out <= (Req) ? 32'h0000_4180 : 32'b0;
            //PC_out <= (Req) ? 32'h0000_4180 : (flush ? PC_in : 32'b0);
            PC_out <= reset ? 32'b0 : (Req ? 32'h0000_4180 : PC_in);
            ExcCode_out <= `Exc_None;
            isBD_out <= 1'b0;
        end
        else if (Stall) begin
            instr_out <= instr_out;
            PC_out <= PC_out;
            ExcCode_out <= ExcCode_out;
            isBD_out <= isBD_out;
        end
        else begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            ExcCode_out <= ExcCode_in;
            isBD_out <= isBD_in;
        end
    end

endmodule
