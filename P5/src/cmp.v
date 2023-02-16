`timescale 1ns / 1ps

`include "constants.v"

module cmp(
    input [31:0] GRF_RD1,
    input [31:0] GRF_RD2,
    input [2:0] nPC_sel,
    
    output isSame,
    output isNega
    );

    assign isSame = (GRF_RD1 == GRF_RD2) ? 1'b1 : 1'b0;
    //assign isNega = (GRF_RD1 + GRF_RD2) ? 1'b0 : 1'b1;
    assign isNega = (GRF_RD1 == 32'b0 && GRF_RD2 == 32'b0) | (GRF_RD1[31] != GRF_RD2[31] && GRF_RD1 + GRF_RD2 == 32'b0);

endmodule
