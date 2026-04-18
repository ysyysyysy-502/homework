`timescale 1ns / 1ps

module immgen(
        input [31:0] instruction,
        output reg signed [31:0] imm
    );
    
    always @* begin
        if (instruction[6:0] == 7'b0010011) begin
            imm = {{20{instruction[31]}}, instruction[31:20]};
        end else begin
            imm = 32'b0;
        end
    end
    
endmodule
