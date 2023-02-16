`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:23:36 10/26/2022 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
///////////////////////////// PC //////////////////////////////
    reg [31:0] PC;
    wire [31:0] PC4;

    assign PC4 = PC + 32'b0100;

    initial begin
        PC = 32'h00003000;
    end

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            PC <= 32'h00003000;
        end
        else begin
            PC <= NPC_NPC;
        end
    end
///////////////////////////////////////////////////////////
///////////////////////////// IM //////////////////////////////
    wire [31:0] instr;

    wire [5:0] funct;
    wire [4:0] shamt;
    wire [4:0] rd;
    wire [4:0] rt;
    wire [4:0] rs;
    wire [5:0] op;
    wire [15:0] imm16;
    wire [25:0] imm26;

    assign funct = instr[5:0];
    assign shamt = instr[10:6];
    assign rd = instr[15:11];
    assign rt = instr[20:16];
    assign rs = instr[25:21];
    assign op = instr[31:26];
    assign imm16 = instr[15:0];
    assign imm26 = instr[25:0];
///////////////////////////////////////////////////////////
///////////////////////////// CTRL //////////////////////////////
    wire [1:0] RegDst;
    wire ALUSrc;
    wire [1:0] MemtoReg;
    wire RegWrite;
    wire MemWrite;
    wire [1:0] nPC_sel;
    wire [3:0] ALUOp;
    wire [1:0] ExtOp;
///////////////////////////////////////////////////////////
///////////////////////////// MUX //////////////////////////////
    wire [4:0] MUX_A3_OUT;
    wire [31:0] MUX_ALUB_OUT;
    wire [31:0] MUX_GRF_WD_OUT;
///////////////////////////////////////////////////////////
///////////////////////////// GRF //////////////////////////////
    wire [31:0] GRF_RD1;
    wire [31:0] GRF_RD2;
///////////////////////////////////////////////////////////
///////////////////////////// ALU //////////////////////////////
    wire [31:0] ALU_Result;
    wire isZero;
///////////////////////////////////////////////////////////
///////////////////////////// DM //////////////////////////////
    wire [31:0] DM_RD;
///////////////////////////////////////////////////////////
///////////////////////////// EXT //////////////////////////////
    wire [31:0] EXT_Result;
///////////////////////////////////////////////////////////
///////////////////////////// NPC //////////////////////////////
    wire [31:0] NPC_NPC;
///////////////////////////////////////////////////////////
    im IM(
        .PC(PC),
        .instr(instr)
    );

    ctrl CTRL(
        .op(op),
        .funct(funct),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .nPC_sel(nPC_sel),
        .ALUOp(ALUOp),
        .ExtOp(ExtOp)
    );

    mux_A3 MUX_A3(
        .RegDst(RegDst),
        .rt(rt),
        .rd(rd),
        .A3(MUX_A3_OUT)
    );

    mux_ALUB MUX_ALUB(
        .ALUSrc(ALUSrc),
        .RD2(GRF_RD2),
        .imm(EXT_Result),
        .B(MUX_ALUB_OUT)
    );

    mux_grf_WD MUX_GRF_WD(
        .MemtoReg(MemtoReg),
        .C(ALU_Result),
        .RD(DM_RD),
        .PC4(PC4),
        .WD(MUX_GRF_WD_OUT)
    );

    grf GRF(
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .PC(PC),
        .A1(rs),
        .A2(rt),
        .A3(MUX_A3_OUT),
        .WD(MUX_GRF_WD_OUT),
        .RD1(GRF_RD1),
        .RD2(GRF_RD2)
    );

    alu ALU(
        .A(GRF_RD1),
        .B(MUX_ALUB_OUT),
        .ALUOp(ALUOp),
        .C(ALU_Result),
        .isZero(isZero)
    );

    dm DM(
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .PC(PC),
        .A(ALU_Result[13:2]),
        .WD(GRF_RD2),
        .RD(DM_RD)
    );

    ext EXT(
        .imm16(imm16),
        .ExtOp(ExtOp),
        .Result(EXT_Result)
    );

    npc NPC(
        .PC(PC),
        .imm26(imm26),
        .EXT(EXT_Result),
        .ra(GRF_RD1),
        .nPC_sel(nPC_sel),
        .isZero(isZero),
        .NPC(NPC_NPC)
    );

endmodule
