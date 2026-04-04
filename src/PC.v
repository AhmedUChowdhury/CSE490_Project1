`timescale 1ns / 1ps

module PC(
    input clk,
    input reset,
    input [15:0] next_PC,
    output reg [15:0] PC_out
);
    initial begin
        PC_out = 16'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_out <= 16'b0;
        else
            PC_out <= next_PC;
    end
endmodule
