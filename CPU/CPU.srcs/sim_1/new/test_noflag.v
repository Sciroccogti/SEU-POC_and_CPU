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

endmodule // test_nonflag