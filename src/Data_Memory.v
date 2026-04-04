`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2026 20:45:30
// Design Name:
// Module Name: Data_Memory
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

module Data_Memory(
    input clk,
    input [15:0] Address,
    input [15:0] Write_data,
    input Mem_write,
    input Mem_read,
    output [15:0] Read_data
);
    reg [7:0] memory [0:255]; // 256 bytes, byte addressable
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 8'b0;
    end

    // big endian read
    assign Read_data = (Mem_read) ? {memory[Address[7:0]], memory[Address[7:0] + 1]} : 16'b0;

    // big endian write
    always @(posedge clk) begin
        if (Mem_write) begin
            memory[Address[7:0]] <= Write_data[15:8];     // high byte first
            memory[Address[7:0] + 1] <= Write_data[7:0];  // then low byte
        end
    end
endmodule
