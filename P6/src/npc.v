`timescale 1ns / 1ps

`include "constants.v"

module npc(
    input Stall,
    input HILO_BUSY,
    input isHILO,

    input [31:0] PC,
    input [25:0] imm26,
    input [31:0] EXT,
    input [31:0] RD1,
    input [2:0] nPC_sel,
    input isSame,

    output reg [31:0] NPC,
    output reg flush
    );

    always @(*) begin
        if (Stall | (HILO_BUSY & isHILO)) begin
            flush <= 1'b0;
            NPC <= PC;
        end
        else begin
            case (nPC_sel)
                `npc_j: begin
                    flush <= 1'b0;
                    NPC <= {PC[31:28], imm26, {2{1'b0}}};
                end
                `npc_jr: begin
                    flush <= 1'b0;
                    NPC <= RD1;
                end
                `npc_beq: begin
                    flush <= 1'b0;
                    if (isSame) begin
                        NPC <= PC + (EXT << 2);
                    end
                    else begin
                        NPC <= PC + 4;
                    end
                end
                `npc_bne: begin
                    flush <= 1'b0;
                    if (isSame) begin
                        NPC <= PC + 4;
                    end
                    else begin
                        NPC <= PC + (EXT << 2);
                    end
                end
                `npc_PC4: begin
                    flush <= 1'b0;
                    NPC <= PC + 4;
                end
                default: begin
                    flush <= 1'b0;
                    NPC <= PC + 4;
                end
            endcase
        end
    end

endmodule
