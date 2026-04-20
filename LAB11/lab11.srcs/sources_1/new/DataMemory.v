`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:03:55 AM
// Design Name: 
// Module Name: DataMemory
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

module DataMemory(
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [8:0]  address,      // 9-bit address for 512 locations
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    // 512 x 32-bit memory array
    reg [31:0] memory [0:511];

    // Synchronous Write
    always @(posedge clk) begin
        if (MemWrite)
            memory[address] <= write_data;
    end

    // Asynchronous Read
    always @(*) begin
        if (MemRead)
            read_data = memory[address];
        else
            read_data = 32'd0;
    end

endmodule
