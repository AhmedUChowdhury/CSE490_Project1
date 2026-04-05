`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 15:40:45
// Design Name: 
// Module Name: Instruction_Memory_tb
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


module Instruction_Memory_tb;
    reg [15:0] Address_In;
    wire [15:0] Instruction_Out;
    
    // Instantiate processor
    Instruction_Memory uut(
        .Address_In(Address_In), //input
        .Instruction_Out(Instruction_Out)
    );
    
    initial begin 
        
        //tests for func codes
        Address_In = 16'h0000; 
        #5;
        
        Address_In = 16'h0002; 
        #5;
        
        Address_In = 16'h0004; 
        #5;
        
        Address_In = 16'h0006; 
        #5;
        
        Address_In = 16'h0008; 
        #5;
        
        Address_In = 16'd20; 
        #5;
        
        Address_In = 16'd24; 
        #5;
        
        Address_In = 16'd32; 
        #5;
        
        Address_In = 16'd46; 
        #5;
    
        $finish;
    end
    
    // Optional: dump waveform
    initial begin
        $dumpfile("Instruction_Memory_tb.vcd");
        $dumpvars(0, Instruction_Memory_tb);
    end

endmodule
