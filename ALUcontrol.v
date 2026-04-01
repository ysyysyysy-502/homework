// ALUcontrol.v

module ALUcontrol(
    input [3:0] opcode,
    output reg [3:0] ALUOp
);
    always @(*) begin
        case(opcode)
            // Only output ADD operation for stage 1 basic
            4'b0000: ALUOp = 4'b0000; // ADD
            default: ALUOp = 4'bxxxx; // undefined
        endcase
    end
endmodule