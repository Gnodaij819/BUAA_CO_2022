`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:56 11/02/2022 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define ADD 4'b0000
`define SUB 4'b0001
`define OR 4'b0010
`define AND 4'b0011
`define XOR 4'b0100

module alu(
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input [3:0] ALUOp,
    output [31:0] C,
    output isZero
    );

    assign isZero = (C == 32'b0) ? 1'b1 : 1'b0;
    assign C =  (ALUOp == `ADD) ? A + B :
                (ALUOp == `SUB) ? A - B :
                (ALUOp == `OR) ? A | B :
                (ALUOp == `AND) ? A & B :
                (ALUOp == `XOR) ? A ^ B :
                32'b0;

endmodule
