`timescale 1ns / 1ps

`include "constants.v"

module dext(
    input [1:0] A,
    input [31:0] D_in,
    input [2:0] dextOP,
    
    output reg [31:0] D_out
    );

    always @(*) begin
        case (dextOP)
            `dext_lbu: begin
                if (A == 2'b00) begin
                    D_out <= {{24{1'b0}}, D_in[7:0]};
                end
                else if (A == 2'b01) begin
                    D_out <= {{24{1'b0}}, D_in[15:8]};
                end
                else if (A == 2'b10) begin
                    D_out <= {{24{1'b0}}, D_in[23:16]};
                end
                else begin
                    D_out <= {{24{1'b0}}, D_in[31:24]};
                end
            end
            `dext_lb: begin
                if (A == 2'b00) begin
                    D_out <= {{24{D_in[7]}}, D_in[7:0]};
                end
                else if (A == 2'b01) begin
                    D_out <= {{24{D_in[15]}}, D_in[15:8]};
                end
                else if (A == 2'b10) begin
                    D_out <= {{24{D_in[23]}}, D_in[23:16]};
                end
                else begin
                    D_out <= {{24{D_in[31]}}, D_in[31:24]};
                end
            end
            `dext_lhu: begin
                if (A[1] == 1'b0) begin
                    D_out <= {{16{1'b0}}, D_in[15:0]};
                end
                else begin
                    D_out <= {{16{1'b0}}, D_in[31:16]};
                end
            end
            `dext_lh: begin
                if (A[1] == 1'b0) begin
                    D_out <= {{16{D_in[15]}}, D_in[15:0]};
                end
                else begin
                    D_out <= {{16{D_in[31]}}, D_in[31:16]};
                end
            end
            default: begin
                D_out <= D_in;
            end
        endcase
    end

endmodule