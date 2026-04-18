`timescale 1ns / 1ps

module forward_mux(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [1:0] Forward,
    output reg [31:0] res
);
    always @(*) begin
        case (Forward)
            2'b00: res = A;
            2'b01: res = B;
            2'b10: res = C;
            default: res = A;
        endcase
    end
endmodule
