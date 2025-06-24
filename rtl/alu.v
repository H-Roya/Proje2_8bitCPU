`timescale 1ns / 1ps

module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] alu_op,
    output reg  [7:0] result,
    output wire       zero
);

    always @(*) begin
        case (alu_op)
            3'b000: result = a + b;    // ADD
            3'b001: result = a - b;    // SUB
            3'b010: result = a & b;    // AND
            3'b011: result = a | b;    // OR
            3'b100: result = ~a;       // NOT
            3'b101: result = (a < b) ? 8'd1 : 8'd0; // LT
            3'b110: result = a << 1;   // SHL
            3'b111: result = a >> 1;   // SHR
            default: result = 8'd0;
        endcase
    end

    assign zero = (result == 8'd0);

endmodule
