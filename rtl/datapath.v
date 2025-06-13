module datapath (
    input  wire clk,
    input  wire reset,
    input  wire reg_write,
    input  wire mem_write,
    input  wire alu_src,
    input  wire pc_write,
    input  wire imm_signed,         //1 = signed immediate, 0 = unsigned
    input  wire [2:0] alu_op,
    input  wire mem_to_reg,
    output wire [7:0] instruction_out,
    output wire [7:0] result_out
);

    wire [7:0] pc;
    wire [7:0] instruction;
    wire [7:0] reg_data1, reg_data2;
    wire [7:0] alu_result, mem_data, write_data;
    wire [7:0] alu_operand_b;

    // Instruction fields
    wire [3:0] opcode   = instruction[7:4];
    wire [1:0] reg_dst  = instruction[3:2];
    wire [1:0] reg_src1 = instruction[3:2];
    wire [1:0] reg_src2 = instruction[1:0];
    wire [3:0] imm4     = instruction[3:0];

    assign instruction_out = instruction;

    // Immediate extensions
    wire [7:0] imm8_unsigned = {4'b0000, imm4};
    wire [7:0] imm8_signed   = {{4{imm4[3]}}, imm4}; // Sign-extend

    // Select operand B for ALU
    assign alu_operand_b = (alu_src) 
                            ? (imm_signed ? imm8_signed : imm8_unsigned) 
                            : reg_data2;

    register_file u_register_file (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write),
        .write_addr(reg_dst),
        .write_data(write_data),
        .read_addr1(reg_src1),
        .read_addr2(reg_src2),
        .read_data1(reg_data1),
        .read_data2(reg_data2),
        .pc_out(pc),
        .pc_write_enable(pc_write)
    );

    // Instruction memory (read-only)
    memory u_instr_mem (
        .clk(clk),
        .write_enable(1'b0),
        .address(pc),
        .write_data(8'b0),
        .read_data(instruction)
    );

    alu u_alu (
        .a(reg_data1),
        .b(alu_operand_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero()
    );

    // Data memory
    memory u_data_mem (
        .clk(clk),
        .write_enable(mem_write),
        .address(alu_result),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    // Writeback data select
    assign write_data = (mem_to_reg) ? mem_data : alu_result;

    assign result_out = alu_result;

endmodule