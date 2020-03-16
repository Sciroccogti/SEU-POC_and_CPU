`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 11:48:19
// Design Name: 
// Module Name: testpoc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testpoc(

    );
    reg CLK;
    reg switch; // 查询: 0, 中断: 1
    reg print = 0; // print signal, print: 1
    reg RW = 0;
    reg [7:0] Din;
    reg ADDR = 0;
    wire IRQ;
    wire [7:0] Dout;
    wire RDY;
    wire TR;
    wire [7:0] PD;
    
    reg [7:0] data;
    wire [7:0] data_out;

    Poc poc2(switch, CLK, RW, Din[7:0], ADDR, IRQ, Dout[7:0], RDY, TR, PD[7:0]);
    Printer printer2(CLK, TR, PD[7:0], RDY, data_out[7:0]);

    initial // set the clock
    begin
        CLK = 0;
        forever #1 CLK = ~CLK;
    end

    initial // set the excitation
    begin
        // 1: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b00010001;
        print = 1;
        #100
        print = 0;
        #100

        // 2: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b00100010;
        print = 1;
        #100
        print = 0;
        #100

        // 3: 中断方式
        switch = 1;
        #100
        data[7:0] = 8'b00110011;
        print = 1;
        #100
        print = 0;
        #100

        // 4: 中断方式
        switch = 1;
        #100
        data[7:0] = 8'b01000100;
        print = 1;
        #100
        print = 0;
        #100

        // 5: 查询方式
        switch = 0;
        #100
        data[7:0] = 8'b01010101;
        print = 1;
        #100
        print = 0;
        #100
        $finish;
    end

    always @(posedge CLK)
    begin
        if (IRQ == 0) // 中断方式
        begin
            if (print == 1) // start to print
            begin
                Din[7:0] = data[7:0];
                ADDR = 1; // write BR
                RW = 1;
                #1
                Din[7:0] = 8'b00000001; // set SR7 = 0
                ADDR = 0; // write SR
                #1
                RW = 0;
            end
            else 
                RW = 0;
        end

        else // 查询方式
        begin
            if (print == 1) // start to print
            begin
                ADDR = 0; // read SR
                RW = 0;
                #1
                if (Dout[7] == 1) // SR7 == 1, poc is ready
                begin
                    Din[7:0] = data[7:0];
                    ADDR = 1;
                    RW = 1; // write BR
                    #1
                    Din[7:0] = 8'b00000000; // set SR7 = 0
                    ADDR = 0; // write SR
                    #1
                    RW = 0;
                end
            end
            else
                RW = 0;
        end
    end
endmodule
