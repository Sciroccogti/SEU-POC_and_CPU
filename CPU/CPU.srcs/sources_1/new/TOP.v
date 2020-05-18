`timescale 1ns / 1ps

module TOP_noflag(
    input clk,
    input rst
);

    wire [15:0] br2alu, alu2mr, alu2acc, mbr_out, acc_out, mr_out, ram_out, c;
    wire [7:0] ir_out, pc_out, mar_out;
    wire [3:0] cu2alu;

    ACC acc(clk, rst, c[9], c[10], alu2acc, mbr_out, acc_out);

    ALU alu(clk, c[7], c[14], cu2alu, acc_out, br2alu, alu2mr, alu2acc);

    BR br(clk, rst, c[6], mbr_out, br2alu);

    CU cu(clk, rst, ir_out, c, cu2alu);

    IR ir(clk, rst, c[4], mbr_out[15:8], ir_out);

    MAR mar(clk, rst, c[2], c[8], pc_out, mbr_out, mar_out);

    MBR mbr(clk, rst, c[1], c[5], c[11], c[13], acc_out, ram_out, pc_out, mr_out, mbr_out);

    MR mr(clk, rst, c[9], alu2mr, mr_out);

    PC pc(clk, rst, c[3], c[15], mbr_out[15:8], pc_out);

    RAM_mod ram_mod(clk, rst, c[0], c[12], mar_out, mbr_out, ram_out);

endmodule // TOP_noflag

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