`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:39:56 11/02/2022 
// Design Name: 
// Module Name:    npc 
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
module npc(
    input [31:0] PC,
    input [25:0] imm26,
    input [31:0] EXT,
    input [31:0] ra,
    input [1:0] nPC_sel,
    input isZero,
    output [31:0] NPC
    );

    assign NPC = (nPC_sel == 2'b00) ? PC + 4 :
                 (nPC_sel == 2'b01) ? ((isZero == 1'b1) ? PC + 4 + (EXT << 2) : PC + 4) :
                 (nPC_sel == 2'b10) ? {PC[31:28], imm26, {2{1'b0}}} :
                 ra;

endmodule
