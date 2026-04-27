`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:20:37 AM
// Design Name: 
// Module Name: pc_tb
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


module pc_tb();

reg clk;
reg rst;
reg PCSrc;
reg [31:0] instruction;

wire [31:0] PCout, PC4, imm, target, next;

PC u_PC (.clk(clk), .rst(rst), .next(next), .PCout(PCout));
PCAdder u_pcAdd (.PCout(PCout), .PC4(PC4));
immGen u_immGen (.instruction(instruction), .imm(imm));

BranchAdd u_brAdd (.PCout(PCout), .imm(imm), .target(target));
branch_MUX u_pcmux (.in1(PC4), .in2(target), .select(PCSrc),
                       .out(next));

// Clock Generation
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    rst = 1;
    PCSrc = 0;
    instruction = 32'd0;

    #10;
    rst = 0; // Release reset, PC should be 0

    // TEST 1: Sequential PC+4 updates
    #10; // PC becomes 4
    #10; // PC becomes 8

    // TEST 2: I-Type Immediate Generation (ADDI x5, x5, -1) -> 0xfff28293
    instruction = 32'hfff28293;
    #10; // PC becomes 12, imm should be 0xFFFFFFFF (-1)

    // TEST 3: Branch Target Update (BEQ - Branch backward by -4 bytes)
    // BEQ instruction generating an unshifted -2 offset.
    // immGen should output 0xFFFFFFFE (-2). branch_adder shifts to -4.
    instruction = 32'hfe000ce3;
    PCSrc = 1; // Trigger the branch
    #10; // PC should update to (12 - 4) = 8

    PCSrc = 0;
    #10; // PC becomes 12 again

    $finish;
end

endmodule
