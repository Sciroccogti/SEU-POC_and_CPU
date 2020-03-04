`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/04 18:59:34
// Design Name: 
// Module Name: poc
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


module poc(
    // with Processor
    input CLK,
    input RW,           // Read: 0, Write: 1
    input [7:0] Din,    // 
    input ADDR,         // address, SR: 0, BR: 0
    // input SR0,          // Interrupt bit, switch mode
    output IRQ,         // interrupt request
    output reg [7:0] Dout,

    // with Printer
    input RDY,          // Ready
    output reg TR,      // Transport Request
    output reg [7:0] PD     // Parallel Data
    );

    reg [7:0] SR = 8'b00000000; // Status Register, SR7:Ready flag bit, SR0:Interrupt bit
    reg [7:0] BR = 8'b00000000; // Buffer Register

    reg [7:0] SRbuf;
    reg [7:0] BRbuf;

    reg [1:0] stat = 2'b00; // stat flag
    // 00: waiting for cpu
    // 01: contacting with printer
    // 10: printing

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
                SRbuf[7:0] = Din[7:0];
            else // BR
                BRbuf[7:0] = Din[7:0];
        end
    end

    always @(posedge CLK)
    begin
        if(SR[0] == 0) // 查询方式
        begin
            case(stat)
            2'b00: // waiting for cpu
            begin
                if(SR[7] == 0) // CPU已经写入新数据但尚未被处理
                begin // start to fetch data
                    stat = 2'b01;
                    BR[7:0] = BRbuf[7:0];
                    SR[7:0] = SRbuf[7:0];
                    SR[7] = 1;
                end
            end

            2'b01: // contacting with printer
            begin
                if(RDY == 1) // printer is ready
                begin // start to contact
                    stat = 2'b10;
                    TR = 1;
                    PD[7:0] = BR[7:0];
                end
            end

            2'b10: // printing 
            begin
                if(RDY == 0) // printed
                begin
                    stat = 2'b00;
                    TR = 0;
                end
            end

            default:;
            endcase
        end        
    end

endmodule
