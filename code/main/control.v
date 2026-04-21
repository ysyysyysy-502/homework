module control(
    input wire [6:0] opcode,
    output reg RegWrite,
    output reg ALUsrc,
    output reg ALUsrcLui,
    output reg ALUsrcAuipc,
    output reg [1:0] ALUOp
);

    always @(*) begin
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        ALUsrcLui = 1'b0;
        ALUsrcAuipc = 1'b0;
        ALUOp = 2'b00;

        case (opcode)
            // I-type ALU: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                ALUOp = 2'b11;
            end

            // R-type ALU: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUsrc = 1'b0;
                ALUOp = 2'b10;
            end

            // LUI
            7'b0110111: begin
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                ALUsrcLui = 1'b1;
                ALUOp = 2'b00;
            end

            // AUIPC
            7'b0010111: begin
                RegWrite = 1'b1;
                ALUsrc = 1'b1;
                ALUsrcAuipc = 1'b1;
                ALUOp = 2'b00;
            end

            default: begin
                RegWrite = 1'b0;
            end
        endcase
    end
endmodule
