`timescale 1ns / 1ps

module instructions(
        input [31:0] PC,
        output reg [31:0] instruction
    );
    
    always @* begin
        instruction = 32'h00000013;
    end
    
endmodule
