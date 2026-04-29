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



module tb_countdown();
    reg clk;
    reg rst;
    wire [15:0] LEDs;
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;
    
    // CHANGED: Instantiating TopModule instead of topProcessor
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .LEDs(LEDs),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
    // 100MHz clock (10ns period)
    always #5 clk = ~clk;
    
    initial begin
        // CHANGED: Added .my_cpu. to path
        $readmemh("instructions_task1.mem", uut.my_cpu.inst_mem.memory);
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        #2000;
        $finish;
    end

    // General monitor
    always @(posedge clk) begin
        if (rst == 0) begin
            // CHANGED: Added .my_cpu. to all internal probes
            $display("Time=%0t | PC=%0d | inst=%h | state(x10)=%0d | x2=%0d | x1=%0d | LEDs=%b | ALUResult=%h | MemWrite=%b | address=%h | write_data=%h",
                $time,
                uut.my_cpu.PCout,
                uut.my_cpu.instruction,
                uut.my_cpu.reg_file_inst.registers[10],
                uut.my_cpu.reg_file_inst.registers[2],
                uut.my_cpu.reg_file_inst.registers[1],
                LEDs,
                uut.my_cpu.ALUResult,
                uut.my_cpu.MemWrite,
                uut.my_cpu.ALUResult,
                uut.my_cpu.readData2
            );
        end
    end

    // Branch monitor
    always @(posedge clk) begin
        if (rst == 0) begin
            // CHANGED: Added .my_cpu. to all internal probes
            if (uut.my_cpu.instruction[6:0] == 7'b1100011) begin
                $display("BRANCH | PC=%0d | inst=%h | funct3=%b | rs1=x%0d | rs2=x%0d | imm=%0d | ALUResult=%h | zero=%b | BLT_taken=%b | PCSrc=%b | next_PC=%0d",
                    uut.my_cpu.PCout,
                    uut.my_cpu.instruction,
                    uut.my_cpu.instruction[14:12],
                    uut.my_cpu.instruction[19:15],
                    uut.my_cpu.instruction[24:20],
                    $signed(uut.my_cpu.imm),
                    uut.my_cpu.ALUResult,
                    uut.my_cpu.zero,
                    uut.my_cpu.BLT_taken,
                    uut.my_cpu.PCSrc,
                    uut.my_cpu.next);
            end
        end
    end

    // Checks
    initial begin
        #120;
        $display("");
        $display("=== AFTER INIT ===");
        // CHANGED: Added .my_cpu. to all internal probes
        $display("state(x10) = %0d (expected 0)", 
                  uut.my_cpu.reg_file_inst.registers[10]);
        $display("x2 = %0d (expected 5)", 
                  uut.my_cpu.reg_file_inst.registers[2]);
        $display("memory[4] = %0d (expected 5)", 
                  uut.my_cpu.data_mem_inst.memory[4]);

        #200;
        $display("");
        $display("=== AFTER INPUT STATE ===");
        $display("state(x10) = %0d (expected 1 = COUNTDOWN)", 
                  uut.my_cpu.reg_file_inst.registers[10]);
        $display("x2 = %0d (expected 5)", 
                  uut.my_cpu.reg_file_inst.registers[2]);

        #800;
        $display("");
        $display("=== AFTER COUNTDOWN ===");
        $display("x2 = %0d (expected 0)", 
                  uut.my_cpu.reg_file_inst.registers[2]);
        $display("state(x10) = %0d (expected 0 = INPUT_WAITING)", 
                  uut.my_cpu.reg_file_inst.registers[10]);
        $display("LEDs = %b (expected all 0)", LEDs);
    end

endmodule