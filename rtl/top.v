`timescale 1ns / 1ps
module top (
    input  wire clk,
    input  wire reset,
    output wire [3:0] led_out
);
    wire [7:0] pc, instr, result;
    wire reg_write, mem_write, alu_src, mem_to_reg, jump;
    wire [3:0] alu_op;

    datapath dp (
        .clk(clk), .reset(reset),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .jump(jump),
        .alu_op(alu_op),
        .pc_out(pc),
        .instruction_out(instr),
        .result_out(result)
    );

    control ctrl (
        .opcode(instr[7:4]),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg),
        .jump(jump)
    );

    assign led_out = result[3:0];
endmodule
