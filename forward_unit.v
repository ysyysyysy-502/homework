`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/03 21:49:30
// Design Name: 
// Module Name: forward_unit
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


module forward_unit(
    input [4:0] ID_EX_Read_register1, ID_EX_Read_register2,
    input [4:0] EX_MEM_Write_register, MEM_WB_Write_register,
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        // EX stage forwarding (highest priority)
        if (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0) && (EX_MEM_Write_register == ID_EX_Read_register1))
            ForwardA = 2'b10;
        else if (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0) && (MEM_WB_Write_register == ID_EX_Read_register1))
            ForwardA = 2'b01;
        if (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0) && (EX_MEM_Write_register == ID_EX_Read_register2))
            ForwardB = 2'b10;
        else if (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0) && (MEM_WB_Write_register == ID_EX_Read_register2))
            ForwardB = 2'b01;
    end
endmodule