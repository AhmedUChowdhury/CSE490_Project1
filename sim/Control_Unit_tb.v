`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 15:23:29
// Design Name: 
// Module Name: Control_Unit_tb
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


module Control_Unit_tb;
    reg [3:0] opcode;
    reg [3:0] func_code;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemToReg;
    wire Branch;
    wire BranchNE;
    wire Jump;
    wire [3:0] ALU_control;
    wire Addif;
    
    // Instantiate processor
    Control_Unit uut(
        .opcode(opcode), //input
        .func_code(func_code), //input
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .BranchNE(BranchNE), 
        .Jump(Jump), 
        .ALU_control(ALU_control), 
        .Addif(Addif)
    );
    
    initial begin 
        
        //tests for func codes
        opcode = 4'b0000; 
        func_code = 4'b0000;
        #5;
        
        opcode = 4'b0000; 
        func_code = 4'b0001;
        #5;
        
        opcode = 4'b0000; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0000; 
        func_code = 4'b0011;
        #5;
        
        opcode = 4'b0001; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0010; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0011; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0100; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0101; 
        func_code = 4'b0010;
        #5;
        
        opcode = 4'b0110; 
        func_code = 4'b0010;
        #5;
    
        $finish;
    end
    
    // Optional: dump waveform
    initial begin
        $dumpfile("Control_Unit_tb.vcd");
        $dumpvars(0, Control_Unit_tb);
    end
endmodule
