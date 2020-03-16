`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/04 18:59:34
// Design Name: 
// Module Name: Poc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// A
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Poc(
    input switch,       // choose mode, 查询: 0, 中断: 1
    // with Processor
    input CLK,
    input RW,           // Read: 0, Write: 1
    input [7:0] Din,    // 
    input ADDR,         // address, SR: 0, BR: 1
    // input SR0,          // Interrupt bit, switch mode
    output reg IRQ,         // interrupt request, request: 0
    output reg [7:0] Dout,

    // with Printer
    input RDY,          // Ready
    output reg TR,      // Transport Request
    output reg [7:0] PD     // Parallel Data
    );

    reg [7:0] SR = 8'b00000000; // Status Register, SR7:Ready flag bit, SR0:Interrupt bit
    reg [7:0] BR = 8'b00000000; // Buffer Register

    // reg [7:0] SRbuf; // 异步？
    // reg [7:0] BRbuf;

    reg [1:0] stat = 2'b00; // stat flag
    // 00: waiting for cpu
    // 01: contacting with printer
    // 10: printing

    // with CPU
    always @(posedge CLK)
    begin
        if(RW == 0) // read
        begin
            if(ADDR == 0) // SR
                Dout[7:0] = SR[7:0];
            else // BR
                Dout[7:0] = BR[7:0];
        end

        else // write
        begin
            if(ADDR == 0) // SR
                SR[7:0] = Din[7:0];
            else // BR
                BR[7:0] = Din[7:0];
        end
    end

    // with Printer
    always @(posedge CLK)
    begin
        SR[0] = switch;
        case(stat)
        2'b00: // waiting for cpu
        begin
            if(SR[7] == 0) // CPU已经写入新数据但尚未被处理
            begin // start to fetch data
                stat = 2'b01;
                // BR[7:0] = BRbuf[7:0];
                // SR[7:0] = SRbuf[7:0];
            end
        end

        2'b01: // contacting with printer
        begin
            if(RDY == 1) // printer is ready
            begin // start to contact
                stat = 2'b10;
                PD[7:0] = BR[7:0];
                TR = 1;
            end
        end

        2'b10: // printing 
        begin
            if(RDY == 0) // printed
            begin
                stat = 2'b00;
                TR = 0;
                SR[7] = 1;
            end
        end

        default:;
        endcase   
    end

    // IRQ
    always @(posedge CLK)
    begin
        if (SR[7] == 1 && SR[0] == 1)
            IRQ = 0;
        else
            IRQ = 1;
    end

endmodule
