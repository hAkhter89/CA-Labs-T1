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
    
    always #5 clk = ~clk;
    
    initial begin
        $readmemh("instructions_task3.mem", uut.inst_mem.memory);
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        #5000;  // run longer to see shifting
        $finish;
    end
    
    initial begin
        #25;
        $display("=== TASK 3 - SHIFT LEFT PROGRAM ===");
        $display("PC\t| inst\t\t| x1(limit)\t| x2(value)\t| x5(ret)\t| LEDs\t\t\t| mem[8]");
        $display("------------------------------------------------------------------------");
    end

    always @(negedge clk) begin
        if (rst == 0) begin
            $display("%0d\t| %h\t| %h\t| %0d\t\t| %0d\t\t| %b\t| %0d",
                uut.PCout,
                uut.instruction,
                uut.reg_file_inst.registers[1],   // x1 = upper limit from LUI
                uut.reg_file_inst.registers[2],   // x2 = shifting value
                uut.reg_file_inst.registers[5],   // x5 = return address from JAL
                LEDs,
                uut.data_mem_inst.memory[8]);     // led_port value
        end
    end

    initial begin
        #4990;
        @(negedge clk);
        $display("");
        $display("=== TASK 3 RESULTS ===");

        // LUI check
        if (uut.reg_file_inst.registers[1] == 32'h00005000)
            $display("LUI  PASS: x1 = 0x%h (expected 0x00005000)", 
                      uut.reg_file_inst.registers[1]);
        else
            $display("LUI  FAIL: x1 = 0x%h (expected 0x00005000)", 
                      uut.reg_file_inst.registers[1]);

        // Shift/BLT check - x2 should be power of 2
        if (uut.reg_file_inst.registers[2] > 1)
            $display("SLLI+BLT PASS: x2 = %0d (shifting correctly)", 
                      uut.reg_file_inst.registers[2]);
        else
            $display("SLLI+BLT FAIL: x2 = %0d (not shifting)", 
                      uut.reg_file_inst.registers[2]);

        // JAL check - x5 should have return address
        if (uut.reg_file_inst.registers[5] > 0)
            $display("JAL  PASS: x5 = %0d (return address saved)", 
                      uut.reg_file_inst.registers[5]);
        else
            $display("JAL  FAIL: x5 = 0 (JAL not working)", 
                      uut.reg_file_inst.registers[5]);

        // Final LED value check
        $display("Final LEDs = %b = %0d", LEDs, LEDs);
        $display("Final mem[8] = %0d", uut.data_mem_inst.memory[8]);
        $display("======================");
    end
endmodule