`timescale 1ns / 1ps

module top_ALU(

input clk,
input rst,
input btn,                // push button for debouncer
input [15:0] switches,
output [15:0] leds

);

// ALU operands
wire [31:0] A;
wire [31:0] B;

assign A = 32'h10101010;
assign B = 32'h01010101;


// debounced button output
wire btn_clean;


// switch module output
wire [31:0] switchData;


// ALU outputs
wire [31:0] ALU_result;
wire Zero;


// ALU control from switches
wire [3:0] ALU_control;
assign ALU_control = switchData[3:0];


debouncer db(

    .clk(clk),
    .pbin(btn),
    .pbout(btn_clean)
);

switch switch_debounced_input(

    .clk(clk),
    .rst(rst),
    .btns(16'b0),
    .writeData(32'b0),
    .writeEnable(1'b0),
    .readEnable(btn_clean),     // read switches off debounced input
    .memAddress(30'b0),
    .switches(switches),
    .readData(switchData)
);


ALU alu_unit(

    .A(A),
    .B(B),
    .ALU_control(ALU_control),
    .ALU_result(ALU_result),
    .Zero(Zero)
);


leds led_results(

    .clk(clk),
    .rst(rst),
    .writeData(ALU_result),
    .writeEnable(1'b1),
    .readEnable(1'b0),
    .memAddress(30'b0),
    .readData(),
    .leds(leds)
);

endmodule


