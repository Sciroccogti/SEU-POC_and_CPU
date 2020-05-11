`timescale 1ns / 1ps

module RAM_mod(
    input clk,
    input rst,
    input C0,               // MAR to RAM
    // input C5,               // RAM to MBR
    // input C12,              // MBR to RAM
    input [15:0] mar2ram,
    input [15:0] mbr2ram,
    output reg [15:0] ram_out
);
    reg [0:0] we;
    reg [15:0] dout;
    RAM ram(clk, we, mar2ram, mbr2ram, dout);

    always @(negedge clk or negedge rst) begin
        if (~rst)
            ram_out = 0;
        else begin
            if (C0)
                ram_out = dout;
        end
    end

endmodule // RAM_mod