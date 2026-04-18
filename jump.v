`timescale 1ns / 1ps

module jump(
    input Zero,
    input Negative,
    input Overflow,
    input Carry,
    input [2:0] funct3,
    output reg jump_taken
);
    always @(*) begin
        case (funct3)
            3'b000: jump_taken = Zero;               // beq
            3'b001: jump_taken = ~Zero;              // bne
            3'b100: jump_taken = Negative ^ Overflow;// blt
            3'b101: jump_taken = ~(Negative ^ Overflow);// bge
            3'b110: jump_taken = ~Carry;             // bltu
            3'b111: jump_taken = Carry;              // bgeu
            default: jump_taken = 1'b0;
        endcase
    end
endmodule
