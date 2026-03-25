`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/25 13:01:37
// Design Name: 
// Module Name: ALUcontrol
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


module hazard_detection(
    input [4:0] IF_ID_Read_register1, IF_ID_Read_register2,
    input [4:0] ID_EX_Write_register,
    input ID_EX_MemRead,
    output reg PCWrite, IF_ID_Write, Control_Flush
);
    always @* begin
        PCWrite = 1;
        IF_ID_Write = 1;
        Control_Flush = 0;
        if (ID_EX_MemRead && (ID_EX_Write_register != 5'b0) && 
        ((ID_EX_Write_register == IF_ID_Read_register1) || (ID_EX_Write_register == IF_ID_Read_register2))) begin
            PCWrite = 0;
            IF_ID_Write = 0;
            Control_Flush = 1;
        end
    end
endmodule
