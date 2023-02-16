`timescale 1ns / 1ps

`include "constants.v"

module cmp(
    input [31:0] GRF_RD1,
    input [31:0] GRF_RD2,
    input [2:0] nPC_sel,
    
    output isSame
    );

    assign isSame = (GRF_RD1 == GRF_RD2) ? 1'b1 : 1'b0;

endmodule
