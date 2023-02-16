`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:12:23 11/03/2022 
// Design Name: 
// Module Name:    mux 
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
module mux_A3(
    input [1:0] RegDst,
    input [4:0] rt,
    input [4:0] rd,
    output [4:0] A3
    );

    assign A3 = (RegDst == 2'b00) ? rt :
                (RegDst == 2'b01) ? rd :
                (RegDst == 2'b10) ? 5'd31 :
                5'b0;

endmodule

module mux_ALUB(
    input ALUSrc,
    input [31:0] RD2,
    input [31:0] imm,
    output [31:0] B
    );

    assign B = (ALUSrc == 1'b0) ? RD2 : imm;

endmodule

module mux_grf_WD(
    input [1:0] MemtoReg,
    input [31:0] C,
    input [31:0] RD,
    input [31:0] PC4,
    output [31:0] WD
    );

    assign WD = (MemtoReg == 2'b00) ? C :
                (MemtoReg == 2'b01) ? RD :
                (MemtoReg == 2'b10) ? PC4 :
                32'b0;

endmodule
