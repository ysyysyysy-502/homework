module control(
    input wire [6:0] opcode,
    input wire Control_Flush,
    output reg RegWrite,
    output reg ALUsrc,
    output reg MemWrite,
    output reg MemtoReg,
    output reg MemRead,
    output reg Branch,
    output reg JumpJal,
    output reg JumpJalr,
    output reg RegDest,
    output reg ALUsrcLui,
    output reg ALUsrcAuipc,
    output reg [1:0] ALUOp
);

    always @(*) begin
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        Branch = 1'b0;
        JumpJal = 1'b0;
        JumpJalr = 1'b0;
        RegDest = 1'b0;
        ALUsrcLui = 1'b0;
        ALUsrcAuipc = 1'b0;
        ALUOp = 2'b00;

        if (!Control_Flush) begin
            case (opcode)
                7'b0010011: begin // I-type ALU
                    RegWrite = 1'b1;
                    ALUsrc = 1'b1;
                    ALUOp = 2'b11;
                end
                default: begin
                    RegWrite = 1'b0;
                end
            endcase
        end
    end
endmodule
