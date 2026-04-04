`timescale 1ns / 1ps

// Top-level 16-bit single-cycle processor (structural Verilog)
module Processor(
    input clk,
    input reset,
    input [3:0] debug_reg_sel,
    output [15:0] debug_reg_data
);

    // ============================================================
    // Wire declarations
    // ============================================================

    // Program Counter
    wire [15:0] PC_out, next_PC, PC_plus_2;

    // Instruction fields
    wire [15:0] instruction;
    wire [3:0]  opcode, rt_rd, rs, func_code, imm;
    wire [11:0] jump_addr;

    // Control signals
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg;
    wire Branch, BranchNE, Jump, Addif;
    wire [3:0] ALU_control;

    // Register File
    wire [15:0] read_data1, read_data2;

    // Sign Extension
    wire [15:0] sign_ext_imm;

    // ALU
    wire [15:0] ALU_input_A, ALU_input_B, ALU_result;
    wire Zero;

    // Data Memory
    wire [15:0] mem_read_data;

    // Write-back
    wire [15:0] write_back_data;
    wire actual_reg_write;

    // Branch / Jump
    wire branch_taken;
    wire [15:0] branch_offset, branch_target;
    wire [15:0] jump_addr_ext, jump_offset, jump_target;
    wire [15:0] branch_or_seq;

    // ============================================================
    // Instruction field extraction
    // ============================================================
    assign opcode    = instruction[15:12];
    assign rt_rd     = instruction[11:8];
    assign rs        = instruction[7:4];
    assign func_code = instruction[3:0];
    assign imm       = instruction[3:0];
    assign jump_addr = instruction[11:0];

    // ============================================================
    // PC logic
    // ============================================================
    assign PC_plus_2 = PC_out + 16'd2;

    // Branch: sign_ext(imm) << 1, added to PC+2
    assign branch_offset = sign_ext_imm << 1;
    assign branch_target = PC_plus_2 + branch_offset;

    // Jump: sign_ext_12bit(address) << 1, added to PC+2
    assign jump_addr_ext = {{4{jump_addr[11]}}, jump_addr};
    assign jump_offset   = jump_addr_ext << 1;
    assign jump_target   = PC_plus_2 + jump_offset;

    // Branch taken?
    assign branch_taken = (Branch & Zero) | (BranchNE & ~Zero);

    // Addif: conditional register write (only if R[rs] != 0)
    assign actual_reg_write = RegWrite & (~Addif | (read_data1 != 16'b0));

    // ============================================================
    // Module instantiations (structural)
    // ============================================================

    // --- Program Counter ---
    PC pc_inst(
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC),
        .PC_out(PC_out)
    );

    // --- Instruction Memory ---
    Instruction_Memory imem_inst(
        .Address_In(PC_out),
        .Instruction_Out(instruction)
    );

    // --- Control Unit ---
    Control_Unit ctrl_inst(
        .opcode(opcode),
        .func_code(func_code),
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

    // --- Register File ---
    Register_File regfile_inst(
        .clk(clk),
        .read_reg1(rs),
        .read_reg2(rt_rd),
        .write_reg(rt_rd),
        .write_data(write_back_data),
        .reg_write(actual_reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .debug_sel(debug_reg_sel),
        .debug_data(debug_reg_data)
    );

    // --- Sign Extension (4-bit to 16-bit) ---
    Sign_Extension sign_ext_inst(
        .imm_in(imm),
        .imm_out(sign_ext_imm)
    );

    // --- MUX: ALU input A (normal vs addif) ---
    //   Addif=0 -> read_data1 (R[rs])
    //   Addif=1 -> read_data2 (R[rt/rd])
    Mux2to1 mux_alu_a(
        .in0(read_data1),
        .in1(read_data2),
        .sel(Addif),
        .out(ALU_input_A)
    );

    // --- MUX: ALU input B (register vs immediate) ---
    //   ALUSrc=0 -> read_data2
    //   ALUSrc=1 -> sign_ext_imm
    Mux2to1 mux_alu_b(
        .in0(read_data2),
        .in1(sign_ext_imm),
        .sel(ALUSrc),
        .out(ALU_input_B)
    );

    // --- ALU ---
    ALU alu_inst(
        .A(ALU_input_A),
        .B(ALU_input_B),
        .ALU_control(ALU_control),
        .ALU_result(ALU_result),
        .Zero(Zero)
    );

    // --- Data Memory ---
    Data_Memory dmem_inst(
        .clk(clk),
        .Address(ALU_result),
        .Write_data(read_data2),
        .Mem_write(MemWrite),
        .Mem_read(MemRead),
        .Read_data(mem_read_data)
    );

    // --- MUX: Write-back (ALU result vs memory data) ---
    //   MemToReg=0 -> ALU_result
    //   MemToReg=1 -> mem_read_data
    Mux2to1 mux_wb(
        .in0(ALU_result),
        .in1(mem_read_data),
        .sel(MemToReg),
        .out(write_back_data)
    );

    // --- MUX: Branch or sequential PC ---
    //   branch_taken=0 -> PC_plus_2
    //   branch_taken=1 -> branch_target
    Mux2to1 mux_branch(
        .in0(PC_plus_2),
        .in1(branch_target),
        .sel(branch_taken),
        .out(branch_or_seq)
    );

    // --- MUX: Jump or branch/sequential PC ---
    //   Jump=0 -> branch_or_seq
    //   Jump=1 -> jump_target
    Mux2to1 mux_jump(
        .in0(branch_or_seq),
        .in1(jump_target),
        .sel(Jump),
        .out(next_PC)
    );

endmodule
