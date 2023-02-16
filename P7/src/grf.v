`timescale 1ns / 1ps

module grf(
    input clk,
    input reset,
    input RegWrite,
    input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    
    output reg [31:0] RD1,
    output reg [31:0] RD2
    );

    reg [31:0] Registers [31:0];
	 
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 28) begin
                Registers[i] = 32'h1800;
            end
            else if (i == 29) begin
                Registers[i] = 32'h2ffc;
            end
            else begin
               Registers[i] = 32'b0; 
            end
        end
    end

    always @(*) begin
        if (A1 == 5'b0) begin
            RD1 <= 32'b0;
        end
        else if(A1 == A3 && RegWrite == 1'b1) begin
            RD1 <= WD;// 内部转发
        end
        else begin
            RD1 <= Registers[A1];
        end
    end

    always @(*) begin
        if (A2 == 5'b0) begin
            RD2 <= 32'b0;
        end
        else if(A2 == A3 && RegWrite == 1'b1) begin
            RD2 <= WD;// 内部转发
        end
        else begin
            RD2 <= Registers[A2];
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (i == 28) begin
                    Registers[i] = 32'h1800;
                end
                else if (i == 29) begin
                    Registers[i] = 32'h2ffc;
                end
                else begin
                    Registers[i] = 32'b0; 
                end
            end
        end
        else begin
            if (RegWrite) begin
                Registers[A3] <= WD;
                //$display("%d@%h: $%d <= %h", $time, PC, A3, WD);
                //$display("@%h: $%d <= %h", PC, A3, WD);
            end
            else begin
                Registers[A3] <= Registers[A3];
            end
        end
    end

endmodule
