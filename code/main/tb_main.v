`timescale 1ns / 1ps

module tb_main();

    reg clk;
    reg rstn;

    main u_main(
        .clk(clk),
        .rstn(rstn)
    );

    // 100MHz clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset and run
    initial begin
        rstn = 0;
        #20;
        rstn = 1;
        #500;
        $finish;
    end

    // Waveform dump (for iVerilog/GTKWave)
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_main);
    end

endmodule
