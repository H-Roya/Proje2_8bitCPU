module datapath (
    input  wire clk,
    input  wire reset,
    input  wire reg_write,
    input  wire mem_write,
    input  wire alu_src,
    input  wire mem_to_reg,
    input  wire jump,
    input  wire [3:0] alu_op,
    output wire [7:0] pc_out,
    output wire [7:0] instruction_out,
    output wire [7:0] result_out
);
    reg [7:0] pc;
    wire [7:0] instruction;
    wire [7:0] reg_data1, reg_data2, alu_b, alu_result, mem_data;
    wire [3:0] opcode = instruction[7:4];
    wire [1:0] reg_dst = instruction[3:2];
    wire [1:0] reg_src = instruction[1:0];
    wire [3:0] imm = instruction[3:0];
    wire [7:0] imm_ext = {4'b0000, imm};

    assign instruction_out = instruction;
    assign pc_out = pc;

    memory instr_mem (.clk(clk), .write_enable(1'b0), .address(pc), .write_data(8'd0), .read_data(instruction));

    register_file regs (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write),
        .write_addr(reg_dst),
        .write_data(mem_to_reg ? mem_data : alu_result),
        .read_addr1(reg_dst),
        .read_addr2(reg_src),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    assign alu_b = (alu_src) ? imm_ext : reg_data2;

    alu alu_unit (
        .a(reg_data1),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero()
    );

    memory data_mem (.clk(clk), .write_enable(mem_write), .address(alu_result), .write_data(reg_data1), .read_data(mem_data));

    assign result_out = alu_result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 8'd0;
        else if (jump)
            pc <= instruction;
        else
            pc <= pc + 1;
    end
endmodule
