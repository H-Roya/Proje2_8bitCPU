`timescale 1ns / 1ps

module control (
    input  wire [7:0] instruction,
    output reg        reg_write,
    output reg        mem_write,
    output reg        alu_src,
    output reg        pc_write,
    output reg [2:0]  alu_op,
    output reg        mem_to_reg,
    output reg        imm_signed     //1 = signed immediate, 0 = unsigned
);

    wire [3:0] opcode = instruction[7:4];
    wire [3:0] operand = instruction[3:0];

    always @(*) begin
        // Default values
        reg_write  = 0;
        mem_write  = 0;
        alu_src    = 0;
        pc_write   = 1;
        alu_op     = 3'b000;
        mem_to_reg = 0;
        imm_signed = 0;  // Default to unsigned immediate

        case (opcode)
            4'b0000: begin // NOP
                pc_write = 1;
            end
            4'b0001: begin // ADD
                reg_write = 1;
                alu_op = 3'b000;
            end
            4'b0010: begin // SUB
                reg_write = 1;
                alu_op = 3'b001;
            end
            4'b0011: begin // AND
                reg_write = 1;
                alu_op = 3'b010;
            end
            4'b0100: begin // OR
                reg_write = 1;
                alu_op = 3'b011;
            end
            4'b0101: begin // LOAD
                reg_write = 1;
                mem_to_reg = 1;
                alu_op = 3'b000;
                imm_signed = 1; // offset might be signed
                alu_src = 1;
            end
            4'b0110: begin // STORE
                mem_write = 1;
                alu_op = 3'b000;
                imm_signed = 1; // offset might be signed
                alu_src = 1;
            end
            4'b0111: begin // LOAD IMMEDIATE
                reg_write = 1;
                alu_src = 1;
                alu_op = 3'b000;
                imm_signed = 0; // Treat immediate as unsigned
            end
            4'b1000: begin // JUMP
                pc_write = 1;
                reg_write = 0;
            end
            4'b1001: begin // LESS THAN
                reg_write = 1;
                alu_op = 3'b101;
            end
            4'b1010: begin // NOT
                reg_write = 1;
                alu_op = 3'b100;
            end
            default: begin
                pc_write = 1;
            end
        endcase
    end

    always @(*) begin
        $display("CTRL: op=%b alu_op=%b reg_write=%b imm_signed=%b", opcode, alu_op, reg_write, imm_signed);
    end

endmodule
