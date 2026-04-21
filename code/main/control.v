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
        // Default values
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
                
                // Load: LB, LH, LW, LBU, LHU
                7'b0000011: begin
                    RegWrite = 1'b1;
                    ALUsrc = 1'b1;
                    MemRead = 1'b1;
                    MemtoReg = 1'b1;
                    ALUOp = 2'b00;
                end
                
                // Store: SB, SH, SW
                7'b0100011: begin
                    MemWrite = 1'b1;
                    ALUsrc = 1'b1;
                    ALUOp = 2'b00;
                end
                
                // Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU
                7'b1100011: begin
                    Branch = 1'b1;
                    ALUsrc = 1'b0;
                    ALUOp = 2'b01;
                end
                
                // JAL
                7'b1101111: begin
                    JumpJal = 1'b1;
                    RegWrite = 1'b1;
                    RegDest = 1'b1;
                    ALUOp = 2'b00;
                end
                
                // JALR
                7'b1100111: begin
                    JumpJalr = 1'b1;
                    RegWrite = 1'b1;
                    RegDest = 1'b1;
                    ALUsrc = 1'b1;
                    ALUOp = 2'b00;
                end
                
                // LUI
                7'b0110111: begin
                    RegWrite = 1'b1;
                    ALUsrcLui = 1'b1;
                    ALUOp = 2'b00;
                end
                
                // AUIPC
                7'b0010111: begin
                    RegWrite = 1'b1;
                    ALUsrcAuipc = 1'b1;
                    ALUOp = 2'b00;
                end
                
                default: begin
                    RegWrite = 1'b0;
                end
            endcase
        end
    end
endmodule
