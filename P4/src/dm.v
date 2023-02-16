`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:10 11/02/2022 
// Design Name: 
// Module Name:    dm 
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
module dm(
    input clk,
    input reset,
    input MemWrite,
    input [31:0] PC,
    input [13:2] A,
    input [31:0] WD,
    output [31:0] RD
    );
	
    reg [31:0] DM [3071:0];
    wire [31:0] addr = {{18{1'b0}}, A, {2{1'b0}}};

    integer i;
    initial begin
        for (i = 0; i < 3072; i = i + 1) begin
            DM[i] = 32'b0;
        end
    end

    assign RD = DM[A];

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (i = 0; i < 3072; i = i + 1) begin
                DM[i] <= 32'b0;
            end
        end 
        else begin
            if (MemWrite == 1'b1) begin
                DM[A] <= WD;
                $display("@%h: *%h <= %h", PC, addr, WD);
            end
            else begin
                DM[A] <= DM[A];
            end
        end
    
    end

endmodule
