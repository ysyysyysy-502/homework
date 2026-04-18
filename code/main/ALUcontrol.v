module ALUcontrol(
    input [9:0] funct,
    input [1:0] ALUOp,
    output reg [3:0] ALUoperation
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUoperation = 4'b0000; // add (lw/sw/addi)
            2'b01: ALUoperation = 4'b0001; // sub (branch compare)
            2'b10: begin
                case (funct)
                    10'b0000000_000: ALUoperation = 4'b0000; // add
                    10'b0100000_000: ALUoperation = 4'b0001; // sub
                    10'b0000000_111: ALUoperation = 4'b0010; // and
                    10'b0000000_110: ALUoperation = 4'b0011; // or
                    10'b0000000_100: ALUoperation = 4'b0100; // xor
                    default: ALUoperation = 4'b0000;
                endcase
            end
            2'b11: ALUoperation = 4'b0000; // stage1: keep i-type as add
            default: ALUoperation = 4'b0000;
        endcase
    end
endmodule
