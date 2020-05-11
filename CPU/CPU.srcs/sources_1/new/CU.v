`timescale 1ns / 1ps
`include "params.v"

module CU(
    input clk,
    input rst,
    input [7:0] ir2cu,
    output reg [15:0] c,
    output reg [3:0] cu2alu
);

reg [2:0] stat;
reg [7:0] opcode;
reg [2:0] cycle;

// para for stat
// parameter ADDR_FETCH = 3'd0;
// parameter INSTR_PREFETCH = 3'd1;
// parameter INSTR_FETCH = 3'd2;
// parameter RUN = 3'd3;
// parameter END = 3'd4;

always @(negedge clk or negedge rst) begin // TODO: posedge clk?
    if (~rst) begin
        c = 0;
        cu2alu = 0;
        stat = 0;
    end
    else begin
        c = 0;
        case (stat)
            3'd0: begin
                c[2] = 1; // get addr from PC to MAR
                stat = stat + 1;
            end
            3'd1: begin
                c[0] = 1; // notify RAM
                c[5] = 1; // get data from RAM to MBR
                c[15] = 1; // PC++
                stat = stat + 1;
            end
            3'd2: begin
                c[4] = 1; // get data from MBR to IR
                stat = stat + 1;
            end
            3'd3: begin
                if (opcode == 0)
                    opcode = ir2cu;
                case (opcode)
                    STOREX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] = 1; // get addr from MBR to MAR 
                                cycle = cycle + 1;
                            end
                            3'd1: begin
                                c[11] = 1; // get data from ACC to MBR
                                cycle = cycle + 1;
                            end
                            3'd2: begin
                                c[0] = 1; // notify RAM
                                c[12] = 1; // get data from MBR to RAM
                                // cycle = 0;
                                // opcode = 0;
                                stat = stat + 1;
                            end
                        endcase
                    end
                    LOADX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] = 1; // get addr from MBR to MAR 
                                cycle = cycle + 1;
                            end
                            3'd1: begin
                                c[0] = 1; // notify RAM
                                c[5] = 1; // get data from ROM to MBR
                                cycle = cycle + 1;
                            end
                            3'd2: begin
                                c[10] = 1; // get data from MBR to ACC
                                stat = stat + 1;
                            end
                        endcase
                    end
                    ADDX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] = 1; // get addr from MBR to MAR 
                                cycle = cycle + 1;
                            end
                            3'd1: begin
                                c[0] = 1; // notify RAM
                                c[5] = 1; // get data from ROM to MBR
                                cycle = cycle + 1;
                            end
                            3'd2: begin
                                c[6] = 1; // get data from MBR to BR
                                cycle = cycle + 1;
                            end
                            3'd3: begin
                                c[7] = 1; // send ACC to ALU
                                c[14] = 1; // send BR to ALU
                                // TODO: need another cycle between this?
                                cu2alu = ADD; // do calculation
                            end
                            3'd4: begin
                                c[9] = 1; // get data from ALU to ACC
                                stat = stat + 1;
                            end
                        endcase
                    end
                    SUBX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] = 1; // get addr from MBR to MAR 
                                cycle = cycle + 1;
                            end
                            3'd1: begin
                                c[0] = 1; // notify RAM
                                c[5] = 1; // get data from ROM to MBR
                                cycle = cycle + 1;
                            end
                            3'd2: begin
                                c[6] = 1; // get data from MBR to BR
                                cycle = cycle + 1;
                            end
                            3'd3: begin
                                c[7] = 1; // send ACC to ALU
                                c[14] = 1; // send BR to ALU
                                // TODO: need another cycle between this?
                                cu2alu = SUB; // do calculation
                            end
                            3'd4: begin
                                c[9] = 1; // get data from ALU to ACC
                                stat = stat + 1;
                            end
                        endcase
                    end
                    default: begin
                        
                    end
                endcase
            end
            default: begin
                
            end
            3'd4: begin
                opcode = 0;
                cycle = 0;
                stat = 0;
            end
        endcase
    end
end

endmodule // CU