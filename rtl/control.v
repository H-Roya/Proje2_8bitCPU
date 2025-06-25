`timescale 1ns / 1ps

module control (
    input  wire [7:0] instr,
    output reg  reg_write,
    output reg  alu_src,
    output reg  [2:0] alu_op,
    output reg  jump,
    output reg  branch_z,
    output reg branch_n,
    output reg branch_c,
    output reg  halt
);

    wire [3:0] opcode = instr[7:4];

    always @(*) begin
        reg_write = 0;
        alu_src = 0;
        alu_op = 3'b000;
        jump = 0;
        branch_z = 0;
        branch_n = 0;
        branch_c = 0;
        halt = 0;

        case (opcode)
            4'b0001: begin // LDI
                reg_write = 1;
                alu_src = 1;
                alu_op = 3'b000;
            end
            4'b0010: begin // ADD
                reg_write = 1;
                alu_op = 3'b000;
            end
            4'b0011: begin // SUB
                reg_write = 1;
                alu_op = 3'b001;
            end
            4'b0100: jump = 1;         // JMP
            4'b0101: branch_z = 1;     // BRZ
            4'b0110: begin // AND
                reg_write = 1;
                alu_op = 3'b010;
            end
            4'b0111: begin // OR
                reg_write = 1;
                alu_op = 3'b011;
            end
            4'b1000: begin // NOT
                reg_write = 1;
                alu_op = 3'b100;
            end
            4'b1001: begin // LT
                reg_write = 1;
                alu_op = 3'b101;
            end
            4'b1010: begin // SHL
                reg_write = 1;
                alu_op = 3'b110;
            end
            4'b1011: begin // SHR
                reg_write = 1;
                alu_op = 3'b111;
            end
            4'b1100: branch_n = 1;     //BRN
            4'b1101: branch_c = 1;     //BRC
            4'b1111: halt = 1;         // HALT
            default: ;                 // NOP
        endcase
    end

endmodule
