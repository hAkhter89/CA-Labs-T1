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





module tb_TopLevelProcessor();

reg clk;
reg rst;
wire [15:0] LEDs;

// DUT
topProcessor uut (
    .clk(clk),
    .rst(rst),
    .LEDs(LEDs)
);

// =========================
// CLOCK (10ns period)
// =========================
always #5 clk = ~clk;

// =========================
// RESET (safe + synced)
// =========================
initial begin
    clk = 0;
    rst = 1;

    // hold reset for 2 clock cycles
    repeat (2) @(posedge clk);
    rst = 0;
end

// =========================
// MONITOR (debug view)
// =========================
initial begin
    $display("Time | PC | Instr | imm | rs1 | rs2 | ALU_B | ALURes | LEDs");
    $monitor("%0t | %0d | %h | %0d | %0d | %0d | %0d | %0d | %0d",
        $time,
        uut.PCout,
        uut.instruction,
        uut.imm,
        uut.readData1,
        uut.readData2,
        uut.ALU_B,
        uut.ALUResult,
        LEDs
    );
end

// =========================
// STOP SIMULATION
// =========================
initial begin
    #100;
    $finish;
end

endmodule
