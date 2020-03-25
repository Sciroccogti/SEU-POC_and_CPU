`timescale 1ns / 1ps

module BR(
    input clk,
    input rst,
    input C6,               // MBR to BR
    input [15:0] MBR_in,    // data from MBR
    output [15:0] BR_out = 0
    );

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            BR_out = 0;
        else if (C6)
            BR_out = MBR_in;
    end

endmodule
