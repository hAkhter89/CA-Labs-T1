`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 05:30:33 AM
// Design Name: 
// Module Name: debouncer
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

module button_debouncer (
    input clk,
    input rst,
    input btn_in,
    output btn_out_pulse
);

    // 1. Synchronize the asynchronous button input to the clock domain
    reg btn_sync_0, btn_sync_1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end
    end

    // 2. Debounce counter (Wait for the signal to be stable)
    // 16-bit counter is usually enough for a 50MHz clock (~1.3ms debounce time)
    // If your clock is much faster, increase this to 20 bits.
    reg [15:0] counter;
    reg btn_stable;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            btn_stable <= 0;
        end else begin
            if (btn_sync_1 == btn_stable) begin
                counter <= 0; // Reset counter if button state matches stable state
            end else begin
                counter <= counter + 1;
                if (counter == 16'hFFFF) begin
                    btn_stable <= btn_sync_1; // Register new state after counter maxes out
                    counter <= 0;
                end
            end
        end
    end

    // 3. Edge Detector (One-Shot Pulse)
    reg btn_stable_prev;
    always @(posedge clk or posedge rst) begin
        if (rst) btn_stable_prev <= 0;
        else btn_stable_prev <= btn_stable;
    end

    // Output is high for exactly ONE clock cycle on the rising edge of the stable button
    assign btn_out_pulse = (btn_stable == 1'b1) && (btn_stable_prev == 1'b0);

endmodule