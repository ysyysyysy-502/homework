`timescale 1ns / 1ps

module immgen(
        input [31:0] instruction,
        output reg signed [31:0] imm
    );
    
    wire [6:0] opcode = instruction[6:0];
    
    always @* begin
        case (opcode)
            // I-type: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, LB, LH, LW, LBU, LHU, JALR
            7'b0010011: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            
            // LOAD: LB, LH, LW, LBU, LHU
            7'b0000011: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
               
            // U-type: LUI, AUIPC
            7'b0110111, 7'b0010111: begin
                imm = {instruction[31:12], 12'b0};
            end

            default: begin
                imm = 32'b0;
            end
        endcase
    end
    
endmodule
