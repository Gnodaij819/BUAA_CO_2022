`timescale 1ns / 1ps

`include "constants.v"

module d_reg(
    input clk,
    input reset,
    input Stall,
    input HILO_BUSY,
    input isHILO,
    input flush,

    input [31:0] instr_in,
    input [31:0] PC_in,
    
    output reg [31:0] instr_out,
    output reg [31:0] PC_out
    );

    always @(posedge clk) begin
        if (reset | (flush && (~Stall))) begin
            instr_out <= 32'b0;
            PC_out <= 32'b0;
        end
        else if (Stall | (HILO_BUSY & isHILO)) begin
            instr_out <= instr_out;
            PC_out <= PC_out;
        end
        else begin
            instr_out <= instr_in;
            PC_out <= PC_in;
        end
    end

endmodule
