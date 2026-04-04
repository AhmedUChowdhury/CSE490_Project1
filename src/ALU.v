`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/20/2026 14:30:00
// Design Name:
// Module Name: ALU
// Project Name: 16-bit Processor
// Target Devices: Basys 3
// Tool Versions:
// Description: ALU supporting add, sub, sll, and
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input [15:0] A,
    input [15:0] B,
    input [3:0] ALU_control,
    output reg [15:0] ALU_result,
    output Zero
);
    assign Zero = (ALU_result == 16'b0);

    always @(*) begin
        case(ALU_control)
            4'b0000: ALU_result = A + B; // add
            4'b0001: ALU_result = A - B; // sub
            4'b0010: ALU_result = B << A; // sll
            4'b0011: ALU_result = A & B; // and
            default: ALU_result = 16'b0;
        endcase
    end
endmodule
