`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Stage 3: Five-stage pipeline with I-type + R-type ALU (+ LUI, AUIPC)
// No forwarding, no hazard detection, no jump/branch, no load/store
//////////////////////////////////////////////////////////////////////////////////

module main(
        input clk,
        input rstn
    );

    wire clk_cpu = clk;

    reg [31:0] PC;
    wire [31:0] instruction;

    /*--------IF--------*/
    always @(posedge clk_cpu or negedge rstn) begin
        if (!rstn) PC <= 32'b0;
        else       PC <= PC + 4;
    end

    instructions u_instructions(
        .PC(PC),
        .instruction(instruction)
    );

    // IF/ID pipeline register
    reg [31:0] IF_ID_PC;
    reg [31:0] IF_ID_instruction;
    always @(posedge clk_cpu or negedge rstn) begin
        if (!rstn) begin
            IF_ID_PC          <= 32'b0;
            IF_ID_instruction <= 32'b0;
        end else begin
            IF_ID_PC          <= PC;
            IF_ID_instruction <= instruction;
        end
    end

    /*--------ID--------*/
    wire RegWrite, ALUsrc, ALUsrcLui, ALUsrcAuipc;
    wire [1:0] ALUOp;

    control u_control(
        .opcode(IF_ID_instruction[6:0]),
        .RegWrite(RegWrite),
        .ALUsrc(ALUsrc),
        .ALUsrcLui(ALUsrcLui),
        .ALUsrcAuipc(ALUsrcAuipc),
        .ALUOp(ALUOp)
    );

    wire [31:0] Read_data1, Read_data2;
    rf u_rf(
        .clk(clk_cpu),
        .rstn(rstn),
        .RegWrite(MEM_WB_RegWrite),
        .Read_register1(IF_ID_instruction[19:15]),
        .Read_register2(IF_ID_instruction[24:20]),
        .Write_register(MEM_WB_Write_register),
        .Write_data(MEM_WB_ALUresult),
        .Read_data1(Read_data1),
        .Read_data2(Read_data2)
    );

    wire signed [31:0] imm;
    immgen u_immgen(
        .instruction(IF_ID_instruction),
        .imm(imm)
    );

    // ID/EX pipeline register
    reg [31:0] ID_EX_PC;
    reg [31:0] ID_EX_Read_data1, ID_EX_Read_data2;
    reg signed [31:0] ID_EX_imm;
    reg [4:0]  ID_EX_Write_register;
    reg        ID_EX_RegWrite, ID_EX_ALUsrc, ID_EX_ALUsrcLui, ID_EX_ALUsrcAuipc;
    reg [9:0]  ID_EX_funct;
    reg [1:0]  ID_EX_ALUOp;

    always @(posedge clk_cpu or negedge rstn) begin
        if (!rstn) begin
            ID_EX_PC             <= 32'b0;
            ID_EX_Read_data1     <= 32'b0;
            ID_EX_Read_data2     <= 32'b0;
            ID_EX_imm            <= 32'b0;
            ID_EX_Write_register <= 5'b0;
            ID_EX_RegWrite       <= 1'b0;
            ID_EX_ALUsrc         <= 1'b0;
            ID_EX_ALUsrcLui      <= 1'b0;
            ID_EX_ALUsrcAuipc    <= 1'b0;
            ID_EX_funct          <= 10'b0;
            ID_EX_ALUOp          <= 2'b0;
        end else begin
            ID_EX_PC             <= IF_ID_PC;
            ID_EX_Read_data1     <= Read_data1;
            ID_EX_Read_data2     <= Read_data2;
            ID_EX_imm            <= imm;
            ID_EX_Write_register <= IF_ID_instruction[11:7];
            ID_EX_RegWrite       <= RegWrite;
            ID_EX_ALUsrc         <= ALUsrc;
            ID_EX_ALUsrcLui      <= ALUsrcLui;
            ID_EX_ALUsrcAuipc    <= ALUsrcAuipc;
            ID_EX_funct          <= {IF_ID_instruction[31:25], IF_ID_instruction[14:12]};
            ID_EX_ALUOp          <= ALUOp;
        end
    end

    /*--------EX--------*/
    wire [3:0] ALUoperation;
    ALUcontrol u_ALUcontrol(
        .funct(ID_EX_funct),
        .ALUOp(ID_EX_ALUOp),
        .ALUoperation(ALUoperation)
    );

    // ALUsrc mux: register value vs immediate
    wire [31:0] alu_b;
    mux u_mux_alusrc(
        .x(ID_EX_Read_data2),
        .y(ID_EX_imm),
        .signal(ID_EX_ALUsrc),
        .z(alu_b)
    );

    // LUI mux: force A = 0
    wire [31:0] lui_out;
    mux u_mux_lui(
        .x(ID_EX_Read_data1),
        .y(32'b0),
        .signal(ID_EX_ALUsrcLui),
        .z(lui_out)
    );

    // AUIPC mux: force A = PC
    wire [31:0] alu_a;
    mux u_mux_auipc(
        .x(lui_out),
        .y(ID_EX_PC),
        .signal(ID_EX_ALUsrcAuipc),
        .z(alu_a)
    );

    wire [31:0] ALUresult;
    wire Zero, Negative, Overflow, Carry;
    alu u_alu(
        .ALUoperation(ALUoperation),
        .A(alu_a),
        .B(alu_b),
        .ALUresult(ALUresult),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );

    // EX/MEM pipeline register
    reg [31:0] EX_MEM_ALUresult;
    reg [4:0]  EX_MEM_Write_register;
    reg        EX_MEM_RegWrite;

    always @(posedge clk_cpu or negedge rstn) begin
        if (!rstn) begin
            EX_MEM_ALUresult      <= 32'b0;
            EX_MEM_Write_register <= 5'b0;
            EX_MEM_RegWrite       <= 1'b0;
        end else begin
            EX_MEM_ALUresult      <= ALUresult;
            EX_MEM_Write_register <= ID_EX_Write_register;
            EX_MEM_RegWrite       <= ID_EX_RegWrite;
        end
    end

    /*--------MEM--------*/
    // Stage 3: no memory access, pass through

    // MEM/WB pipeline register
    reg [31:0] MEM_WB_ALUresult;
    reg [4:0]  MEM_WB_Write_register;
    reg        MEM_WB_RegWrite;

    always @(posedge clk_cpu or negedge rstn) begin
        if (!rstn) begin
            MEM_WB_ALUresult      <= 32'b0;
            MEM_WB_Write_register <= 5'b0;
            MEM_WB_RegWrite       <= 1'b0;
        end else begin
            MEM_WB_ALUresult      <= EX_MEM_ALUresult;
            MEM_WB_Write_register <= EX_MEM_Write_register;
            MEM_WB_RegWrite       <= EX_MEM_RegWrite;
        end
    end

    /*--------WB--------*/
    // Write-back is handled by rf: MEM_WB_RegWrite + MEM_WB_Write_register + MEM_WB_ALUresult

endmodule
