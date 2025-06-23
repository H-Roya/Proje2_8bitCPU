`timescale 1ns / 1ps

module memory (
    input  wire [7:0] addr,
    output reg  [7:0] data_out
);

    reg [7:0] mem [0:255];

    initial begin
        mem[0] = 8'b00010001; // LDI R0, 1
        mem[1] = 8'b00010101; // LDI R1, 5
        mem[2] = 8'b00100001; // ADD R0, R1
        mem[3] = 8'b11110000; // HALT
    end

    always @(*) begin
        data_out = mem[addr];
    end

endmodule
