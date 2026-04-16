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

//// MIGHT BE WRONG ////
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

        // B-Type (BEQ)
        // Extracted as an unshifted 12-bit value. The branchAdder will shift it << 1.
        7'b1100011:
            imm = {{20{instruction[31]}}, instruction[31], instruction[7],
                   instruction[30:25], instruction[11:8]};

        default:
            imm = 32'd0;

    endcase
end

endmodule