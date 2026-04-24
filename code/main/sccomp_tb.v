`timescale 1ns / 1ps

module main_tb();

    reg clk, rstn;

    integer foutput;
    integer counter = 0;

    // 实例化你的 CPU 顶层
    main U_MAIN(
        .clk(clk),
        .rstn(rstn)
    );

    initial begin
        // 从 dat 文件加载指令到 instruction memory
        $readmemh("Test_8_Instr.dat", U_MAIN.u_instructions.imem);

        foutput = $fopen("results.txt");

        clk = 1;
        rstn = 1;
        #5;
        rstn = 0;
        #20;
        rstn = 1;
    end

    always begin
        #50 clk = ~clk;

        if (clk == 1'b1) begin
            if ((counter == 1000) || (U_MAIN.PC === 32'hxxxxxxxx)) begin
                $fclose(foutput);
                $stop;
            end
            else begin
                // 停止地址按测试程序改
                if (U_MAIN.PC == 32'h00000050) begin
                    counter = counter + 1;

                    $fdisplay(foutput, "pc:\t\t %h", U_MAIN.PC);
                    $fdisplay(foutput, "instr:\t\t %h", U_MAIN.instruction);

                    $fdisplay(foutput, "rf00-03:\t %h %h %h %h",
                        0,
                        U_MAIN.u_rf.Registers[1],
                        U_MAIN.u_rf.Registers[2],
                        U_MAIN.u_rf.Registers[3]
                    );

                    $fdisplay(foutput, "rf04-07:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[4],
                        U_MAIN.u_rf.Registers[5],
                        U_MAIN.u_rf.Registers[6],
                        U_MAIN.u_rf.Registers[7]
                    );

                    $fdisplay(foutput, "rf08-11:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[8],
                        U_MAIN.u_rf.Registers[9],
                        U_MAIN.u_rf.Registers[10],
                        U_MAIN.u_rf.Registers[11]
                    );

                    $fdisplay(foutput, "rf12-15:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[12],
                        U_MAIN.u_rf.Registers[13],
                        U_MAIN.u_rf.Registers[14],
                        U_MAIN.u_rf.Registers[15]
                    );

                    $fdisplay(foutput, "rf16-19:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[16],
                        U_MAIN.u_rf.Registers[17],
                        U_MAIN.u_rf.Registers[18],
                        U_MAIN.u_rf.Registers[19]
                    );

                    $fdisplay(foutput, "rf20-23:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[20],
                        U_MAIN.u_rf.Registers[21],
                        U_MAIN.u_rf.Registers[22],
                        U_MAIN.u_rf.Registers[23]
                    );

                    $fdisplay(foutput, "rf24-27:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[24],
                        U_MAIN.u_rf.Registers[25],
                        U_MAIN.u_rf.Registers[26],
                        U_MAIN.u_rf.Registers[27]
                    );

                    $fdisplay(foutput, "rf28-31:\t %h %h %h %h",
                        U_MAIN.u_rf.Registers[28],
                        U_MAIN.u_rf.Registers[29],
                        U_MAIN.u_rf.Registers[30],
                        U_MAIN.u_rf.Registers[31]
                    );

                    $fclose(foutput);
                    $stop;
                end
                else begin
                    counter = counter + 1;
                end
            end
        end
    end

endmodule