`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 05:52:36 PM
// Design Name: 
// Module Name: tb_task3
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


`timescale 1ns / 1ps

module tb_task3();

    reg clk;
    reg rst;
    wire [15:0] LEDs;
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;    
    
    topProcessor uut (
        .clk(clk),
        .rst(rst),
        .LEDs(LEDs),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
    // 10ns clock
    always #5 clk = ~clk;
    
    initial begin
        // Load instruction memory for Task 3
        $readmemh("instructions_task3.mem", uut.inst_mem.memory);
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        
        // Stop at 1000ns to prevent console flooding.
        // Task 3 counts to 4096, which would take ~200,000ns to finish!
        #1000;
        $finish;
    end
    
    initial begin
        #25;
        $display("=== TASK 3 DEBUG ===");
        $display("PC\t| inst\t\t| ALUOp\t| ALUctrl\t| ALUSrc\t| imm\t\t| ALU_B\t\t| ALUResult\t| writeData\t| writeData_final\t| RegWrite");
        $display("----------------------------------------------------------------------------------------------------------------------------------------");
    end

    always @(negedge clk) begin
        if (rst == 0) begin
            $display("%0d\t| %h\t| %b\t| %b\t\t| %b\t\t| %h\t| %h\t| %h\t\t| %h\t\t| %h\t\t\t| %b",
                uut.PCout,
                uut.instruction,
                uut.ALUOp,
                uut.ALUctrl,
                uut.ALUSrc,
                uut.imm,
                uut.ALU_B,
                uut.ALUResult,
                uut.writeData,
                uut.writeData_final,
                uut.RegWrite);
        end
    end

    // check results at a specific snapshot point (near 1000ns)
    initial begin
        #995; // wait until just before the simulation finishes
        @(negedge clk); 
        $display("");
        $display("=== TASK 3 SNAPSHOT RESULTS ===");

        // Check if LUI correctly set the upper limit
        if (uut.reg_file_inst.registers[1] == 32'h00001000)
            $display("LUI  PASS: x1 = 0x%h (expected 0x00001000)", 
                      uut.reg_file_inst.registers[1]);
        else
            $display("LUI  FAIL: x1 = 0x%h (expected 0x00001000)", 
                      uut.reg_file_inst.registers[1]);

        // Check if the loop is successfully incrementing the counter (x2)
        if (uut.reg_file_inst.registers[2] > 0)
            $display("LOOP PASS: x2 = %0d (Counter is successfully incrementing!)", 
                      uut.reg_file_inst.registers[2]);
        else
            $display("LOOP FAIL: x2 = %0d (Counter is stuck at 0)", 
                      uut.reg_file_inst.registers[2]);

        // Check if the subroutine (JAL/JALR) is correctly mirroring x2 into x6
        if ((uut.reg_file_inst.registers[6] == uut.reg_file_inst.registers[2]) && uut.reg_file_inst.registers[2] > 0)
            $display("JAL  PASS: x6 = %0d (Subroutine is accurately updating LEDs)", 
                      uut.reg_file_inst.registers[6]);
        else
            $display("JAL  FAIL: x6 = %0d (Subroutine failed to match x2)", 
                      uut.reg_file_inst.registers[6]);

        $display("===============================");
    end

endmodule
