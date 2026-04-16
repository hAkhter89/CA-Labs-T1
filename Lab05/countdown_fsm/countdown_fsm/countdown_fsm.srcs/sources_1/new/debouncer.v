`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2026 12:53:13 AM
// Design Name: 
// Module Name: debouncer
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

module debouncer(
    input clk, 
    input pbin,
    output wire pbout
);
    wire clk_out;
    reg [19:0] counter = 0;
    always @(posedge clk) begin
        counter <= counter + 1;
    end
    
    // Simulation adjustment: from [19] to [3]
    assign clk_out = counter[3]; 
    
    reg [2:0] shift_reg = 3'b000;
        
    always @(posedge clk_out) begin
            shift_reg <= {shift_reg[1:0], pbin};
    end
    
    assign pbout = shift_reg[2] & ~shift_reg[1];
endmodule