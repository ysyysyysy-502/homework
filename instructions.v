`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/25 14:38:24
// Design Name: 
// Module Name: instructions
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instructions(
        input signed [31:0] PC,
        output reg [31:0] instruction
    );
    always @* begin
        case (PC)
            32'd0: instruction = 32'h01400193;
            32'd4: instruction = 32'h00100793;
            32'd8: instruction = 32'h00f1a023;
            32'd12: instruction = 32'h00100793;
            32'd16: instruction = 32'hfef1ae23;   
            32'd20: instruction = 32'h00400793;   
            32'd24: instruction = 32'hfef1ac23;   
            32'd28: instruction = 32'h00500793;   
            32'd32: instruction = 32'hfef1aa23;   
            32'd36: instruction = 32'h00100793;   
            32'd40: instruction = 32'hfef1a823;   
            32'd44: instruction = 32'h00400793;   
            32'd48: instruction = 32'hfef1a623;   
            32'd52: instruction = 32'h008000ef;   
            32'd56: instruction = 32'h00008067;   
            32'd60: instruction = 32'h00400613;   
            32'd64: instruction = 32'h00418593;   
            32'd68: instruction = 32'h00100513;   
            32'd72: instruction = 32'h00600813;   
            32'd76: instruction = 32'h000607b3;   
            32'd80: instruction = 32'h0007a683;   
            32'd84: instruction = 32'hffc62703;   
            32'd88: instruction = 32'h00e6d663;   
            32'd92: instruction = 32'hfed62e23;   
            32'd96: instruction = 32'h00e7a023;   
            32'd100: instruction = 32'h00478793;   
            32'd104: instruction = 32'hfef594e3;   
            32'd108: instruction = 32'h00150513;   
            32'd112: instruction = 32'h00460613;   
            32'd116: instruction = 32'hfd051ce3;   
            32'd120: instruction = 32'h00008067;   
            default: instruction = 32'h00000000;  
        endcase
    end
endmodule
