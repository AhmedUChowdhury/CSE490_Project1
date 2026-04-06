`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.03.2026 20:45:30
// Design Name:
// Module Name: Control_Unit
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

module Control_Unit(
    input [3:0] opcode,
    input [3:0] func_code,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemToReg,
    output reg Branch,
    output reg BranchNE,
    output reg Jump,
    output reg [3:0] ALU_control,
    output reg Addif,
    output reg ALUSwap
);
    always @(*) begin
        // set defaults
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        ALUSrc = 0;
        MemToReg = 0;
        Branch = 0;
        BranchNE = 0;
        Jump = 0;
        ALU_control = 4'b0000;
        Addif = 0;
        ALUSwap = 0;

        case(opcode)
            4'b0000: begin // R-type
                RegWrite = 1;
                ALU_control = func_code;
                if (func_code == 4'b0010) // sll needs swapped inputs
                    ALUSwap = 1;
            end
            4'b0001: begin // lw
                RegWrite = 1;
                MemRead = 1;
                ALUSrc = 1;
                MemToReg = 1;
                ALU_control = 4'b0000;
            end
            4'b0010: begin // sw
                MemWrite = 1;
                ALUSrc = 1;
                ALU_control = 4'b0000;
            end
            4'b0011: begin // addi
                RegWrite = 1;
                ALUSrc = 1;
                ALU_control = 4'b0000;
            end
            4'b0100: begin // beq
                Branch = 1;
                ALU_control = 4'b0001; // subtract to compare
            end
            4'b0101: begin // bne
                BranchNE = 1;
                ALU_control = 4'b0001;
            end
            4'b0110: begin // jmp
                Jump = 1;
            end
            4'b0111: begin // addif
                RegWrite = 1;
                ALUSrc = 1;
                ALU_control = 4'b0000;
                Addif = 1;
            end
            default: begin
                // do nothing
            end
        endcase
    end
endmodule
