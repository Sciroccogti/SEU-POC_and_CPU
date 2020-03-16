`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/04 22:31:45
// Design Name: 
// Module Name: Processor
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


module Processor(
    input CLK,
    input print,        // print signal, print: 1
    input [7:0] data,   //
    // with POC
    output reg RW = 0,      // Read: 0, Write: 1
    output reg [7:0] Din,   // 
    output reg ADDR,        // address, SR: 0, BR: 1
    input IRQ,          // interrupt request, request: 0
    input [7:0] Dout
    );

    always @(posedge CLK)
    begin
        if (IRQ == 0) // 中断方式
        begin
            if (print == 1) // start to print
            begin
                Din[7:0] = data[7:0];
                ADDR = 1; // write BR
                RW = 1;
                #4
                Din[7:0] = 8'b00000001; // set SR7 = 0
                ADDR = 0; // write SR
                #4
                RW = 0;
            end
            else 
                RW = 0;
        end

        else // 查询方式
        begin
            if (print == 1) // start to print
            begin
                ADDR = 0; // read SR
                RW = 0;
                #4
                if (Dout[7] == 1) // SR7 == 1, poc is ready
                begin
                    Din[7:0] = data[7:0];
                    ADDR = 1;
                    RW = 1; // write BR
                    #4
                    Din[7:0] = 8'b00000000; // set SR7 = 0
                    ADDR = 0; // write SR
                    #4
                    RW = 0;
                end
            end
            else
                RW = 0;
        end
    end

endmodule
