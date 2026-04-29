`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 12:52:58 PM
// Design Name: 
// Module Name: top_module
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


module TopModule (
    input wire clk,         // 100 MHz clock from the board's pin
    input wire rst,         // Reset switch/button
    output wire [15:0] LEDs,
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire dp
);

    // 1. Create a wire to carry the slow clock
    wire slow_clk;

    // 2. Instantiate the Clock Divider
    clockdivider clk_div (
        .clk(clk), 
        .rst(rst), 
        .slow_clk(slow_clk)
    );

    // 3. Instantiate your RISC-V Processor
    // IMPORTANT: Feed 'slow_clk' into it instead of 'clk'!
    topProcessor my_cpu (
        .clk(slow_clk),     // <--- The magic happens here
        .rst(rst),
        .LEDs(LEDs),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
endmodule
