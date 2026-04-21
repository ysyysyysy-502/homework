`timescale 1ns / 1ps

module instructions(
        input [31:0] PC,
        output reg [31:0] instruction
    );
    
    // 64x32 bit instruction memory with test program
    reg [31:0] imem [63:0];
    
    initial begin
        // Test program for I-type and R-type instructions
        imem[0]  = 32'h00500093;  // addi x1, x0, 5      (x1 = 5)
        imem[1]  = 32'h00300113;  // addi x2, x0, 3      (x2 = 3)
        imem[2]  = 32'h00210183;  // addi x3, x2, 2      (x3 = 5)
        imem[3]  = 32'h40308233;  // sub x4, x1, x3      (x4 = 0)
        imem[4]  = 32'h0061e293;  // ori x5, x3, 6       (x5 = 7)
        imem[5]  = 32'h0071f313;  // andi x6, x3, 7      (x6 = 5)
        imem[6]  = 32'h00719393;  // slli x7, x3, 7      (x7 = 640)
        imem[7]  = 32'h00635413;  // srli x8, x6, 6      (x8 = 0)
        imem[8]  = 32'h40638493;  // srai x9, x7, 6      (x9 = 10)
        imem[9]  = 32'h00731513;  // slti x10, x6, 7     (x10 = 1)
        imem[10] = 32'h00032593;  // slti x11, x6, 0     (x11 = 0)
        imem[11] = 32'h00734613;  // sltu x12, x6, 7     (x12 = 1)
        imem[12] = 32'h00735693;  // sltu x13, x6, 7     (x13 = 1)
        imem[13] = 32'h00726713;  // xori x14, x4, 7     (x14 = 7)
        imem[14] = 32'h00000013;  // addi x0, x0, 0      (nop)
        imem[15] = 32'h00000013;  // addi x0, x0, 0      (nop)
        
        // Initialize rest as NOPs
        for (int i = 16; i < 64; i = i + 1) begin
            imem[i] = 32'h00000013;  // nop
        end
    end
    
    always @* begin
        instruction = imem[PC[7:2]];  // Address is word-aligned (PC >> 2)
    end
    
endmodule
