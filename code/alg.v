`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: 
// Module Name: alg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alg(
        input clk, rstn,
        input[31:0] i_data,
        input disp_mode,
        output reg[7:0] o_seg,
        output reg[7:0] o_sel
    );
    parameter div_num = 14;
    reg [31:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) cnt <= 32'b0;
        else cnt <= cnt + 1;
    end
    wire clk_1s = cnt[div_num];
    reg [2:0] seg_cnt;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) seg_cnt <= 3'b0;
        else seg_cnt <= seg_cnt + 1;
    end
    wire [3:0] seg_data_r;
    wire [7:0] seg_data_g;
    assign seg_data_r = (i_data >> (seg_cnt * 4)) & 4'hF;
    assign seg_data_g = (i_data >> (seg_cnt * 8)) & 8'hFF;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) o_sel <= 8'b1111_1111;
        else o_sel <= ~(8'b0000_0001 << seg_cnt);
    end
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) o_seg <= 8'b1111_1111;
        else begin
            if (disp_mode) o_seg <= seg_data_g;
            else begin
                case(seg_data_r)
                    4'h0: o_seg <= 8'hC0;
                    4'h1: o_seg <= 8'hF9;
                    4'h2: o_seg <= 8'hA4;
                    4'h3: o_seg <= 8'hB0;
                    4'h4: o_seg <= 8'h99;
                    4'h5: o_seg <= 8'h92;
                    4'h6: o_seg <= 8'h82;
                    4'h7: o_seg <= 8'hF8;
                    4'h8: o_seg <= 8'h80;
                    4'h9: o_seg <= 8'h90;
                    4'hA: o_seg <= 8'h88;
                    4'hB: o_seg <= 8'h83;
                    4'hC: o_seg <= 8'hC6;
                    4'hD: o_seg <= 8'hA1;
                    4'hE: o_seg <= 8'h86;
                    4'hF: o_seg <= 8'h8E;
                    default: o_seg <= 8'b1111_1111;
                endcase
            end
        end
    end
endmodule

