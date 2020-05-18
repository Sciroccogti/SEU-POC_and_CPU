`timescale 1ns / 1ps

module TOP_sim(
    input clk,
    input rst
);

    wire [15:0] br2alu, alu2mr, alu2acc, mbr_out, acc_out, mr_out, ram_out, c;
    wire [7:0] ir_out, pc_out, mar_out;
    wire [5:0] flags;
    wire [3:0] cu2alu;

    ACC acc(clk, rst, c[9], c[10], alu2acc, mbr_out, acc_out);

    ALU alu(clk, c[7], c[14], cu2alu, acc_out, br2alu, alu2mr, alu2acc, flags);

    BR br(clk, rst, c[6], mbr_out, br2alu);

    CU cu(clk, rst, ir_out, flags, c, cu2alu);

    IR ir(clk, rst, c[4], mbr_out[15:8], ir_out);

    MAR mar(clk, rst, c[2], c[8], pc_out, mbr_out[7:0], mar_out);

    MBR mbr(clk, rst, c[1], c[5], c[11], c[13], acc_out, ram_out, pc_out, mr_out, mbr_out);

    MR mr(clk, rst, c[9], alu2mr, mr_out);

    PC pc(clk, rst, c[3], c[15], mbr_out[15:8], pc_out);

    RAM_mod ram_mod(clk, rst, c[0], c[12], mar_out, mbr_out, ram_out);

endmodule // TOP_sim

module TOP_alu(
    input clk,
    input rst,
    input [15:0] c, // control signals
    input [3:0] cu,
    input [15:0] mbr2acc,
    input [15:0] mbr2br
);

    wire [15:0] br2alu, alu2mr, alu2acc, acc_out, mr_out;
    wire [5:0] flags;

    ALU alu(clk, c[7], c[14], cu, acc_out, br2alu, alu2mr, alu2acc, flags);

    ACC acc(clk, rst, c[9], c[10], alu2acc, mbr2acc, acc_out);

    BR br(clk, rst, c[6], mbr2br, br2alu);

    MR mr(clk, rst, c[9], alu2mr, mr_out);

endmodule // TOP_alu