`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2026 20:45:30
// Design Name:
// Module Name: Register_File
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

module Register_File(
    input clk,
    input [3:0] read_reg1,
    input [3:0] read_reg2,
    input [3:0] write_reg,
    input [15:0] write_data,
    input reg_write,
    output [15:0] read_data1,
    output [15:0] read_data2,
    // debug port for FPGA display
    input [3:0] debug_sel,
    output [15:0] debug_data
);
    reg [15:0] registers [0:15]; // 16 registers, 16 bits each
    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1)
            registers[i] = 16'b0;
    end

    // async read
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
    assign debug_data = registers[debug_sel];

    // sync write on rising edge
    always @(posedge clk) begin
        if (reg_write)
            registers[write_reg] <= write_data;
    end
endmodule
