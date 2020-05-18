`timescale 1ns / 1ps

module MR(
    input clk,
    input rst,
    input C9,               // ALU to ACC
    input [15:0] alu2mr,    // data from ALU
    output reg [15:0] mr_out = 0
);

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            mr_out <= 0;
        else if (C9)
            mr_out <= alu2mr; 
    end

endmodule // MR