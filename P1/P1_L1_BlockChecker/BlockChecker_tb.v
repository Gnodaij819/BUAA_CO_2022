`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:50:16 10/05/2022
// Design Name:   BlockChecker
// Module Name:   D:/ISE/P1/P1_L1_BlockChecker/BlockChecker_tb.v
// Project Name:  P1_L1_BlockChecker
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BlockChecker_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] in;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	BlockChecker uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = 32;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		#10
		reset = 0;
		#10
		in = 97;
		#10
		in = 32;
		#10
		in = 66;
		#10
		in = 69;
		#10
		in = 71;
		#10
		in = 105;
		#10
		in = 110;
		#10
		in = 32;
		#10
		in = 101;
		#10
		in = 110;
		#10
		in = 100;
		#10
		in = 97;
		#10
		in = 32;
		#10
		in = 101;
		#10
		in = 110;
		#10
		in = 100;
		#10
		in = 32;
		#10
		in = 97;
		#10
		in = 66;
		#10
		in = 32;
		#10
		in = 101;
		#10
		in = 110;
		#10
		in = 100;
		#10
		in = 101;
		#10
		in = 110;
		#10
		in = 100;
		in = 66;
		#10
		in = 69;
		#10
		in = 71;
		#10
		in = 105;
		#10
		in = 110;

		// Add stimulus here

	end
      
		
	always #5clk = ~clk;
endmodule

