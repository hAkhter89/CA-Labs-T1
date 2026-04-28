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

`timescale 1ns / 1ps

module tb_countdown();
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
        $readmemh("instructions_task1.mem", uut.inst_mem.memory);
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
            $display("Time=%0t | PC=%0d | inst=%h | state(x10)=%0d | x2=%0d | x1=%0d | LEDs=%b | ALUResult=%h | MemWrite=%b | address=%h | write_data=%h",
                $time,
                uut.PCout,
                uut.instruction,
                uut.reg_file_inst.registers[10],
                uut.reg_file_inst.registers[2],
                uut.reg_file_inst.registers[1],
                LEDs,
                uut.ALUResult,
                uut.MemWrite,
                uut.ALUResult,
                uut.readData2
            );
        end
    end

    // Branch monitor
    always @(posedge clk) begin
        if (rst == 0) begin
            if (uut.instruction[6:0] == 7'b1100011) begin
                $display("BRANCH | PC=%0d | inst=%h | funct3=%b | rs1=x%0d | rs2=x%0d | imm=%0d | ALUResult=%h | zero=%b | BLT_taken=%b | PCSrc=%b | next_PC=%0d",
                    uut.PCout,
                    uut.instruction,
                    uut.instruction[14:12],
                    uut.instruction[19:15],
                    uut.instruction[24:20],
                    $signed(uut.imm),
                    uut.ALUResult,
                    uut.zero,
                    uut.BLT_taken,
                    uut.PCSrc,
                    uut.next);
            end
        end
    end

    // Checks
    initial begin
        #120;
        $display("");
        $display("=== AFTER INIT ===");
        $display("state(x10) = %0d (expected 0)", 
                  uut.reg_file_inst.registers[10]);
        $display("x2 = %0d (expected 5)", 
                  uut.reg_file_inst.registers[2]);
        $display("memory[4] = %0d (expected 5)", 
                  uut.data_mem_inst.memory[4]);

        #200;
        $display("");
        $display("=== AFTER INPUT STATE ===");
        $display("state(x10) = %0d (expected 1 = COUNTDOWN)", 
                  uut.reg_file_inst.registers[10]);
        $display("x2 = %0d (expected 5)", 
                  uut.reg_file_inst.registers[2]);

        #800;
        $display("");
        $display("=== AFTER COUNTDOWN ===");
        $display("x2 = %0d (expected 0)", 
                  uut.reg_file_inst.registers[2]);
        $display("state(x10) = %0d (expected 0 = INPUT_WAITING)", 
                  uut.reg_file_inst.registers[10]);
        $display("LEDs = %b (expected all 0)", LEDs);
    end

endmodule
