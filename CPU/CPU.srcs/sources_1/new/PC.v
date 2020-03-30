`timescale 1ns / 1ps

module PC(
    input clk,
    input rst,
    input C3,               // MBR to PC
    input [7:0] mbr2pc,
    output reg [7:0] pc_out
);

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            pc_out = 0;
        else
        begin
            if(C3)
                pc_out = mbr2pc;
            else
                pc_out = pc_out + 1;
        end
    end

endmodule // PC