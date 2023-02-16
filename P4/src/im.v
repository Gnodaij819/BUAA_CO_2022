`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:52:31 11/02/2022 
// Design Name: 
// Module Name:    im 
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
module im(
    input [31:0] PC,
    output [31:0] instr
    );

    reg [31:0] IM [4095:0];
	
    initial begin
        $readmemh("code.txt",IM);
    end
    
    assign instr = IM[PC[13:2] - 12'hC00];

endmodule
