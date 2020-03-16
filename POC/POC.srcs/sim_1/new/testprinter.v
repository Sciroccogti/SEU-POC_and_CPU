`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 11:29:53
// Design Name: 
// Module Name: testprinter
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


module testprinter(

    );
    reg CLK;
    reg [7:0] data;
    reg TR = 0; // Transport Request
    wire [7:0] data_out;
    wire RDY;

    Printer pri(CLK, TR, data[7:0], RDY, data_out[7:0]);

    initial // set the clock
    begin
        CLK = 0;
        forever #1 CLK = ~CLK;
    end

    initial // set the excitation
    begin
        // 1: 查询方式
        #100
        data[7:0] = 8'b00010001;
        TR = 1;
        #100
        TR = 0;
        #100

        // 2: 查询方式
        #100
        data[7:0] = 8'b00100010;
        TR = 1;
        #100
        TR = 0;
        #100

        // 3: 中断方式
        #100
        data[7:0] = 8'b00110011;
        TR = 1;
        #100
        TR = 0;
        #100

        // 4: 中断方式
        #100
        data[7:0] = 8'b01000100;
        TR = 1;
        #100
        TR = 0;
        #100

        // 5: 查询方式
        #100
        data[7:0] = 8'b01010101;
        TR = 1;
        #100
        TR = 0;
        #100
        $finish;
    end
endmodule
