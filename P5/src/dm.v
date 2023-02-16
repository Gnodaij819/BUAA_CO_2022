`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module dm(
    input clk,
    input reset,
    input [31:0] PC,
    input [13:0] A,
    input [31:0] WD,
    input [3:0] byteen,
    output [31:0] RD
    );
	
    reg [31:0] DM [3071:0];
    wire [31:0] addr = {{18{1'b0}}, A[13:2], {2{1'b0}}};

    assign RD = DM[A[13:2]];

    integer i;
    initial begin
        for (i = 0; i < 3072; i = i + 1) begin
            DM[i] = 32'b0;
        end
    end

    reg [31:0] fixed_wdata;

    always @( *) begin
        fixed_wdata = DM[A[13:2]];
        if (byteen[3]) fixed_wdata[31:24] = WD[31:24];
        if (byteen[2]) fixed_wdata[23:16] = WD[23:16];
        if (byteen[1]) fixed_wdata[15: 8] = WD[15: 8];
        if (byteen[0]) fixed_wdata[7 : 0] = WD[7 : 0];
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 3072; i = i + 1) begin
                DM[i] <= 32'b0;
            end
        end 
        else begin
            if (|byteen) begin
                DM[A[13:2]] <= fixed_wdata;
                $display("%d@%h: *%h <= %h", $time, PC, addr, WD);
                //$display("@%h: *%h <= %h", PC, addr, fixed_wdata);
            end
            else begin
                DM[A[13:2]] <= DM[A[13:2]];
            end
        end
    end

endmodule
