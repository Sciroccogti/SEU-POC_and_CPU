`timescale 1ns / 1ps

module IR(
    input clk,
    input rst,
    input C4,               // MBR to IR
    input [7:0] mbr2ir,
    output reg [7:0] ir_out
);

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            ir_out <= 0;
        else
        begin
            if(C4)
                ir_out <= mbr2ir;
        end
    end

endmodule // IR