`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 03:51:40 PM
// Design Name: 
// Module Name: task2_tb
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



module tb_task2();

    reg clk;
    reg rst;
    wire [15:0] LEDs;
    
    topProcessor uut (
        .clk(clk),
        .rst(rst),
        .LEDs(LEDs)
    );
    
    // 10ns clock
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        #500;
        $finish;
    end
    
    initial begin
        #25;
        $display("=== TASK 2 DEBUG ===");
        $display("PC\t| inst\t\t| ALUOp\t| ALUctrl\t| ALUSrc\t| imm\t\t| ALU_B\t\t| ALUResult\t| writeData\t| writeData_final\t| RegWrite");
        $display("-----------------------------------------------------------------------");
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

    // check results at end
    initial begin
    #95; // wait until after all instructions execute (PC=32 is last at ~85ns)
    @(negedge clk); // sample on negedge to get settled values
    $display("");
    $display("=== RESULTS ===");

    if (uut.reg_file_inst.registers[1] == 32'h12345000)
        $display("LUI  PASS: x1 = 0x%h (expected 0x12345000)", 
                  uut.reg_file_inst.registers[1]);
    else
        $display("LUI  FAIL: x1 = 0x%h (expected 0x12345000)", 
                  uut.reg_file_inst.registers[1]);

    if (uut.reg_file_inst.registers[4] == 32'd99)
        $display("BLT  PASS: x4 = %0d (expected 99)", 
                  uut.reg_file_inst.registers[4]);
    else
        $display("BLT  FAIL: x4 = %0d (expected 99)", 
                  uut.reg_file_inst.registers[4]);

    if (uut.reg_file_inst.registers[6] == 32'd42)
        $display("JAL  PASS: x6 = %0d (expected 42)", 
                  uut.reg_file_inst.registers[6]);
    else
        $display("JAL  FAIL: x6 = %0d (expected 42)", 
                  uut.reg_file_inst.registers[6]);

    $display("===============");
end

endmodule
