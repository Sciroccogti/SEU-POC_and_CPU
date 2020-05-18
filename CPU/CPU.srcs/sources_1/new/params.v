`ifndef _PARAMS_
`define _PARAMS_
// not support in simulation
// para for instruction(ir2cu)
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

`endif
