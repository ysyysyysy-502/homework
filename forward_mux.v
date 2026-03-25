`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/04 14:59:23
// Design Name: 
// Module Name: forward_mux
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


module forward_mux(
    input [31:0] A, B, C,
    input [1:0] Forward,
    output [31:0] res
    );
    assign res = (Forward == 2'b00) ? A : (Forward == 2'b01 ? B : C); 
endmodule
