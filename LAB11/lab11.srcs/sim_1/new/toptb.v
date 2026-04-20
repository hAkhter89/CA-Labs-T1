`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 08:09:52 PM
// Design Name: 
// Module Name: toptb
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



module tb_TopLevelProcessor();

    reg clk;
    reg rst;
    wire [15:0] LEDs;
    
    topProcessor uut (
        .clk(clk),
        .rst(rst),
        .LEDs(LEDs)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        #1000;
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t | PC=%0d | Instruction=%h | ALUResult=%0d | LEDs=%b",
                  $time,
                  uut.PCout,
                  uut.instruction,
                  uut.ALUResult,
                  LEDs);
    end

endmodule