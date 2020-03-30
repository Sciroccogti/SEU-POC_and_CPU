`timescale 1ns / 1ps

module TOP_alu(
    input clk,
    input rst,
    input [15:0] c, // control signals
    input [2:0] cu,
    input [15:0] mbr2acc,
    input [15:0] mbr2br
);

    wire [15:0] br2alu, alu2mr, alu2acc, acc_out, mr_out;

    ALU alu(clk, c[7], c[14], cu[2:0], acc_out[15:0], br2alu[15:0], 
            alu2mr[15:0], alu2acc[15:0]);

    ACC acc(clk, rst, c[9], c[10], mbr2acc[15:0], alu2acc[15:0], acc_out[15:0]);

    BR br(clk, rst, c[6], mbr2br[15:0], br2alu);

    MR mr(clk, rst, c[9], alu2mr[15:0], mr_out[15:0]);

endmodule // TOP_alu