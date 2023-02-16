`timescale 1ns / 1ps

`include "constants.v"
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
module bridge(
    input Req,

    input [31:0] DM_out,
    input [31:0] TC_out1,
    input [31:0] TC_out2,

    input [31:0] Addr,
    input [3:0] m_data_byteen,

    output [31:0] D_out,
    

    output TC_WE1,
    output TC_WE2,

    output [31:0] m_int_addr,
    output [3 :0] m_int_byteen 

    );


    assign TC_WE1 = (|m_data_byteen) & !Req & (Addr >= `TC1_begin && Addr <= `TC1_end);
    assign TC_WE2 = (|m_data_byteen) & !Req & (Addr >= `TC2_begin && Addr <= `TC2_end);


    assign D_out =  (Addr >= `DM_begin && Addr <= `DM_end) ? DM_out :
                    (Addr >= `TC1_begin && Addr <= `TC1_end) ? TC_out1 :
                    (Addr >= `TC2_begin && Addr <= `TC2_end) ? TC_out2 :
                    32'b0;

    assign m_int_addr = Addr;
    assign m_int_byteen = (Addr >= `Int_begin && Addr <= `Int_end) ? m_data_byteen : 4'b0000;

endmodule
