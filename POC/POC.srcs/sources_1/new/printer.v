`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/04 22:31:45
// Design Name: 
// Module Name: Printer
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


module Printer(
    input CLK,
    input TR,                   // Transport Request
    input [7:0] PD,             // Parallel Data
    output reg RDY = 1,             // Ready
    output reg [7:0] data_out
    );

    // reg stat = 1'b0; // stat flag

    always @(posedge CLK)
    begin
        if (TR == 1)
        begin
            RDY = 0;
            data_out[7:0] = PD[7:0];
            RDY = #20 (1);
            data_out[7:0] = 8'b00000000;
        end
    end

endmodule
