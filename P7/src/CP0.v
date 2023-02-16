`timescale 1ns / 1ps

`include "constants.v"
//////////////////////////////////////////////////////////////////////////////////
`define IM      SR[15:10]       // 对应6个外部中断是否允许中断
`define EXL     SR[1]           // 任何异常发生时置位
`define IE      SR[0]           // 全局中断使能
`define BD      Cause[31]       // 置1时EPC向前一条指令跳转
`define IP      Cause[15:10]    // 对应6个外部中断是否发生
`define ExcCode Cause[6:2]      // 异常编码
//////////////////////////////////////////////////////////////////////////////////
module CP0(
    input clk,              // 时钟信号
    input reset,            // 同步复位信号
    input CP0_WE,           // 写使能信号
    input [4:0] CP0_addr,   // 寄存器地址
    input [31:0] CP0_in,    // CP0 写入数据
    output [31:0] CP0_out,  // CP0 读出数据
    input [31:0] VPC,       // 受害PC
    input isBD,             // 是否为延迟槽指令
    input [4:0] ExcCode_in, // 记录异常类型
    input [5:0] HWInt,      // 输入中断信号
    input EXLClr,           // 用来复位EXL
    output [31:0] EPC_out,  // EPC的值
    output [31:0] SR_out,
    output Req              // 进入处理程序请求
    );

    reg [31:0] SR;
    reg [31:0] Cause;
    reg [31:0] EPC;

    assign SR_out = SR;

    // assign CP0_out =    (CP0_addr == 12) ? {{16{1'b0}}, `IM, {8{1'b0}}, `EXL, `IE} :
    //                     (CP0_addr == 13) ? {`BD, {15{1'b0}}, `IP, {3{1'b0}}, `ExcCode, {2{1'b0}}} :
    //                     (CP0_addr == 14) ? EPC :
    //                     32'b0;

    assign CP0_out =    (CP0_addr == 12) ? SR :
                        (CP0_addr == 13) ? Cause :
                        (CP0_addr == 14) ? EPC :
                        32'b0;

    wire Req_Int = (|(`IM & HWInt)) & `IE;
    wire Req_Exc = (ExcCode_in != `Exc_None);
    assign Req = (Req_Int | Req_Exc) & !`EXL;

    initial begin
        SR <= 32'b0;
        Cause <= 32'b0;
        EPC <= 32'b0;
    end

    assign EPC_out = (Req) ? (isBD ? VPC - 32'd4 : VPC) :
                     EPC;

    always @(posedge clk) begin
        if (reset) begin
            SR <= 32'b0;
            Cause <= 32'b0;
            EPC <= 32'b0;
        end
        else begin
            if (EXLClr) begin
                `EXL <= 1'b0;
            end
            if (Req) begin
                `EXL <= 1'b1;
                `ExcCode <= (Req_Int == 1'b1) ? `Exc_Int : ExcCode_in;
                `BD = isBD;
                EPC <= EPC_out;
            end else if (CP0_WE) begin
                //$display("!%h: $%d <= %h", VPC, CP0_addr, CP0_in);
                if (CP0_addr == 12) begin
                    SR <= CP0_in;
                end
                else if (CP0_addr == 13) begin
                    Cause <= CP0_in;
                end
                else if (CP0_addr == 14) begin
                    EPC <= CP0_in;
                end
            end
            `IP <= HWInt;
        end
    end


endmodule
