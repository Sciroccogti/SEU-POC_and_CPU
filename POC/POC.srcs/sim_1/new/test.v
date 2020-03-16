`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 10:41:18
// Design Name: 
// Module Name: test
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


module test(

    );
    reg CLK;
    reg switch; // 查询: 0, 中断: 1
    reg print = 0; // print signal, print: 1
    reg [7:0] data;
    wire [7:0] data_out;

    Top top(CLK, switch, print, data[7:0], data_out[7:0]);

    initial // set the clock
    begin
        CLK = 0;
        forever #1 CLK = ~CLK;
    end

    initial // set the excitation
    begin
        // 1: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b00010001;
        print = 1;
        #100
        print = 0;
        #100

        // 2: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b00100010;
        print = 1;
        #100
        print = 0;
        #100

        // 3: 中断方式
        switch = 1;
        #100
        data[7:0] = 8'b00110011;
        print = 1;
        #100
        print = 0;
        #100

        // 4: 中断方式
        switch = 1;
        #100
        data[7:0] = 8'b01000100;
        print = 1;
        #100
        print = 0;
        #100

        // 5: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b01010101;
        print = 1;
        #100
        print = 0;
        #100
        $finish;
    end
endmodule
