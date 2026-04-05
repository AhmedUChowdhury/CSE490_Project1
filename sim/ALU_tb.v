`timescale 1ns / 1ps

module ALU_tb;

    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] ALU_control;
    wire [15:0] ALU_result;
    wire Zero;

    // Instantiate processor
    ALU uut(
        .A(A), //input
        .B(B), //input
        .ALU_control(ALU_control), //input
        .ALU_result(ALU_result),
        .Zero(Zero)
    );

    initial begin
    
        A = 16'h0004; //test add
        B = 16'h0004;
        ALU_control = 4'b0000;
        #10;
        
        A = 16'h0004; //test subtract
        B = 16'h0004;
        ALU_control = 4'b0001;
        #10;
        
        A = 16'h0002; //test shift left
        B = 16'h0004;
        ALU_control = 4'b0010;
        #10;
        
        A = 16'h0002; //test and
        B = 16'h0004;
        ALU_control = 4'b0011;
        #10;
    
    
    end
    
    // Optional: dump waveform
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);
    end

endmodule
