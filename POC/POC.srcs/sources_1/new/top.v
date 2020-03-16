`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/05 22:25:20
// Design Name: 
// Module Name: Top
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


module Top(
    input CLK,
    input switch,
    input print,
    input [7:0] data,
    output [7:0] data_out
    );
    
    wire RW;
    wire [7:0] Din;
    wire ADDR;
    wire IRQ;
    wire [7:0] Dout;

    wire RDY;
    wire TR;
    wire [7:0] PD;
    
    Processor processor(CLK, print, data[7:0], RW, Din[7:0], ADDR, IRQ, Dout[7:0]);
    
    Poc poc(switch, CLK, RW, Din[7:0], ADDR, IRQ, Dout[7:0], RDY, TR, PD[7:0]);

    Printer printer(CLK, TR, PD[7:0], RDY, data_out[7:0]);

endmodule
