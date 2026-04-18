`timescale 1ns / 1ps

module alu(
        input [3:0] ALUoperation,
        input signed [31:0] A, B,
        output signed [31:0] ALUresult,
        output Zero, Negative, Overflow, Carry
    );
    
    assign ALUresult = A + B;
    assign Zero = (ALUresult == 32'b0) ? 1'b1 : 1'b0;
    assign Negative = ALUresult[31];
    assign Overflow = ((A[31] == B[31]) && (ALUresult[31] != A[31])) ? 1'b1 : 1'b0;
    assign Carry = (ALUresult < A) ? 1'b1 : 1'b0;
    
endmodule
