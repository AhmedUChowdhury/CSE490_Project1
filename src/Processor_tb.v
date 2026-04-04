`timescale 1ns / 1ps

module Processor_tb;

    reg clk;
    reg reset;
    reg [3:0] debug_sel;
    wire [15:0] debug_data;

    // Instantiate processor
    Processor uut(
        .clk(clk),
        .reset(reset),
        .debug_reg_sel(debug_sel),
        .debug_reg_data(debug_data)
    );

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    integer pass;

    initial begin
        // Reset
        reset = 1;
        debug_sel = 0;
        #12;
        reset = 0;

        // Run for 25 clock cycles (program needs ~19)
        #250;

        // ============================================================
        // Expected register values after test program:
        //   $s0  = 0x0000 (unchanged)
        //   $s1  = 0x0008 (addi 5, then add with $s2: 3+5=8)
        //   $s2  = 0x0003 (addi 3)
        //   $s3  = 0x0001 (addi 7, then sub: 8-7=1)
        //   $s4  = 0x0002 (addi 6, then and with 3: 6&3=2)
        //   $s5  = 0x0008 (addi 1, then sll by 3: 1<<3=8)
        //   $s6  = 0x0008 (lw from Mem[0] = 8)
        //   $s7  = 0x0007 (beq skips 2, then addi 7)
        //   $s8  = 0x0005 (bne skips 1, then addi 5)
        //   $s9  = 0x0003 (jmp skips 2, then addi 3)
        //   $s10 = 0xFFFF (addif: $s1!=0, 0+(-1)=-1)
        //   $s11 = 0x0000 (addif: $s0==0, no change)
        //   $s12-$s15 = 0x0000
        // ============================================================

        $display("============================================");
        $display("      16-bit Processor Simulation Results");
        $display("============================================");
        $display("");

        // Display all registers
        for (i = 0; i < 16; i = i + 1) begin
            $display("  $s%-2d = 0x%04h (%0d)",
                     i,
                     uut.regfile_inst.registers[i],
                     $signed(uut.regfile_inst.registers[i]));
        end

        $display("");

        // Verify correctness
        pass = 1;

        if (uut.regfile_inst.registers[0]  !== 16'h0000) begin $display("FAIL: $s0  expected 0x0000"); pass = 0; end
        if (uut.regfile_inst.registers[1]  !== 16'h0008) begin $display("FAIL: $s1  expected 0x0008"); pass = 0; end
        if (uut.regfile_inst.registers[2]  !== 16'h0003) begin $display("FAIL: $s2  expected 0x0003"); pass = 0; end
        if (uut.regfile_inst.registers[3]  !== 16'h0001) begin $display("FAIL: $s3  expected 0x0001"); pass = 0; end
        if (uut.regfile_inst.registers[4]  !== 16'h0002) begin $display("FAIL: $s4  expected 0x0002"); pass = 0; end
        if (uut.regfile_inst.registers[5]  !== 16'h0008) begin $display("FAIL: $s5  expected 0x0008"); pass = 0; end
        if (uut.regfile_inst.registers[6]  !== 16'h0008) begin $display("FAIL: $s6  expected 0x0008"); pass = 0; end
        if (uut.regfile_inst.registers[7]  !== 16'h0007) begin $display("FAIL: $s7  expected 0x0007"); pass = 0; end
        if (uut.regfile_inst.registers[8]  !== 16'h0005) begin $display("FAIL: $s8  expected 0x0005"); pass = 0; end
        if (uut.regfile_inst.registers[9]  !== 16'h0003) begin $display("FAIL: $s9  expected 0x0003"); pass = 0; end
        if (uut.regfile_inst.registers[10] !== 16'hFFFF) begin $display("FAIL: $s10 expected 0xFFFF"); pass = 0; end
        if (uut.regfile_inst.registers[11] !== 16'h0000) begin $display("FAIL: $s11 expected 0x0000"); pass = 0; end

        if (pass)
            $display(">>> ALL TESTS PASSED <<<");
        else
            $display(">>> SOME TESTS FAILED <<<");

        $display("");
        $display("Final PC = 0x%04h", uut.pc_inst.PC_out);
        $display("============================================");

        $finish;
    end

    // Optional: dump waveform
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, Processor_tb);
    end

endmodule
