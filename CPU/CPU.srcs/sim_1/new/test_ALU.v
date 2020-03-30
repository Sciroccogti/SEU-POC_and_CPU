`timescale 1ns / 1ps

module test_ALU(

    );

    parameter ADD = 3'd0;
    parameter SUB = 3'd1;
    parameter AND = 3'd2;
    parameter OR = 3'd3;
    parameter NOT = 3'd4;
    parameter SRL = 3'd5;
    parameter SRR = 3'd6;
    parameter MPY = 3'd7;

    reg clk;
    reg rst = 0;
    reg [15:0] C = 0;
    reg [2:0] CU = 0;
    reg [15:0] mbr2acc = 0;
    reg [15:0] mbr2br = 0;

    TOP_alu top_alu(clk, rst, C[15:0], CU[2:0], mbr2acc[15:0], mbr2br[15:0]);

    initial // set the clock
    begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial
    begin
        #4
        rst = 1;

        #4 // 准备数据
        mbr2acc = 16'hfffe;
        mbr2br = 16'h0002;
        C[6] = 1;
        C[10] = 1;

        #4 // 调用ALU
        CU[2:0] = MPY;
        C = 16'h0;
        C[14] = 1;
        C[7] = 1;

        #4 // 读出ALU
        C = 16'h0;
        C[9] = 1;

        #4
        rst = 0;

        #4
        $finish;
    end

endmodule
