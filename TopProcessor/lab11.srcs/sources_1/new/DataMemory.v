`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 11:03:55 AM
// Design Name: 
// Module Name: DataMemory
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

// funct3 depending on the size of the data.
//module DataMemory(
//    input  wire        clk,
//    input  wire        MemWrite,
//    input  wire        MemRead,
//    input  wire [8:0]  address,      // 9-bit address for 512 locations
//    input  wire [31:0] write_data,
//    output reg  [31:0] read_data
//);

//    // 512 x 32-bit memory array
//    reg [31:0] memory [0:511];

//    // Synchronous Write
//    always @(posedge clk) begin
//        if (MemWrite)
//            memory[address] <= write_data;
//    end

//    // Asynchronous Read
//    always @(*) begin
//        if (MemRead)
//            read_data = memory[address];
//        else
//            read_data = 32'd0;
//    end

//endmodule


module DataMemory(
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [2:0]  funct3,     // Added to determine size (lb, lh, lw)
    input  wire [31:0] address,    // Usually a 32-bit address from the ALU
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    // 2048 x 8-bit memory array (Byte-addressable, equals 512 32-bit words)
    reg [7:0] memory [0:2047];

    // Synchronous Write
    always @(posedge clk) begin
        if (MemWrite) begin
            case (funct3)
                3'b000: begin // sb (Store Byte)
                    memory[address] <= write_data[7:0];
                end
                3'b001: begin // sh (Store Halfword)
                    memory[address]   <= write_data[7:0];
                    memory[address+1] <= write_data[15:8];
                end
                3'b010: begin // sw (Store Word)
                    memory[address]   <= write_data[7:0];
                    memory[address+1] <= write_data[15:8];
                    memory[address+2] <= write_data[23:16];
                    memory[address+3] <= write_data[31:24];
                end
            endcase
        end
    end

    // Asynchronous Read
    always @(*) begin
        if (MemRead) begin
            case (funct3)
                3'b000: // lb (Load Byte, Sign-Extended)
                    read_data = {{24{memory[address][7]}}, memory[address]};
                
                3'b100: // lbu (Load Byte Unsigned, Zero-Extended)
                    read_data = {24'b0, memory[address]};
                
                3'b001: // lh (Load Halfword, Sign-Extended)
                    read_data = {{16{memory[address+1][7]}}, memory[address+1], memory[address]};
                
                3'b101: // lhu (Load Halfword Unsigned, Zero-Extended)
                    read_data = {16'b0, memory[address+1], memory[address]};
                
                3'b010: // lw (Load Word)
                    read_data = {memory[address+3], memory[address+2], memory[address+1], memory[address]};
                
                default: 
                    read_data = 32'd0;
            endcase
        end else begin
            read_data = 32'd0;
        end
    end

endmodule