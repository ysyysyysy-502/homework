`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: 
// Module Name: rf
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


module rf(
        input clk, rstn,
        input RegWrite,
        input [4:0] Read_register1, Read_register2, Write_register,
        input [31:0] Write_data,
        output [31:0] Read_data1, Read_data2 
    );
    reg [31:0]Registers[31:0];
    integer i;
    always @(negedge clk or negedge rstn) begin
        if (!rstn) for (i = 0; i < 32; i = i + 1) Registers[i] <= 32'b0;
        else if (RegWrite && Write_register != 5'b0) Registers[Write_register] <= Write_data;
    end
    assign Read_data1 = Registers[Read_register1];
    assign Read_data2 = Registers[Read_register2];
endmodule
