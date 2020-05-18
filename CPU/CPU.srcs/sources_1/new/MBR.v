`timescale 1ns / 1ps

module MBR(
    input clk,
    input rst,
    input C1,               // ACC to MBR
    input C5,               // RAM to MBR
    input C11,              // PC to MBR
    input C13,              // MR to MBR
    input [15:0] acc2mbr,
    input [15:0] ram2mbr,
    input [7:0] pc2mbr,
    input [15:0] mr2mbr,
    
    output reg [15:0] mbr_out
);

    always @(negedge clk or negedge rst)
    begin
        if (~rst)
            mbr_out <= 0;
        else
        begin
            if(C5)
                mbr_out <= ram2mbr;
            else if(C11)
                mbr_out <= acc2mbr;
            else if(C13)
                mbr_out <= mr2mbr;
            else if(C1)
            begin
                mbr_out[7:0] <= pc2mbr;
                mbr_out[15:8] <= 0;
            end
        end
    end

endmodule // MBR