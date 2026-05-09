`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:58:39 AM
// Design Name: 
// Module Name: ALU
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


module ALU( 
input [31:0] A, 
input [31:0] B, 
input [3:0] ALU_control, 
output reg [31:0] ALU_result, 
output Zero 
); 
always @(*) begin
    case(ALU_control)
        4'b0000: ALU_result = A & B;       // AND
        4'b0001: ALU_result = A | B;       // OR
        4'b0010: ALU_result = A + B;       // ADD
        4'b0011: ALU_result = A ^ B;       // XOR
        4'b0100: ALU_result = A << B[4:0]; // SLL
        4'b0101: ALU_result = A >> B[4:0]; // SRL
        4'b0110: ALU_result = A - B;       // SUB
        4'b1000: ALU_result = B;           // LUI pass-through -- TASK2 ADDITION
        default: ALU_result = 32'b0;
    endcase
end
assign Zero = (ALU_result == 0); 
endmodule