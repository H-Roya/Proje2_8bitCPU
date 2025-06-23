`timescale 1ns / 1ps

module memory (
    input  wire [7:0] addr,
    output reg  [7:0] data_out
);

    reg [7:0] mem [0:255];

    /*initial begin
        mem[0] = 8'b00010001; // LDI R0, 1
        mem[1] = 8'b00010101; // LDI R1, 5
        mem[2] = 8'b00100001; // ADD R0, R1
        mem[3] = 8'b11110000; // HALT
    end*/

    initial begin
        mem[0] = 8'b00010010; // LDI R0, 2
        mem[1] = 8'b00010100; // LDI R1, 4
        mem[2] = 8'b00100001; // ADD R0, R1 -> R0 = 6
        mem[3] = 8'b00110001; // SUB R0, R1 -> R0 = 2
        mem[4] = 8'b01000001; // AND R0, R1 -> R0 = 0
        mem[5] = 8'b01010001; // OR R0, R1 -> R0 = 4
        mem[6] = 8'b01010111; // BRZ to 7 (should not branch because R0 ≠ 0)
        mem[7] = 8'b00011011; // LDI R2, 3
        mem[8] = 8'b01000100; // JMP to 4 (loop or test jump)
        mem[9] = 8'b11110000; // HALT (unreachable in this case)
    end

    always @(*) begin
        data_out = mem[addr];
    end

endmodule
