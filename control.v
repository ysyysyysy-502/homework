// Updated control.v to output zero signals for stage 1 basic pipeline

module control(
    input wire [5:0] opcode,
    output reg [1:0] reg_write,
    output reg [1:0] mem_read,
    output reg [1:0] mem_write,
    output reg [1:0] alu_op
);

    always @(*) begin
        case (opcode)
            // Add your opcode handling here
            default: begin
                reg_write = 2'b00;  // Every signal to zero for stage 1
                mem_read = 2'b00;
                mem_write = 2'b00;
                alu_op = 2'b00;
            end
        endcase
    end
endmodule