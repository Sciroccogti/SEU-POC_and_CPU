`timescale 1ns / 1ps
`include "params.v"
// TODO: addition overflow
module ALU(
    input clk,
    input C7,               // ACC to ALU
    input C14,              // BR to ALU
    input [3:0] cu2alu,      // signal from CU
    input [15:0] acc2alu,    // data from ACC
    input [15:0] br2alu,     // data from BR

    output reg [15:0] alu2mr,   // data to MR
    output reg [15:0] alu2acc   // data to ACC
    );

    reg [15:0] acc_in;
    reg [15:0] br_in;
    reg [31:0] temp = 0;
    integer i;

    always @(negedge clk)
    begin
        if (C7)
            acc_in = acc2alu;
        if (C14)
            br_in = br2alu;
    end

    always @(negedge clk)
    begin
        case (cu2alu)
            ADD: // ADD
                alu2acc = acc_in + br_in;
            SUB: // SUB
                alu2acc = acc_in - br_in;
            AND: // AND
                alu2acc = acc_in & br_in;
            OR: // OR
                alu2acc = acc_in | br_in;
            NOT: // NOT
                alu2acc = ~acc_in;
            SRL: // SRL
                alu2acc = acc_in << 1;
            SRR6: // SRR
                alu2acc = acc_in >> 1;
            MPY: // MPY
            begin
                for (i = 0; i < 16; i = i + 1)
                begin
                    if (br_in[i])
                        temp = temp + (acc_in << i);
                end
                alu2acc = temp[15:0];
                alu2mr = temp[31:16];
                temp = 0;
            end
            default:
                alu2acc = 0;
        endcase 
    end

endmodule
