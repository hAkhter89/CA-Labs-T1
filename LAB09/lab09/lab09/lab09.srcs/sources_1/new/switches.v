`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 10:31:18 AM
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


module switches(
    input clk,
    input rst,
    input [15:0] switches_in,
    output reg [31:0] switches_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        switches_out <= 32'b0;
    else
        // zero-extend 16-bit switches to 32-bit
        switches_out <= {16'b0, switches_in};
end

endmodule

