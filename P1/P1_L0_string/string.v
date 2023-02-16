`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:36 10/05/2022 
// Design Name: 
// Module Name:    string 
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
`define S0 5'b00001
`define S1 5'b00010
`define S2 5'b00100
`define S3 5'b01000



module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );

    reg [4:0] status = 4'b00001;

    assign out = (status == `S1) ? 1'b1 : 1'b0;

always @(posedge clk,posedge clr) begin
    if (clr) begin
        status <= `S0;
    end
    else begin
        case (status)
            `S0: begin
                status <= (in >= "0" && in <= "9") ? `S1 : `S3;
            end
            `S1: begin
                status <= (in >= "0" && in <= "9") ? `S3 :
                (in == "+" || in == "*") ? `S2 : `S3;
            end
            `S2: begin
                status <= (in >= "0" && in <= "9") ? `S1 : `S3;
            end
            `S3: begin
                status <= `S3;;
            end
            default: begin
                status <= `S0;
            end
        endcase
    end
end

endmodule
