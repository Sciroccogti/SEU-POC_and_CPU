`timescale 1ns / 1ps
// TODO: useless C7 and C14?
module ALU(
    input clk,
    input C7,               // ACC to ALU
    input C14,              // BR to ALU
    input [2:0] CU_in,      // signal from CU
    input [15:0] ACC_in,    // data from ACC
    input [15:0] BR_in,     // data from BR

    output reg [15:0] MR_out,   // data to MR
    output reg [15:0] ACC_out   // data to ACC
    );

    reg [15:0] acc_in;
    reg [15:0] br_in;
    reg [31:0] temp = 0;
    integer i;

    always @(posedge clk)
    begin
        if (C7)
            acc_in = ACC_in;
        if (C14)
            br_in = BR_in;
    end

    always @(posedge clk)
    begin
        case (CU_in)
            3'd0: // ADD
                ACC_out = acc_in + br_in;
            3'd1: // SUB
                ACC_out = acc_in - br_in;
            3'd2: // AND
                ACC_out = acc_in & br_in;
            3'd3: // OR
                ACC_out = acc_in | br_in;
            3'd4: // NOT
                ACC_out = ~acc_in;
            3'd5: // SRL
                ACC_out = acc_in << 1;
            3'd6: // SRR
                ACC_out = acc_in >> 1;
            3'd7: // MPY
            begin
                for (i = 0; i < 16; i = i + 1)
                begin
                    if (br_in[i])
                        temp = temp + (acc_in << i);
                end
                ACC_out = temp[15:0];
                MR_out = temp[31:16];
            end
            default:
                ACC_out = 0;
        endcase 
    end

endmodule
