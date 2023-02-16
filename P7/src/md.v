`timescale 1ns / 1ps

`include "constants.v"

module md(
    input clk,
    input reset,
    input Req,
    input [3:0] HILOtype,
    input [31:0] A,
    input [31:0] B,

    output HILO_BUSY,
    output [31:0] HILO
    );

    reg [31:0] HI;
    reg [31:0] HI_temp;
    reg [31:0] LO;
    reg [31:0] LO_temp;

    assign HILO =   (HILOtype == `hilo_mfhi) ? HI :
                    (HILOtype == `hilo_mflo) ? LO :
                    32'b0;

    wire start;
    reg busy = 1'b0;
    reg [3:0] state = 4'd0;

    assign start = (HILOtype == `hilo_mult || HILOtype == `hilo_multu || HILOtype == `hilo_div || HILOtype == `hilo_divu || HILOtype == `hilo_madd || HILOtype == `hilo_maddu || HILOtype == `hilo_msub || HILOtype == `hilo_msubu) ? 1'b1 : 1'b0;

    assign HILO_BUSY = start | busy;

    always @(posedge clk) begin
        if (reset) begin
            HI <= 32'b0;
            HI_temp <= 32'b0;
            LO <= 32'b0;
            LO_temp <= 32'b0;
        end
        else if (!Req || state != 4'd0) begin
            if (state == 4'd0) begin
                case (HILOtype)
                    `hilo_mult: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= $signed(A) * $signed(B);
                    end
                    `hilo_multu: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= A * B;
                    end
                    `hilo_div: begin
                        state <= 4'd10;
                        busy <= 1'b1;
                        LO_temp <= $signed(A) / $signed(B);
                        HI_temp <= $signed(A) % $signed(B);
                    end
                    `hilo_divu: begin
                        state <= 4'd10;
                        busy <= 1'b1;
                        LO_temp <= A / B;
                        HI_temp <= A % B;
                    end
                    `hilo_mthi: begin
                        HI <= A;
                    end
                    `hilo_mtlo: begin
                        LO <= A;
                    end

                    `hilo_madd: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= {HI, LO} + $signed($signed(64'd0) + $signed(A) * $signed(B));
                    end

                    //{temp_hi, temp_lo} <= {hi, lo} + $signed($signed(64'd0) + $signed(rs) * $signed(rt));
                    // 或�
                    //{temp_hi, temp_lo} <= {hi, lo} + $signed({{32{rs[31]}}, rs[31]} * $signed({{32{rt[31]}}, rt[31]})); // 手动进行符坷佝扩�?

                    `hilo_maddu: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= {HI, LO} + (A * B);
                    end

                    `hilo_msub: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= {HI, LO} - $signed($signed(64'd0) + $signed(A) * $signed(B));
                    end
                    
                    `hilo_msubu: begin
                        state <= 4'd5;
                        busy <= 1'b1;
                        {HI_temp, LO_temp} <= {HI, LO} - (A * B);
                    end

                    default: begin
                        
                    end
                endcase
            end
            else if (state == 4'd1) begin
                HI <= HI_temp;
                LO <= LO_temp;
                state <= 4'd0;
                busy <= 1'b0;
            end
            else begin
                state <= state - 1;
            end 
        end

    end


endmodule
