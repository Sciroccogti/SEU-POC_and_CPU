`timescale 1ns / 1ps

module RAM_mod(
    input clk,
    input rst,
    input C0,               // MAR to RAM
    // input C5,               // RAM to MBR
    input C12,              // MBR to RAM
    input [7:0] mar2ram,
    input [15:0] mbr2ram,
    output reg [15:0] ram_out
);
    reg [0:0] we;
    // reg [7:0] addr;
    // reg [15:0] din, dout;
    // RAM ram(clk, we, addr, din, dout);
    // reg [5:0] count = 0;
    reg [15:0] ram [255:0];

    always @(negedge clk or negedge rst) begin
        if (~rst) begin
            ram_out = 0;
            ram[8'h00] = 16'h02A0;
            ram[8'h01] = 16'h01A5;
            ram[8'h02] = 16'h02A2;
            ram[8'h03] = 16'h01A6;
            ram[8'h04] = 16'h02A0;
            ram[8'h05] = 16'h01A7;
            ram[8'h06] = 16'h02A3;
            ram[8'h07] = 16'h01A8;
            ram[8'h08] = 16'h02A5;
            ram[8'h09] = 16'h03A6;
            ram[8'h0A] = 16'h01A5;
            ram[8'h0B] = 16'h02A6;
            ram[8'h0C] = 16'h04A1;
            ram[8'h0D] = 16'h04A1;
            ram[8'h0E] = 16'h01A6;
            ram[8'h0F] = 16'h0508;
            ram[8'h10] = 16'h02A5;
            ram[8'h11] = 16'h08A4;
            ram[8'h12] = 16'h0D00;
            ram[8'h13] = 16'h0D00;
            ram[8'h14] = 16'h01A5;
            ram[8'h15] = 16'h02A7;
            ram[8'h16] = 16'h03A8;
            ram[8'h17] = 16'h01A7;
            ram[8'h18] = 16'h02A8;
            ram[8'h19] = 16'h04A1;
            ram[8'h1A] = 16'h01A8;
            ram[8'h1B] = 16'h0515;
            ram[8'h1C] = 16'h02A5;
            ram[8'h1D] = 16'h0AA7;
            ram[8'h1E] = 16'h01A5;
            ram[8'h1F] = 16'h0700;
            ram[8'hA0] = 16'h0000;
            ram[8'hA1] = 16'h0001;
            ram[8'hA2] = 16'h0013;
            ram[8'hA3] = 16'h0014;
            ram[8'hA4] = 16'hFFF3;
        end
        else begin
            if (C0) begin
                ram_out = ram[mar2ram];
                if (C12)
                    ram[mar2ram] = mbr2ram;
            end
        end
    end

endmodule // RAM_mod