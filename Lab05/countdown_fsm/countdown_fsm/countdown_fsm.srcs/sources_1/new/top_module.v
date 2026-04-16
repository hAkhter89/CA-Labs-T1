
`timescale 1ns / 1ps

module top_module (
    input clk,
    input rst,
    input [15:0] switch,
    output wire [15:0] led
);
    wire debounce_out;
    wire clean_rst = debounce_out;

    debouncer db(
        .clk(clk),
        .pbin(rst),
        .pbout(debounce_out) 
    );

    reg [26:0] timer = 0;
    wire tick;
    
    always @(posedge clk) begin
        // Reduced from 99,999,999 for simulation speed
        if (timer == 27'd99)
            timer <= 0;
        else
            timer <= timer + 1;
    end
    assign tick = (timer == 27'd99);

    wire [31:0] switch_read_data;
    reg  [31:0] led_write_data;

    switch sw_inst(
        .clk(clk),
        .rst(clean_rst),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(switch),
        .readData(switch_read_data)
    );

    leds leds_inst(
        .clk(clk),
        .rst(clean_rst),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(led)
    );

    localparam WAIT_STATE = 1'b0;
    localparam COUNT_STATE = 1'b1;

    reg state = WAIT_STATE;
    reg [15:0] counter = 0;
    
    wire [15:0] current_switches = switch_read_data[15:0];

    always @(posedge clk) begin
        if (clean_rst) begin
            state <= WAIT_STATE;
            counter <= 16'd0;
            led_write_data <= 32'd0;
        end else begin
            case (state)
                WAIT_STATE: begin
                    if (current_switches != 16'd0) begin
                        state <= COUNT_STATE;
                        counter <= current_switches; 
                        led_write_data <= {16'd0, current_switches};    
                    end else begin
                        counter <= 16'd0;
                        led_write_data <= 32'd0;
                    end
                end
                
                COUNT_STATE: begin
                    if (tick) begin 
                        if (counter > 16'd0) begin
                            counter <= counter - 16'd1;
                            led_write_data <= {16'd0, counter - 16'd1};
                        end else begin
                            state <= WAIT_STATE; 
                        end
                    end
                end
            endcase
        end
    end
endmodule
