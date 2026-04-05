`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 12:58:25
// Design Name: 
// Module Name: Register_File_tb
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


module Data_Memory_tb;
    reg clk;
    reg [15:0] Address;
    reg [15:0] Write_data;
    reg Mem_write;
    reg Mem_read;
    wire [15:0] Read_data;
    
    // Instantiate processor
    Data_Memory uut(
        .clk(clk), //input
        .Address(Address), //input
        .Write_data(Write_data), //input
        .Mem_write(Mem_write), //input
        .Mem_read(Mem_read), //input
        .Read_data(Read_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin // testing addresses to only the first 255 addresses as mem size is 255 bytes
        #5;
        
        Address = 16'h0000; //test writes
        Write_data = 16'h0001;
        Mem_write = 1;
        Mem_read = 0;
        #10;
        
        Address = 16'h0002; //test writes
        Write_data = 16'h0011;
        Mem_write = 1;
        Mem_read = 0;
        #10;
        
        Address = 16'h0004; //test writes
        Write_data = 16'h0111;
        Mem_write = 1;
        Mem_read = 0;
        #10;
        
        Address = 16'h0006; //test writes = 0 read = 1
        Write_data = 16'h1111;
        Mem_write = 0;
        Mem_read = 1;
        #10;
        
        Address = 16'h0000; //test writes = 0 read = 1
        Write_data = 16'h1000;
        Mem_write = 0;
        Mem_read = 1;
        #10;
        
        Address = 16'h0002; //test writes = 0 read = 1
        Write_data = 16'h1100;
        Mem_write = 0;
        Mem_read = 1;
        #10;
        
        Address = 16'h0004; //test writes = 0 read = 1
        Write_data = 16'h1110;
        Mem_write = 0;
        Mem_read = 1;
        #10;
        
        Address = 16'h0006; //test writes = 0 read = 1
        Write_data = 16'h1111;
        Mem_write = 0;
        Mem_read = 1;
        #10;
    
        $finish;
    end
    
    // Optional: dump waveform
    initial begin
        $dumpfile("Data_Memory_tb.vcd");
        $dumpvars(0, Data_Memory_tb);
    end

endmodule
