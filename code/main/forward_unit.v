`timescale 1ns / 1ps

module forward_unit(
    input [4:0] ID_EX_Read_register1,
    input [4:0] ID_EX_Read_register2,
    input [4:0] EX_MEM_Write_register,
    input [4:0] MEM_WB_Write_register,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        if (EX_MEM_RegWrite &&
            (EX_MEM_Write_register != 5'b0) &&
            (EX_MEM_Write_register == ID_EX_Read_register1)) begin
            ForwardA = 2'b10;
        end else if (MEM_WB_RegWrite &&
                     (MEM_WB_Write_register != 5'b0) &&
                     (MEM_WB_Write_register == ID_EX_Read_register1)) begin
            ForwardA = 2'b01;
        end

        if (EX_MEM_RegWrite &&
            (EX_MEM_Write_register != 5'b0) &&
            (EX_MEM_Write_register == ID_EX_Read_register2)) begin
            ForwardB = 2'b10;
        end else if (MEM_WB_RegWrite &&
                     (MEM_WB_Write_register != 5'b0) &&
                     (MEM_WB_Write_register == ID_EX_Read_register2)) begin
            ForwardB = 2'b01;
        end
    end
endmodule
