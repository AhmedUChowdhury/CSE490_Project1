`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/20/2026 15:00:00
// Design Name:
// Module Name: Sign_Extension
// Project Name: 16-bit Processor
// Target Devices: Basys 3
// Tool Versions:
// Description: Sign extends 4-bit immediate to 16-bit
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Sign_Extension(
    input [3:0] imm_in,
    output [15:0] imm_out
);
    assign imm_out = {{12{imm_in[3]}}, imm_in};
endmodule
