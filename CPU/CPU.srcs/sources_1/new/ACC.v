`timescale 1ns / 1ps

module ACC(
    input clk,
    input rst,
    input C9,               // ALU to ACC
    input C10,              // MBR to ACC
    input [15:0] alu2acc,    // data from ALU
    input [15:0] mbr2acc,    // data from MBR
    output reg [15:0] acc_out
    );

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            acc_out = 0;
        else if (C9)
            acc_out = alu2acc;
        else if (C10)
            acc_out = mbr2acc;
    end
endmodule
