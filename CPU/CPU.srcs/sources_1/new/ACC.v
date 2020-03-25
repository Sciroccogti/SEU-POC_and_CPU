`timescale 1ns / 1ps

module ACC(
    input clk,
    input rst,
    input C9,               // ALU to ACC
    input C10,              // MBR to ACC
    input [15:0] MBR_in,    // data from MBR
    input [15:0] ALU_in,    // data from ALU
    output [15:0] ACC_out
    );

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            ACC_out = 0;
        else if (C9)
            ACC_out = MBR_in;
        else if (C10)
            ACC_out = ALU_in;
    end
endmodule
