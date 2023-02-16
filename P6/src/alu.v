`timescale 1ns / 1ps

`include "constants.v"

module alu(
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input [3:0] ALUOP,
    
    output reg [31:0] C
    );

    always @(*) begin
        case (ALUOP)
            `alu_add: begin
                C <= A + B;
            end
            `alu_sub: begin
                C <= A - B;
            end
            `alu_and: begin
                C <= A & B;
            end
            `alu_or: begin
                C <= A | B;
            end
            `alu_xor: begin
                C <= A ^ B;
            end
            `alu_slt: begin
                if ($signed(A) < $signed(B)) begin
                    C <= 32'b1;
                end
                else begin
                    C <= 32'b0;
                end
            end
            `alu_sltu: begin
                if ({1'b0, A} < {1'b0, B}) begin
                    C <= 32'b1;
                end
                else begin
                    C <= 32'b0;
                end
            end
            default: begin
                C <= 32'b0;
            end
        endcase
    end
						  
endmodule
