`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 10:42:15 AM
// Design Name: 
// Module Name: immGen
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

//// TASK2 CHANGE (JAL, LUI)
module immGen(
    input wire [31:0] instruction,
    output reg [31:0] imm
);
wire [6:0] opcode = instruction[6:0];
always @ (*) begin
    case(opcode)
        // I-Type
        7'b0010011, 7'b0000011, 7'b1100111:
            imm = {{20{instruction[31]}}, instruction[31:20]};
        // S-Type (SW)
        7'b0100011:
            imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        // B-Type (BEQ / BLT) -- added 1'b0 to pre-shift, BranchAdd no longer shifts
        7'b1100011:
            imm = {{20{instruction[31]}}, instruction[31], instruction[7],
                   instruction[30:25], instruction[11:8], 1'b0};
        // U-Type (LUI) -- TASK2 ADDITION
        7'b0110111:
            imm = {instruction[31:12], 12'b0};
        // J-Type (JAL) -- TASK2 ADDITION
        7'b1101111:
            imm = {{12{instruction[31]}}, instruction[19:12],
                   instruction[20], instruction[30:21], 1'b0};
        default:
            imm = 32'd0;
    endcase
end
endmodule