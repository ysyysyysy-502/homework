`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WuhanUniversity
// Engineer: Larry
// 
// Create Date: 2025/11/21 21:22:27
// Design Name: CPU
// Module Name: main
// Project Name: Digital-Design-Lab
// Target Devices: Nexys A7
// Tool Versions: vivado 2023.2
// Description: A simple RISC-V CPU
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: None
// 
//////////////////////////////////////////////////////////////////////////////////


module main(
        input clk,
        input rstn,
        input [15:0] sw_i,
        output [7:0] disp_seg_o,
        output [7:0] disp_an_o
    );
    /*
    reg [31:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) cnt <= 0;
        else cnt <= cnt + 1;
    end
    wire clk_1s = cnt[25];
    */
    wire clk_1s = clk;
    reg signed [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] instruction;
    /*--------IF--------*/
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) PC <= 32'b0;
        else if (sw_i[1]) PC <= PC;
        else if (PCWrite) PC <= next_PC;
    end
    
    instructions u_instructions(
        .PC(PC),
        .instruction(instruction)
    );
    
    /*
    dist_mem_gen_0 u_dist_mem_gen_0(
        .a(PC >> 2),
        .spo(instruction)
    );
    */
    reg[31:0] IF_ID_PC;
    reg[31:0] IF_ID_instruction;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn || IF_ID_Flush) begin
            IF_ID_PC <= 32'b0;
            IF_ID_instruction <= 32'b0;
        end
        else if (!IF_ID_Write) begin
            IF_ID_PC <= IF_ID_PC;
            IF_ID_instruction <= IF_ID_instruction;
        end
        else if (sw_i[1]) begin
            IF_ID_PC <= IF_ID_PC;
            IF_ID_instruction <= IF_ID_instruction;
        end
        else begin
            IF_ID_PC <= PC;
            IF_ID_instruction <= instruction;
        end
    end
    /*--------ID--------*/
    wire PCWrite, IF_ID_Write, Control_Flush;
    hazard_detection u_hazard_detection(
        .IF_ID_Read_register1(IF_ID_instruction[19:15]),
        .IF_ID_Read_register2(IF_ID_instruction[24:20]),
        .ID_EX_Write_register(ID_EX_Write_register),
        .ID_EX_MemRead(ID_EX_MemRead),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .Control_Flush(Control_Flush)
    );
    wire RegWrite, ALUsrc, MemWrite, MemtoReg, MemRead, Branch, JumpJal, JumpJalr, RegDest, ALUsrcLui, ALUsrcAuipc;
    wire [1:0] ALUOp;
    wire [2:0] DMType = IF_ID_instruction[14:12];
    control u_control(
        .opcode(IF_ID_instruction[6:0]),
        .Control_Flush(Control_Flush),
        .RegWrite(RegWrite),
        .ALUsrc(ALUsrc),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .Branch(Branch),
        .JumpJal(JumpJal),
        .JumpJalr(JumpJalr),
        .RegDest(RegDest),
        .ALUsrcLui(ALUsrcLui),
        .ALUsrcAuipc(ALUsrcAuipc),
        .ALUOp(ALUOp)
    );
    wire [31:0] Read_data1, Read_data2;
    rf u_rf(
        .clk(clk_1s),
        .rstn(rstn),
        .RegWrite(MEM_WB_RegWrite),
        .Read_register1(IF_ID_instruction[19:15]),
        .Read_register2(IF_ID_instruction[24:20]),
        .Write_register(MEM_WB_Write_register),
        .Write_data(mux_res4),
        .Read_data1(Read_data1),
        .Read_data2(Read_data2) 
    );
    wire signed [31:0] imm;
    immgen u_immgen(
        .instruction(IF_ID_instruction),
        .imm(imm)
    );
    reg[31:0] ID_EX_PC;
    reg[31:0] ID_EX_Read_data1, ID_EX_Read_data2;
    reg signed [31:0] ID_EX_imm;
    reg[4:0] ID_EX_Write_register, ID_EX_Read_register1, ID_EX_Read_register2;
    reg ID_EX_RegWrite, ID_EX_ALUsrc, ID_EX_MemWrite, ID_EX_MemtoReg, ID_EX_MemRead, ID_EX_Branch, ID_EX_JumpJalr, ID_EX_RegDest, ID_EX_ALUsrcLui, ID_EX_ALUsrcAuipc;
    reg[9:0] ID_EX_funct;
    reg [2:0] ID_EX_DMType;
    reg [1:0] ID_EX_ALUOp;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn || ID_EX_Flush) begin
            ID_EX_Read_data1 <= 32'b0;
            ID_EX_Read_data2 <= 32'b0;
            ID_EX_imm <= 32'b0;
            ID_EX_PC <= 32'b0;
            ID_EX_Write_register <= 5'b0;
            ID_EX_Read_register1 <= 5'b0;
            ID_EX_Read_register2 <= 5'b0;
            ID_EX_RegWrite <= 1'b0;
            ID_EX_ALUsrc <= 1'b0;
            ID_EX_MemWrite <= 1'b0;
            ID_EX_MemtoReg <= 1'b0;
            ID_EX_MemRead <= 1'b0;
            ID_EX_Branch <= 1'b0;
            ID_EX_JumpJalr <= 1'b0;
            ID_EX_RegDest <= 1'b0;
            ID_EX_ALUsrcLui <= 1'b0;
            ID_EX_ALUsrcAuipc <= 1'b0;
            ID_EX_funct <= 10'b0;
            ID_EX_DMType <= 3'b0;
            ID_EX_ALUOp <= 2'b0;
        end else if (sw_i[1]) begin
            ID_EX_Read_data1 <= ID_EX_Read_data1;
            ID_EX_Read_data2 <= ID_EX_Read_data2;
            ID_EX_imm <= ID_EX_imm;
            ID_EX_PC <= ID_EX_PC;
            ID_EX_Write_register <= ID_EX_Write_register;
            ID_EX_Read_register1 <= ID_EX_Read_register1;
            ID_EX_Read_register2 <= ID_EX_Read_register2;
            ID_EX_RegWrite <= ID_EX_RegWrite;
            ID_EX_ALUsrc <= ID_EX_ALUsrc;
            ID_EX_MemWrite <= ID_EX_MemWrite;
            ID_EX_MemtoReg <= ID_EX_MemtoReg;
            ID_EX_MemRead <= ID_EX_MemRead;
            ID_EX_Branch <= ID_EX_Branch;
            ID_EX_JumpJalr <= ID_EX_JumpJalr;
            ID_EX_RegDest <= ID_EX_RegDest;
            ID_EX_ALUsrcLui <= ID_EX_ALUsrcLui;
            ID_EX_ALUsrcAuipc <= ID_EX_ALUsrcAuipc;
            ID_EX_funct <= ID_EX_funct;
            ID_EX_DMType <= ID_EX_DMType;
            ID_EX_ALUOp <= ID_EX_ALUOp;
        end else begin
            ID_EX_Read_data1 <= Read_data1;
            ID_EX_Read_data2 <= Read_data2;
            ID_EX_imm <= imm;
            ID_EX_PC <= IF_ID_PC;
            ID_EX_Write_register <= IF_ID_instruction[11:7];
            ID_EX_Read_register1 <= IF_ID_instruction[19:15];
            ID_EX_Read_register2 <= IF_ID_instruction[24:20];
            ID_EX_RegWrite <= RegWrite;
            ID_EX_ALUsrc <= ALUsrc;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_MemtoReg <= MemtoReg;
            ID_EX_MemRead <= MemRead;
            ID_EX_Branch <= Branch;
            ID_EX_JumpJalr <= JumpJalr;
            ID_EX_RegDest <= RegDest;
            ID_EX_ALUsrcLui <= ALUsrcLui;
            ID_EX_ALUsrcAuipc <= ALUsrcAuipc;
            ID_EX_funct <= {IF_ID_instruction[31:25], IF_ID_instruction[14:12]};
            ID_EX_DMType <= DMType;
            ID_EX_ALUOp <= ALUOp;
        end
    end
    /*--------EX--------*/
    wire [1:0] ForwardA, ForwardB;
    forward_unit u_forward_unit(
        .ID_EX_Read_register1(ID_EX_Read_register1),
        .ID_EX_Read_register2(ID_EX_Read_register2),
        .EX_MEM_Write_register(EX_MEM_Write_register),
        .MEM_WB_Write_register(MEM_WB_Write_register),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    wire [31:0] forward_mux_res1;
    forward_mux u_forward_mux_1(
        .A(mux_res8),
        .B(mux_res4),
        .C(EX_MEM_ALUresult),
        .Forward(ForwardA),
        .res(forward_mux_res1)
    );
    wire [31:0] forward_mux_res2;
    forward_mux u_forward_mux_2(
        .A(ID_EX_Read_data2),
        .B(mux_res4),
        .C(EX_MEM_ALUresult),
        .Forward(ForwardB),
        .res(forward_mux_res2)
    );
    wire [3:0] ALUoperation;
    ALUcontrol u_ALUcontrol(
        .funct(ID_EX_funct),
        .ALUOp(ID_EX_ALUOp),
        .ALUoperation(ALUoperation)
    );
    wire [31:0] mux_res1;
    mux u_mux1( // 寄存器值与后面计算的结果 or 立即数
        .x(forward_mux_res2),
        .y(ID_EX_imm),
        .signal(ID_EX_ALUsrc),
        .z(mux_res1)
    );
    wire [31:0] mux_res7;
    mux u_mux7( // lui 硬编码 Read_data1 为 0
        .x(ID_EX_Read_data1),
        .y(0),
        .signal(ID_EX_ALUsrcLui),
        .z(mux_res7)
    );
    wire [31:0] mux_res8;
    mux u_mux8( // auipc 硬编码 Read_data1 为 PC + imm
        .x(mux_res7),
        .y(ID_EX_PC),
        .signal(ID_EX_ALUsrcAuipc),
        .z(mux_res8)
    );
    wire [31:0] ALUresult;
    wire Zero, Negative, Overflow, Carry;
    alu u_alu(
        .ALUoperation(ALUoperation),
        .A(forward_mux_res1),
        .B(mux_res1),
        .ALUresult(ALUresult),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );
    wire jump_taken;
    jump u_jump(
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry),
        .funct3(ID_EX_funct[2:0]),
        .jump_taken(jump_taken)
    );
    wire [31:0] mux_res3;
    mux u_mux3( // 跳转写回 PC 的逻辑
        .x(PC + 4),
        .y(ID_EX_PC + ID_EX_imm),
        .signal(jump_taken & ID_EX_Branch),
        .z(mux_res3)
    );
    wire [31:0] mux_res5;
    mux u_mux5( // 针对 JALR 指令
        .x(mux_res3),
        .y(ALUresult),
        .signal(ID_EX_JumpJalr),
        .z(mux_res5)
    );
    mux u_mux6( // 针对 JAL 指令
        .x(mux_res5),
        .y(IF_ID_PC + imm),
        .signal(JumpJal),
        .z(next_PC)
    );
    wire IF_ID_Flush, ID_EX_Flush;
    assign IF_ID_Flush = (JumpJal || (jump_taken && ID_EX_Branch) || ID_EX_JumpJalr) ? 1 : 0;
    assign ID_EX_Flush = ((jump_taken && ID_EX_Branch) || ID_EX_JumpJalr) ? 1 : 0;
    reg [31:0] EX_MEM_PC;
    reg [31:0] EX_MEM_ALUresult, EX_MEM_Read_data2;
    reg [4:0] EX_MEM_Write_register;
    reg EX_MEM_RegWrite, EX_MEM_MemWrite, EX_MEM_MemtoReg, EX_MEM_MemRead, EX_MEM_RegDest;
    reg [2:0] EX_MEM_DMType;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn)begin
            EX_MEM_PC <= 32'b0;
            EX_MEM_ALUresult <= 32'b0;
            EX_MEM_Read_data2 <= 32'b0;
            EX_MEM_Write_register <= 5'b0;
            EX_MEM_RegWrite <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_MemtoReg <= 0;
            EX_MEM_MemRead <= 0;
            EX_MEM_RegDest <= 0;
            EX_MEM_DMType <= 3'b0;
        end
        else if (sw_i[1]) begin
            EX_MEM_PC <= EX_MEM_PC;
            EX_MEM_ALUresult <= EX_MEM_ALUresult;
            EX_MEM_Read_data2 <= EX_MEM_Read_data2;
            EX_MEM_Write_register <= EX_MEM_Write_register;
            EX_MEM_RegWrite <= EX_MEM_RegWrite;
            EX_MEM_MemWrite <= EX_MEM_MemWrite;
            EX_MEM_MemtoReg <= EX_MEM_MemtoReg;
            EX_MEM_MemRead <= EX_MEM_MemRead;
            EX_MEM_RegDest <= EX_MEM_RegDest;
            EX_MEM_DMType <= EX_MEM_DMType;
        end
        else begin
            EX_MEM_PC <= ID_EX_PC;
            EX_MEM_ALUresult <= ALUresult;
            EX_MEM_Read_data2 <= forward_mux_res2;
            EX_MEM_Write_register <= ID_EX_Write_register;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_RegDest <= ID_EX_RegDest;
            EX_MEM_DMType <= ID_EX_DMType;
        end
    end
    /*--------MEM--------*/
    wire [31:0] Read_data;
    dm u_dm(
        .clk(clk_1s),
        .rstn(rstn),
        .MemWrite(EX_MEM_MemWrite),
        .MemRead(EX_MEM_MemRead),
        .DMType(EX_MEM_DMType),
        .Address(EX_MEM_ALUresult),
        .Write_data(EX_MEM_Read_data2),
        .Read_data(Read_data)
    );
    reg [31:0] MEM_WB_PC;
    reg [31:0] MEM_WB_ALUresult, MEM_WB_Read_data;
    reg [4:0] MEM_WB_Write_register;
    reg MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_RegDest;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) begin
            MEM_WB_PC <= 32'b0;
            MEM_WB_ALUresult <= 32'b0;
            MEM_WB_Read_data <= 32'b0;
            MEM_WB_Write_register <= 5'b0;
            MEM_WB_RegWrite <= 1'b0;
            MEM_WB_MemtoReg <= 1'b0;
            MEM_WB_RegDest <= 1'b0;
        end else if (sw_i[1]) begin
            MEM_WB_PC <= MEM_WB_PC;
            MEM_WB_ALUresult <= MEM_WB_ALUresult;
            MEM_WB_Read_data <= MEM_WB_Read_data;
            MEM_WB_Write_register <= MEM_WB_Write_register;
            MEM_WB_RegWrite <= MEM_WB_RegWrite;
            MEM_WB_MemtoReg <= MEM_WB_MemtoReg;
            MEM_WB_RegDest <= MEM_WB_RegDest;
        end else begin
            MEM_WB_PC <= EX_MEM_PC;
            MEM_WB_ALUresult <= EX_MEM_ALUresult;
            MEM_WB_Read_data <= Read_data;
            MEM_WB_Write_register <= EX_MEM_Write_register;
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
            MEM_WB_RegDest <= EX_MEM_RegDest;
        end
    end
    /*--------WB--------*/
    wire [31:0] mux_res2;
    mux u_mux2( // 是否读内存
        .x(MEM_WB_ALUresult),
        .y(MEM_WB_Read_data),
        .signal(MEM_WB_MemtoReg),
        .z(mux_res2)
    );
    wire [31:0] mux_res4;
    mux u_mux4( // 针对 jal 和 jalr 的写回寄存器 PC + 4
        .x(mux_res2),
        .y(MEM_WB_PC + 4),
        .signal(MEM_WB_RegDest),
        .z(mux_res4)
    );
    /* 调试部分 */
    /*
    // 寄存器
    reg [4:0] reg_addr;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn)reg_addr <= 5'b0;
        else reg_addr <= reg_addr + 1;
    end
    // ALU结果
    reg [1:0] alu_addr;
    reg [31:0] alu_res;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn)alu_addr <= 2'b0;
        else begin
            alu_addr <= alu_addr + 1;
            case(alu_addr)
                2'b00: alu_res <= Read_data1;
                2'b01: alu_res <= mux_res1;
                2'b10: alu_res <= ALUresult;
                2'b11: alu_res <= Zero;
            endcase
        end
    end
    // 数据存储器
    reg [5:0] dm_addr;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn)dm_addr <= 6'b0;
        else dm_addr <= dm_addr + 1;
    end
    // 其它
    reg [1:0] pc_addr;
    reg [31:0] wtf;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn)pc_addr <= 2'b0;
        else begin
            pc_addr <= pc_addr + 1;
            case(pc_addr)
                2'b00: wtf <= PC;
                2'b01: wtf <= next_PC;
                2'b10: wtf <= imm;
                2'b11: wtf <= imm + PC;
            endcase
        end
    end
    reg [31:0] display_data;
    always @(posedge clk_1s or negedge rstn) begin
        if (!rstn) begin
            display_data <= 32'b0;
        end else begin
            case(sw_i[14:10])
                5'b10000: display_data <= PC;
                5'b01000: display_data <= {35'b0, reg_addr, u_rf.Registers[reg_addr][23:0]};
                5'b00100: display_data <= {32'b0, alu_res};
                5'b00010: display_data <= {34'b0, dm_addr, 16'b0, u_dm.data[dm_addr]};
                5'b00001: display_data <= {32'b0, wtf};
                default: display_data <= 32'b0;
            endcase
        end
    end
    alg u_alg(
        .clk(clk),
        .rstn(rstn),
        .i_data(display_data),
        .disp_mode(sw_i[0]),
        .o_seg(disp_seg_o),
        .o_sel(disp_an_o)
    );
    */
endmodule
