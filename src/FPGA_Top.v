`timescale 1ns / 1ps

// FPGA wrapper for Basys 3 board
// SW[3:0] = select register to display on LEDs
// btnU    = reset processor
// LED[15:0] = value of selected register
//
// After reset, processor runs at ~1Hz so you can watch
// each instruction execute on the LEDs.

module FPGA_Top(
    input clk,            // 100MHz board clock
    input btnU,           // reset button
    input [3:0] sw,       // switches for register select
    output [15:0] led     // LEDs show register value
);

    // ---- clock divider: 100MHz -> ~1Hz ----
    reg [25:0] counter = 0;
    reg slow_clk = 0;

    always @(posedge clk) begin
        if (counter == 26'd49_999_999) begin
            counter <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            counter <= counter + 1;
        end
    end

    // ---- debounce reset button ----
    reg [19:0] db_count = 0;
    reg reset_db = 0;

    always @(posedge clk) begin
        if (btnU != reset_db) begin
            db_count <= db_count + 1;
            if (&db_count)
                reset_db <= btnU;
        end else begin
            db_count <= 0;
        end
    end

    // ---- processor ----
    wire [15:0] reg_display;

    Processor proc(
        .clk(slow_clk),
        .reset(reset_db),
        .debug_reg_sel(sw),
        .debug_reg_data(reg_display)
    );

    assign led = reg_display;

endmodule
