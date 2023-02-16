`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
);

    wire [31:0] PC_M;
    assign macroscopic_pc = PC_M;
    assign m_inst_addr = PC_M;

    wire Req;
    wire [31:0] TC_out1, TC_out2;
    wire IRQ1, IRQ2;
    wire [5:0] HWInt = {3'b0, interrupt, IRQ2, IRQ1};

    wire [3:0] M_WE;

    cpu CPU(
        .clk(clk),
        .reset(reset),
        .HWInt(HWInt),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .m_data_addr(m_data_addr),
        .m_data_rdata(Bridge_out),
        .m_data_wdata(m_data_wdata),
        .m_data_byteen(M_WE),

        .PC_M(PC_M),

        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),

        .w_inst_addr(w_inst_addr),

        .Req(Req)
    );

    wire [31:0] Bridge_out;

    assign m_data_byteen = Req ? 4'b0000 : M_WE;

    bridge Bridge(
        .Req(Req),

        .DM_out(m_data_rdata),
        .TC_out1(TC_out1),
        .TC_out2(TC_out2),

        .Addr(m_data_addr),
        .m_data_byteen(M_WE),

        .D_out(Bridge_out),

        .TC_WE1(TC_WE1),
        .TC_WE2(TC_WE2),

        .m_int_addr(m_int_addr),
        .m_int_byteen(m_int_byteen)
    );

    TC TC1(
        .clk(clk),
        .reset(reset),
        .Addr(m_data_addr[31:2]),
        .WE(TC_WE1),
        .Din(m_data_wdata),
        .Dout(TC_out1),
        .IRQ(IRQ1)
    );

    TC TC2(
        .clk(clk),
        .reset(reset),
        .Addr(m_data_addr[31:2]),
        .WE(TC_WE2),
        .Din(m_data_wdata),
        .Dout(TC_out2),
        .IRQ(IRQ2)
    );

endmodule
