module ALUcontrol(
    input [9:0] funct,
    input [1:0] ALUOp,
    output reg [3:0] ALUoperation
);

    wire [6:0] funct7 = funct[9:3];
    wire [2:0] funct3 = funct[2:0];

    always @(*) begin
        case (ALUOp)
            // Load/Store/Branch - use ADD
            2'b00: ALUoperation = 4'b0000; // add
            
            // Branch - use SUB for comparison
            2'b01: ALUoperation = 4'b0001; // sub
            
            // R-type instructions
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7[5] == 1'b0)
                            ALUoperation = 4'b0000; // add
                        else
                            ALUoperation = 4'b0001; // sub
                    end
                    3'b001: ALUoperation = 4'b0101; // sll
                    3'b010: ALUoperation = 4'b1000; // slt
                    3'b011: ALUoperation = 4'b1001; // sltu
                    3'b100: ALUoperation = 4'b0100; // xor
                    3'b101: begin
                        if (funct7[5] == 1'b0)
                            ALUoperation = 4'b0110; // srl
                        else
                            ALUoperation = 4'b0111; // sra
                    end
                    3'b110: ALUoperation = 4'b0011; // or
                    3'b111: ALUoperation = 4'b0010; // and
                    default: ALUoperation = 4'b0000;
                endcase
            end
            
            // I-type instructions
            2'b11: begin
                case (funct3)
                    3'b000: ALUoperation = 4'b0000; // addi
                    3'b001: ALUoperation = 4'b0101; // slli
                    3'b010: ALUoperation = 4'b1000; // slti
                    3'b011: ALUoperation = 4'b1001; // sltiu
                    3'b100: ALUoperation = 4'b0100; // xori
                    3'b101: begin
                        if (funct7[5] == 1'b0)
                            ALUoperation = 4'b0110; // srli
                        else
                            ALUoperation = 4'b0111; // srai
                    end
                    3'b110: ALUoperation = 4'b0011; // ori
                    3'b111: ALUoperation = 4'b0010; // andi
                    default: ALUoperation = 4'b0000;
                endcase
            end
            
            default: ALUoperation = 4'b0000;
        endcase
    end
endmodule
