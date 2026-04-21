`timescale 1ns / 1ps

module instructions(
        input [31:0] PC,
        output reg [31:0] instruction
    );

    // 64x32 bit instruction memory
    reg [31:0] imem [63:0];

    initial begin
        // Stage 3 test: I-type + R-type (no forwarding, avoid data hazards)
        // First 4 instructions only read x0, so no dependency issue
        imem[0]  = 32'h00500093;  // addi x1, x0, 5       (x1 = 5)
        imem[1]  = 32'h00300113;  // addi x2, x0, 3       (x2 = 3)
        imem[2]  = 32'h00700193;  // addi x3, x0, 7       (x3 = 7)
        imem[3]  = 32'h00A00213;  // addi x4, x0, 10      (x4 = 10)
        // 1 NOP to ensure x1~x4 all written before use (gap >= 4)
        imem[4]  = 32'h00000013;  // nop
        // R-type tests (x1~x4 all safe, written 4+ cycles ago)
        imem[5]  = 32'h002082B3;  // add  x5, x1, x2      (x5 = 8)
        imem[6]  = 32'h40218333;  // sub  x6, x3, x2      (x6 = 4)
        imem[7]  = 32'h0030F3B3;  // and  x7, x1, x3      (x7 = 5)
        imem[8]  = 32'h0020E433;  // or   x8, x1, x2      (x8 = 7)
        imem[9]  = 32'h0041C4B3;  // xor  x9, x3, x4      (x9 = 13)
        imem[10] = 32'h00209533;  // sll  x10, x1, x2     (x10 = 40)
        imem[11] = 32'h001125B3;  // slt  x11, x2, x1     (x11 = 1, 3<5)
        // I-type tests (x1 safe)
        imem[12] = 32'h0060E493;  // ori  x9, x1, 6       (x9 = 7)
        imem[13] = 32'h0030F513;  // andi x10, x1, 3      (x10 = 1)
        imem[14] = 32'h00209593;  // slli x11, x1, 2      (x11 = 20)
        imem[15] = 32'h00000013;  // nop

        // Rest as NOPs
        for (integer i = 16; i < 64; i = i + 1) begin
            imem[i] = 32'h00000013;
        end
    end

    always @* begin
        instruction = imem[PC[7:2]];
    end

endmodule
