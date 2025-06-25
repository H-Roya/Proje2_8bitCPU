`timescale 1ns / 1ps

module datapath (
    input  wire clk,
    input  wire reset,
    input  wire reg_write,
    input  wire alu_src,
    input  wire [2:0] alu_op,
    input  wire jump,
    input  wire branch_z,
    input wire branch_n,
    input wire branch_c,
    input  wire halt,
    output wire [7:0] instr,
    output wire [7:0] result_out,
    output reg  [7:0] pc,
    output reg        z_flag,
    output reg        n_flag,
    output reg        c_flag
);

    wire [7:0] read1, read2, alu_b, alu_result;
    wire zero_flag, negative_flag, carry_flag;

    memory u_mem (
        .addr(pc),
        .data_out(instr)
    );

    register_file u_reg (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write),
        .write_addr(instr[3:2]),
        .write_data(alu_result),
        .read_addr1(instr[3:2]),
        .read_addr2(instr[1:0]),
        .read_data1(read1),
        .read_data2(read2)
    );

    alu u_alu (
        .a(read1),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero_flag),
        .negative(negative_flag),
        .carry_out(carry_flag)
    );

    assign alu_b = alu_src ? {4'b0000, instr[3:0]} : read2;
    assign result_out = alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            z_flag <= 0;
            n_flag <= 0;
            c_flag <= 0;
        end else begin
            // Update PC
            if (halt)
                pc <= pc; // freeze PC
            else if (jump)
                pc <= {4'b0000, instr[3:0]};
            else if (branch_z && z_flag)
                pc <= {4'b0000, instr[3:0]};
            else if (branch_n && n_flag)
                pc <= {4'b0000, instr[3:0]};
            else if (branch_c && c_flag)
                pc <= {4'b0000, instr[3:0]};
            else
                pc <= pc + 1;

            // Update flags after ALU operation
            z_flag <= zero_flag;
            n_flag <= negative_flag;
            c_flag <= carry_flag;
        end
    end

endmodule

/*`timescale 1ns / 1ps

module datapath (
    input  wire clk,
    input  wire reset,
    input  wire reg_write,
    input  wire alu_src,
    input  wire [2:0] alu_op,
    input  wire jump,
    input  wire branch_z,
    input  wire halt,
    output wire [7:0] instr,
    output wire [7:0] result_out,
    output reg  [7:0] pc
);

    wire [7:0] read1, read2, alu_b, alu_result;
    wire zero_flag;

    memory u_mem (
        .addr(pc),
        .data_out(instr)
    );

    register_file u_reg (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write),
        .write_addr(instr[3:2]),
        .write_data(alu_result),
        .read_addr1(instr[3:2]),
        .read_addr2(instr[1:0]),
        .read_data1(read1),
        .read_data2(read2)
    );

    alu u_alu (
        .a(read1),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero_flag)
    );

    assign alu_b = alu_src ? {4'b0000, instr[3:0]} : read2;
    assign result_out = alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (halt)
            pc <= pc; // freeze PC
        else if (jump)
            pc <= {4'b0000, instr[3:0]};
        else if (branch_z && zero_flag)
            pc <= {4'b0000, instr[3:0]};
        else
            pc <= pc + 1;
    end

endmodule*/
