`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:57:22 11/02/2022 
// Design Name: 
// Module Name:    ext 
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
`define ZERO 2'b00
`define SIGN 2'b01
`define HIGH 2'b10
module ext(
    input [15:0] imm16,
    input [1:0] ExtOp,
    output [31:0] Result
    );

    assign Result = (ExtOp == `ZERO) ? {{16{1'b0}}, imm16} :
                    (ExtOp == `SIGN) ? {{16{imm16[15]}}, imm16} :
                    (ExtOp == `HIGH) ? {imm16, {16{1'b0}}} :
                    {{16{1'b0}}, imm16};

endmodule
