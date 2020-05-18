`timescale 1ns / 1ps

module test_nonflag(

);

    reg clk;
    reg rst = 0;

    TOP_noflag top_noflag(clk, rst);

    initial // set the clock
    begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial
    begin
        #4
        rst = 1;

        // #4 // 准备数据
        // mbr2acc = 16'hfffe;
        // mbr2br = 16'h0002;
        // C[6] = 1;
        // C[10] = 1;

        // #4 // 调用ALU
        // CU[2:0] = MPY;
        // C = 16'h0;
        // C[14] = 1;
        // C[7] = 1;

        // #4 // 读出ALU
        // C = 16'h0;
        // C[9] = 1;

        // #4
        // rst = 0;

        #100
        $finish;
    end
endmodule // test_nonflag