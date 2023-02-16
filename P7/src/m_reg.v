`timescale 1ns / 1ps

module m_reg(
    input clk,
    input reset,
    input Req,

    input [31:0] PC_in,
    input [1:0] T_new_in,

    input RegWrite_in,
    input [2:0] MemtoReg_in,
    input [1:0] storeOP_in,
    input [2:0] DextOP_in,
    input load_in,
    input store_in,

    input [4:0] A2_in,
    input [4:0] rd_in,
    input [4:0] A3_in,
    input [31:0] ALU_C_in,
    input [31:0] HILO_in,
    input [31:0] GRF_RD2_in,

    input isBD_in,
    input mfc0_in,
    input mtc0_in,
    input eret_in,

    input ErrOvDM_in,
    input [4:0] ExcCode_in,

    output reg [31:0] PC_out,
    output reg [1:0] T_new_out,

    output reg RegWrite_out,
    output reg [2:0] MemtoReg_out,
    output reg [1:0] storeOP_out,
    output reg [2:0] DextOP_out,
    output reg load_out,
    output reg store_out,

    output reg [4:0] A2_out,
    output reg [4:0] rd_out,
    output reg [4:0] A3_out,
    output reg [31:0] ALU_C_out,
    output reg [31:0] HILO_out,
    output reg [31:0] GRF_RD2_out,

    output reg isBD_out,
    output reg mfc0_out,
    output reg mtc0_out,
    output reg eret_out,

    output reg ErrOvDM_out,
    output reg [4:0] ExcCode_out
    );

    always @(posedge clk) begin
        if (reset | Req) begin
            //PC_out <= Req ? 32'h0000_4180 : 32'b0;
            PC_out <= reset ? 32'b0 : 32'h0000_4180;
            T_new_out <= 2'd0;

            RegWrite_out <= 1'b0;
            MemtoReg_out <= 3'b0;
            storeOP_out <= 2'b00;
            DextOP_out <= 3'd0;
            load_out <= 1'b0;
            store_out <= 1'b0;

            A2_out <= 5'b0;
            rd_out <= 5'd0;
            A3_out <= 5'b0;
            ALU_C_out <= 32'b0;
            HILO_out <= 32'b0;
            GRF_RD2_out <= 32'b0;

            isBD_out <= 1'b0;
            mfc0_out <= 1'b0;
            mtc0_out <= 1'b0;
            eret_out <= 1'b0;

            ErrOvDM_out <= 1'd0;
            ExcCode_out <= 5'd0;
        end
        else begin
            PC_out <= PC_in;
            T_new_out <= (T_new_in == 2'd0) ? T_new_in : T_new_in - 2'd1;

            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            storeOP_out <= storeOP_in;
            DextOP_out <= DextOP_in;
            load_out <= load_in;
            store_out <= store_in;

            A2_out <= A2_in;
            rd_out <= rd_in;
            A3_out <= A3_in;
            ALU_C_out <= ALU_C_in;
            HILO_out <= HILO_in;
            GRF_RD2_out <= GRF_RD2_in;

            isBD_out <= isBD_in;
            mfc0_out <= mfc0_in;
            mtc0_out <= mtc0_in;
            eret_out <= eret_in;
            
            ErrOvDM_out <= ErrOvDM_in;
            ExcCode_out <= ExcCode_in;
        end
    end

endmodule
