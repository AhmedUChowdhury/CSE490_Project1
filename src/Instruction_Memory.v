`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2026 20:45:30
// Design Name:
// Module Name: Instruction_Memory
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

module Instruction_Memory(
    input [15:0] Address_In,
    output [15:0] Instruction_Out
);
    reg [15:0] memory [0:63]; // 64 instructions
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 16'b0;

        // test program
        memory[0]  = 16'h3105; // addi $s1, $s0, 5
        memory[1]  = 16'h3203; // addi $s2, $s0, 3
        memory[2]  = 16'h0120; // add $s1, $s2
        memory[3]  = 16'h3307; // addi $s3, $s0, 7
        memory[4]  = 16'h0311; // sub $s3, $s1
        memory[5]  = 16'h3406; // addi $s4, $s0, 6
        memory[6]  = 16'h0423; // and $s4, $s2
        memory[7]  = 16'h3501; // addi $s5, $s0, 1
        memory[8]  = 16'h0522; // sll $s5, $s2
        memory[9]  = 16'h2100; // sw $s1, $s0, 0
        memory[10] = 16'h1600; // lw $s6, $s0, 0
        memory[11] = 16'h4162; // beq $s1, $s6, 2
        memory[12] = 16'h3701; // addi $s7, $s0, 1 (skipped by beq)
        memory[13] = 16'h3701; // addi $s7, $s0, 1 (skipped by beq)
        memory[14] = 16'h3707; // addi $s7, $s0, 7
        memory[15] = 16'h5121; // bne $s1, $s2, 1
        memory[16] = 16'h3801; // addi $s8, $s0, 1 (skipped by bne)
        memory[17] = 16'h3805; // addi $s8, $s0, 5
        memory[18] = 16'h6002; // jmp 2
        memory[19] = 16'h3901; // addi $s9, $s0, 1 (skipped by jmp)
        memory[20] = 16'h3901; // addi $s9, $s0, 1 (skipped by jmp)
        memory[21] = 16'h3903; // addi $s9, $s0, 3
        memory[22] = 16'h7A1F; // addif $s10, $s1, -1
        memory[23] = 16'h7B05; // addif $s11, $s0, 5
    end

    assign Instruction_Out = memory[Address_In >> 1]; // byte addr to word index
endmodule
