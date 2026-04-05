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


module Register_File_tb;
    reg clk;
    reg [3:0] read_reg1;
    reg [3:0] read_reg2;
    reg [3:0] write_reg;
    reg [15:0] write_data;
    reg reg_write;
    wire [15:0] read_data1;
    wire [15:0] read_data2;
    
    reg [3:0] debug_sel;
    wire [15:0] debug_data;
    
    // Instantiate processor
    Register_File uut(
        .clk(clk), //input
        .read_reg1(read_reg1), //input
        .read_reg2(read_reg2),
        .write_reg(write_reg), //input
        .write_data(write_data), //input
        .reg_write(reg_write), //input
        .read_data1(read_data1),
        .read_data2(read_data2),
        .debug_sel(debug_sel), //input
        .debug_data(debug_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        #5;
        
        read_reg1 = 4'b0; //test writes
        read_reg2 = 4'b0;
        write_reg = 4'b1000;
        write_data = 16'h0031;
        reg_write = 1;
        #10;
        
        read_reg1 = 4'b1000; //test writes and reads
        read_reg2 = 4'b0;
        write_reg = 4'b1100;
        write_data = 16'h0080;
        reg_write = 1;
        #5;
        
        read_reg1 = 4'b1000; //test writes for half cycle
        read_reg2 = 4'b1100;
        write_reg = 4'b1001;
        write_data = 16'h0031;
        reg_write = 0;
        #5;
        
        read_reg1 = 4'b1001; //test reads for half cycle
        read_reg2 = 4'b1100;
        write_reg = 4'b1000;
        write_data = 16'h0031;
        reg_write = 0;
        #10;
    
        $finish;
    end
    
    // Optional: dump waveform
    initial begin
        $dumpfile("Register_File_tb.vcd");
        $dumpvars(0, Register_File_tb);
    end

endmodule
