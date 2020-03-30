`timescale 1ns / 1ps

module BR(
    input clk,
    input rst,
    input C6,               // MBR to BR
    input [15:0] mbr2br,    // data from MBR
    output reg [15:0] br_out = 0
    );

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            br_out = 0;
        else if (C6)
            br_out = mbr2br;
    end

endmodule
