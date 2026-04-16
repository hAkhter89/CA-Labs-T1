`timescale 1ns / 1ps

module Register_tb;

reg clk;
reg rst;
reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;
reg [31:0] WriteData;
reg WriteEnable;

wire [31:0] ReadData1;
wire [31:0] ReadData2;

Register RF(
    .clk(clk),
    .rst(rst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(WriteData),
    .WriteEnable(WriteEnable),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);
 // clock
always #5 clk = ~clk;

initial begin

clk = 0;
rst = 1;
WriteEnable = 0;
rs1 = 0;
rs2 = 0;
rd = 0;
WriteData = 0;

#10 rst = 0;

/* x5 = DEADBEEF */

rd = 5;
WriteData = 32'hDEADBEEF;
WriteEnable = 1;

#10 WriteEnable = 0;

rs1 = 5; // test for new value
#10;

/* write to x0 NO CJANGE*/

rd = 0;
WriteData = 32'hFFFFFFFF;
WriteEnable = 1;

#10 WriteEnable = 0;

rs1 = 0;
#10;

/* Two reads */

rs1 = 5;
rs2 = 0;

#10;

/* Overwrite register */

rd = 5;
WriteData = 32'h11111111;
WriteEnable = 1;

#10 WriteEnable = 0;

rs1 = 5;

#20;
$finish;

end

endmodule

