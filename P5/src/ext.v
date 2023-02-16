`timescale 1ns / 1ps

`include "constants.v"

module ext(
    input [15:0] imm16,
    input [1:0] ExtOP,
    
    output reg [31:0] EXT_Result
    );

    always @(*) begin
        case (ExtOP)
            `ext_zero: begin
                EXT_Result <= {{16{1'b0}}, imm16};
            end
            `ext_sign: begin
                EXT_Result <= {{16{imm16[15]}}, imm16};
            end
            `ext_high: begin
                EXT_Result <= {imm16, {16{1'b0}}};
            end
            default: begin
                EXT_Result <= {{16{1'b0}}, imm16};
            end
        endcase
    end

endmodule