`timescale 1ns / 1ps
// `include "params.v"
// TODO: addition overflow

module ALU(
    input clk,
    input C7,                   // ACC to ALU
    input C14,                  // BR to ALU
    input [3:0] cu2alu,         // signal from CU
    input [15:0] acc2alu,       // data from ACC
    input [15:0] br2alu,        // data from BR

    output reg [15:0] alu2mr,   // data to MR
    output reg [15:0] alu2acc,  // data to ACC
    output reg [5:0] flags      // 5CF,4PF,3AF,2ZF,1SF,0OF
    );

    // para for operation(cu2alu)
    parameter ADD = 4'd1;
    parameter SUB = 4'd2;
    parameter AND = 4'd3;
    parameter OR = 4'd4;
    parameter NOT = 4'd5;
    parameter SRL = 4'd6;
    parameter SRR = 4'd7;
    parameter MPY = 4'd8;
    
    reg [15:0] acc_in;
    reg [15:0] br_in;
    reg [31:0] exbr = 0, exacc = 0, temp = 0;
    integer i;

    always @(negedge clk)
    begin
        if (C7)
            acc_in <= acc2alu;
        if (C14)
            br_in <= br2alu;
    end

    always @(negedge clk)
    begin
        temp = 0;
        exbr = 0;
        exacc = 0;
        case (cu2alu)
            ADD: begin// ADD
                flags = 0;
                temp = acc_in + br_in;
                if (acc_in[15] == 0 && br_in[15] == 0 && temp[15] == 1) begin
                    flags[5] <= 1; // CF
                    temp[15] = 0;
                end
                alu2acc <= temp[15:0];
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SUB: begin// SUB
                flags = 0;
                temp = acc_in - br_in;
                if (acc_in[15] == 1 && br_in[15] == 0 && temp[31] == 0) begin
                    flags[5] <= 1; // CF
                    temp[15] = 1;
                end
                alu2acc <= temp[15:0];
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            AND: begin// AND
                flags = 0;
                alu2acc <= acc_in & br_in;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            OR: begin// OR
                flags = 0;
                alu2acc <= acc_in | br_in;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            NOT: begin// NOT
                flags = 0;
                alu2acc <= ~br_in;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SRL: begin// SRL
                flags = 0;
                temp = br_in << 1;
                if (br_in[15] == 0 && temp[15] == 1)
                    flags[5] <= 1; // CF
                alu2acc[15] <= br_in[15];
                alu2acc[14:0] <= temp[14:0];
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SRR: begin// SRR
                flags = 0;
                temp = br_in >> 1;
                if (br_in[15] == 0 && temp[15] == 1)
                    flags[5] <= 1; // CF
                alu2acc[15] <= br_in[15];
                alu2acc[14:0] <= temp[14:0];
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            MPY: // MPY
            begin
                flags = 0;

                // sign extend
                exbr[15:0] = br_in;
                exacc[15:0] = acc_in;
                for (i = 16; i < 32; i = i + 1) begin
                    exbr[i] = br_in[15];
                    exacc[i] = acc_in[15];
                end
                for (i = 0; i < 31; i = i + 1)
                begin
                    if (exbr[i])
                        temp = temp + (exacc << i);
                end
                // if (br_in[15] != acc_in[15]) begin // 异号则结果为�?
                    
                // end
                alu2acc = temp[15:0];
                alu2mr = temp[31:16];
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            default:
                alu2acc <= 0;
        endcase
    end

endmodule
