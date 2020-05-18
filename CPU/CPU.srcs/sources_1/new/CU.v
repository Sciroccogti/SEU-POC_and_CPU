`timescale 1ns / 1ps
// `include "params.v"

module CU(
    input clk,
    input rst,
    input [7:0] ir2cu,
    input [5:0] flags,      // CF,PF,AF,ZF,SF,OF
    output reg [15:0] c,
    output reg [3:0] cu2alu
);

reg [2:0] stat;
reg [7:0] opcode;
reg [2:0] cycle;

// para for opcode(ir2cu)
parameter STOREX    = 8'b00000001;
parameter LOADX     = 8'b00000010;
parameter ADDX      = 8'b00000011;
parameter SUBX      = 8'b00000100;
parameter JMPGEZX   = 8'b00000101;
parameter JMPX      = 8'b00000110;
parameter HALT      = 8'b00000111;

parameter MPYX      = 8'b00001000;

parameter ANDX      = 8'b00001010;
parameter ORX       = 8'b00001011;
parameter NOTX      = 8'b00001100;
parameter SHIFTR    = 8'b00001101;
parameter SHIFTL    = 8'b00001110;

// para for operation(cu2alu)
parameter ADD = 4'd1;
parameter SUB = 4'd2;
parameter AND = 4'd3;
parameter OR = 4'd4;
parameter NOT = 4'd5;
parameter SRL = 4'd6;
parameter SRR = 4'd7;
parameter MPY = 4'd8;

always @(negedge clk or negedge rst) begin // TODO: posedge clk?
    if (~rst) begin
        c <= 0;
        cu2alu <= 0;
        stat <= 0;
        opcode <= 0;
        cycle <= 0;
    end
    else begin
        c <= 0;
        case (stat)
            3'd0: begin
                c[2] <= 1; // get addr from PC to MAR
                stat <= stat + 1;
            end
            3'd1: begin
                c[0] <= 1; // notify RAM
                c[15] <= 1; // PC++
                stat <= stat + 1;
            end
            3'd2: begin
                c[5] <= 1; // get data from RAM to MBR
                stat <= stat + 1;
            end
            3'd3: begin
                c[4] <= 1; // get data from MBR to IR
                stat <= stat + 1;
            end
            3'd4: begin
                // wait for opcode
                stat <= stat + 1;
            end
            3'd5: begin
                opcode = ir2cu;
                case (opcode)
                    STOREX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] <= 1; // get addr from MBR to MAR 
                                cycle <= cycle + 1;
                            end
                            3'd1: begin
                                c[11] <= 1; // get data from ACC to MBR
                                cycle <= cycle + 1;
                            end
                            3'd2: begin
                                c[0] <= 1; // notify RAM
                                c[12] <= 1; // get data from MBR to RAM
                                stat <= stat + 1;
                            end
                        endcase
                    end
                    LOADX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] <= 1; // get addr from MBR to MAR 
                                cycle <= cycle + 1;
                            end
                            3'd1: begin
                                c[0] <= 1; // notify RAM
                                cycle <= cycle + 1;
                            end
                            3'd2: begin
                                c[5] <= 1; // get data from ROM to MBR
                                cycle <= cycle + 1;
                            end
                            3'd3: begin
                                c[10] <= 1; // get data from MBR to ACC
                                stat <= stat + 1;
                            end
                        endcase
                    end
                    ADDX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] <= 1; // get addr from MBR to MAR 
                                cycle <= cycle + 1;
                            end
                            3'd1: begin
                                c[0] <= 1; // notify RAM
                                cycle <= cycle + 1;
                            end
                            3'd2: begin
                                c[5] <= 1; // get data from ROM to MBR
                                cycle <= cycle + 1;
                            end
                            3'd3: begin
                                c[6] <= 1; // get data from MBR to BR
                                cycle <= cycle + 1;
                            end
                            3'd4: begin
                                c[7] <= 1; // send ACC to ALU
                                c[14] <= 1; // send BR to ALU
                                // TODO: need another cycle between this?
                                cu2alu <= ADD; // do calculation
                                cycle <= cycle + 1;
                            end
                            3'd5: begin
                                // wait for alu
                                cycle <= cycle + 1;
                            end
                            3'd6: begin
                                c[9] <= 1; // get data from ALU to ACC
                                stat <= stat + 1;
                            end
                        endcase
                    end
                    SUBX: begin
                        case (cycle)
                            3'd0: begin
                                c[8] <=  1; // get addr from MBR to MAR 
                                cycle <= cycle + 1;
                            end
                            3'd1: begin
                                c[0] <= 1; // notify RAM
                                cycle <= cycle + 1;
                            end
                            3'd2: begin
                                c[5] <= 1; // get data from ROM to MBR
                                cycle <= cycle + 1;
                            end
                            3'd3: begin
                                c[6] <= 1; // get data from MBR to BR
                                cycle <= cycle + 1;
                            end
                            3'd4: begin
                                c[7] <= 1; // send ACC to ALU
                                c[14] <= 1; // send BR to ALU
                                // TODO: need another cycle between this?
                                cu2alu <= SUB; // do calculation
                                cycle <= cycle + 1;
                            end
                            3'd5: begin
                                // wait for alu
                                cycle <= cycle + 1;
                            end
                            3'd6: begin
                                c[9] <= 1; // get data from ALU to ACC
                                stat <= stat + 1;
                            end
                        endcase
                    end
                    JMPGEZX: begin
                        case (cycle)
                            3'd0: begin
                                if (zf)
                                cycle <= cycle + 1;
                            end
                            3'd1: begin
                                c[0] <= 1; // notify RAM
                                cycle <= cycle + 1;
                            end
                        endcase
                    end
                    default: begin
                        
                    end
                endcase
            end
            default: begin
                
            end
            3'd6: begin
                opcode <= 0;
                cycle <= 0;
                stat <= 0;
            end
        endcase
    end
end

endmodule // CU