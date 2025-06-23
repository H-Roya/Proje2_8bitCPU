module top (
    input  wire clk,
    input  wire reset,
    output wire [3:0] led_out
);

    wire [7:0] instr;
    wire [7:0] result_out;
    wire reg_write, alu_src, jump, branch_z, halt;
    wire [2:0] alu_op;
    wire [7:0] pc_debug;

    datapath u_datapath (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .jump(jump),
        .branch_z(branch_z),
        .halt(halt),
        .instr(instr),
        .result_out(result_out),
        .pc(pc_debug)
    );

    control u_control (
        .instr(instr),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .jump(jump),
        .branch_z(branch_z),
        .halt(halt)
    );

    assign led_out = result_out[3:0];

endmodule
