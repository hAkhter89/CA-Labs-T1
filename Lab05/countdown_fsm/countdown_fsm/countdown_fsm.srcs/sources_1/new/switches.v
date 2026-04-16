`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2026 01:30:04 AM
// Design Name: 
// Module Name: switches
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


module switch(
    input clk, rst,
    input [15:0] btns,
    input [31:0] writeData, 
    input writeEnable, 
    input readEnable,
    input [29:0] memAddress,
    input [15:0] switches,
    output reg [31:0] readData
);
    reg [7:0] switchData [3:0]; 
    
    always @(posedge clk) begin
        // Pass physical switch data through the readData bus
        if (readEnable) begin
            readData <= {16'd0, switches};
        end
    end
endmodule

