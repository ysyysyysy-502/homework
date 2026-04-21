`timescale 1ns / 1ps

module alu(
        input [3:0] ALUoperation,
        input signed [31:0] A, B,
        output reg signed [31:0] ALUresult,
        output reg Zero, Negative, Overflow, Carry
    );
    
    wire [31:0] sum = A + B;
    wire [31:0] diff = A - B;
    wire [31:0] and_res = A & B;
    wire [31:0] or_res = A | B;
    wire [31:0] xor_res = A ^ B;
    wire [31:0] sll_res = A << B[4:0];
    wire [31:0] srl_res = A >> B[4:0];
    wire signed [31:0] sra_res = A >>> B[4:0];
    wire [31:0] slt_res = (A < B) ? 32'b1 : 32'b0;
    wire [31:0] sltu_res = ($unsigned(A) < $unsigned(B)) ? 32'b1 : 32'b0;
    
    always @* begin
        case (ALUoperation)
            4'b0000: ALUresult = sum;           // ADD
            4'b0001: ALUresult = diff;          // SUB
            4'b0010: ALUresult = and_res;       // AND
            4'b0011: ALUresult = or_res;        // OR
            4'b0100: ALUresult = xor_res;       // XOR
            4'b0101: ALUresult = sll_res;       // SLL
            4'b0110: ALUresult = srl_res;       // SRL
            4'b0111: ALUresult = sra_res;       // SRA
            4'b1000: ALUresult = slt_res;       // SLT
            4'b1001: ALUresult = sltu_res;      // SLTU
            default: ALUresult = 32'b0;
        endcase
        
        // Generate flag bits
        Zero = (ALUresult == 32'b0) ? 1'b1 : 1'b0;
        Negative = ALUresult[31];
        Overflow = ((A[31] == B[31]) && (ALUresult[31] != A[31]) && (ALUoperation == 4'b0000 || ALUoperation == 4'b0001)) ? 1'b1 : 1'b0;
        Carry = (ALUoperation == 4'b0000) ? (sum < A) : 
                (ALUoperation == 4'b0001) ? (A < B) : 1'b0;
    end
    
endmodule
