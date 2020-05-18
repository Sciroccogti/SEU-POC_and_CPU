`timescale 1ns / 1ps

module test_ALU(

    );

    // para for operation(cu2alu)
    parameter ADD = 4'd1;
    parameter SUB = 4'd2;
    parameter AND = 4'd3;
    parameter OR = 4'd4;
    parameter NOT = 4'd5;
    parameter SRL = 4'd6;
    parameter SRR = 4'd7;
    parameter MPY = 4'd8;

    reg clk;
    reg rst = 0;
    reg [15:0] C = 0;
    reg [3:0] CU = 0;
    reg [15:0] mbr2acc = 0;
    reg [15:0] mbr2br = 0;

    TOP_alu top_alu(clk, rst, C, CU, mbr2acc, mbr2br);

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
        mbr2acc = 16'hfffa;
        mbr2br = 16'hfffb;
        C[6] = 1;
        C[10] = 1;

        #4 // 调用ALU
        CU[3:0] = MPY;
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
