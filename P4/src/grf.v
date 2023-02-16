`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:14 11/02/2022 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input clk,
    input reset,
    input RegWrite,
    input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2
    );

    reg [31:0] Registers [31:0];
	 
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Registers[i] = 32'b0;
        end
    end

    assign RD1 = (A1 == 5'b0) ? 32'b0 : Registers[A1];
    assign RD2 = (A2 == 5'b0) ? 32'b0 : Registers[A2];

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (i = 0; i < 32; i = i + 1) begin
                Registers[i] <= 32'b0;
            end
        end
        else begin
            if (RegWrite == 1'b1) begin
                Registers[A3] <= WD;
                $display("@%h: $%d <= %h", PC, A3, WD);
            end
            else begin
                Registers[A3] <= Registers[A3];
            end
        end
    end

endmodule