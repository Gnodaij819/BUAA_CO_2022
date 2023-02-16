`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:48 10/26/2022 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
    input [5:0] op,
    input [5:0] funct,
    output [1:0] RegDst,
    output ALUSrc,
    output [1:0] MemtoReg,
    output RegWrite,
    output MemWrite,
    output [1:0] nPC_sel,
    output [3:0] ALUOp,
    output [1:0] ExtOp
    );

	parameter special = 6'b000000;
	parameter add = 6'b100000;
	parameter sub = 6'b100010;
	parameter jr = 6'b001000;

	parameter ori = 6'b001101;
	parameter lw = 6'b100011;
	parameter sw = 6'b101011;
	parameter beq = 6'b000100;
	parameter lui = 6'b001111;
	parameter jal = 6'b000011;

	assign RegDst = (op == special && (funct == add || funct == sub)) ? 2'b01 :
					(op == jal) ? 2'b10 : 
					2'b00;
	assign ALUSrc = (op == ori || op == lw || op == sw || op == lui) ? 1'b1 :
					1'b0;
	assign MemtoReg = (op == lw) ? 2'b01 :
					  (op == jal) ? 2'b10 :
					  2'b00;
	assign RegWrite = (op == ori || op == lw || op == lui || op == jal) ? 1'b1 :
					  (op == special && (funct == add || funct == sub)) ? 1'b1 :
					  1'b0;
	assign MemWrite = (op == sw) ? 1'b1 :
					  1'b0;
	assign nPC_sel = (op == beq) ? 2'b01 :
					 (op == jal) ? 2'b10 :
					 (op == special && funct == jr) ? 2'b11 :
					 2'b00;
	assign ALUOp = (op == beq) || (op == special && funct == sub) ? 4'b0001 :
				   (op == ori) ? 4'b0010 :
				   4'b0000;
	assign ExtOp = (op == lw || op == sw || op == beq) ? 2'b01 :
				   (op == lui) ? 2'b10 :
				   2'b00;

endmodule
