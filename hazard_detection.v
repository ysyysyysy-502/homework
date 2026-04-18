`timescale 1ns / 1ps

module hazard_detection(
    input [4:0] IF_ID_Read_register1,
    input [4:0] IF_ID_Read_register2,
    input [4:0] ID_EX_Write_register,
    input ID_EX_MemRead,
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg Control_Flush
);
    always @(*) begin
        if (ID_EX_MemRead &&
            (ID_EX_Write_register != 5'b0) &&
            ((ID_EX_Write_register == IF_ID_Read_register1) ||
             (ID_EX_Write_register == IF_ID_Read_register2))) begin
            PCWrite = 1'b0;
            IF_ID_Write = 1'b0;
            Control_Flush = 1'b1;
        end else begin
            PCWrite = 1'b1;
            IF_ID_Write = 1'b1;
            Control_Flush = 1'b0;
        end
    end
endmodule
