`timescale 1ns / 1ps

`include "constants.v"

module alu(
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input [3:0] ALUOP,

    input ALUAri,
    input ALUDM,
    
    output reg [31:0] C,
    output ErrOvAri,
    output ErrOvDM
    );

    reg [32:0] temp;

    always @(*) begin
        case (ALUOP)
            `alu_add: begin
                temp = {A[31], A} + {B[31], B};
                C = temp[31:0];
            end
            `alu_sub: begin
                temp = {A[31], A} - {B[31], B};
                C = temp[31:0];
            end
            `alu_and: begin
                C = A & B;
            end
            `alu_or: begin
                C = A | B;
            end
            `alu_xor: begin
                C = A ^ B;
            end
            `alu_slt: begin
                if ($signed(A) < $signed(B)) begin
                    C = 32'b1;
                end
                else begin
                    C = 32'b0;
                end
            end
            `alu_sltu: begin
                if ({1'b0, A} < {1'b0, B}) begin
                    C = 32'b1;
                end
                else begin
                    C = 32'b0;
                end
            end
            default: begin
                C = 32'b0;
            end
        endcase
    end

    assign ErrOvAri = ALUAri & ((temp[32] != temp[31]) & (ALUOP == `alu_add || ALUOP == `alu_sub));
    assign ErrOvDM = ALUDM & ((temp[32] != temp[31]) & (ALUOP == `alu_add || ALUOP == `alu_sub));

						  
endmodule
