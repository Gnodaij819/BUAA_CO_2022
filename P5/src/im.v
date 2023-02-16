`timescale 1ns / 1ps

module im(
    input [31:0] PC,
    output [31:0] instr
    );

    reg [31:0] IM [4095:0];
	
    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) begin
            IM[i] = 32'd0;
        end
        $readmemh("code.txt",IM);
    end
    
    assign instr = IM[PC[13:2] - 12'hC00];

endmodule
