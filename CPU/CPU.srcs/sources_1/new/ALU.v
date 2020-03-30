`timescale 1ns / 1ps
// TODO: useless C7 and C14?
module ALU(
    input clk,
    input C7,               // ACC to ALU
    input C14,              // BR to ALU
    input [2:0] cu2alu,      // signal from CU
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
            3'd0: // ADD
                alu2acc = acc_in + br_in;
            3'd1: // SUB
                alu2acc = acc_in - br_in;
            3'd2: // AND
                alu2acc = acc_in & br_in;
            3'd3: // OR
                alu2acc = acc_in | br_in;
            3'd4: // NOT
                alu2acc = ~acc_in;
            3'd5: // SRL
                alu2acc = acc_in << 1;
            3'd6: // SRR
                alu2acc = acc_in >> 1;
            3'd7: // MPY
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
