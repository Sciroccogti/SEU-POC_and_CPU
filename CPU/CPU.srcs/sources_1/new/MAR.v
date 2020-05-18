`timescale 1ns / 1ps

module MAR(
    input clk,
    input rst,
    input C2,           // PC to MAR
    input C8,           // MBR to MAR
    input [7:0] pc2mar,
    input [7:0] mbr2mar,

    output reg [7:0] mar_out
);

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            mar_out <= 0;
        else
        begin
            if(C8)
                mar_out <= mbr2mar;
            else if(C2)
                mar_out <= pc2mar;
        end
    end

endmodule // MAR