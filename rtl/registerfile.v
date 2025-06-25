`timescale 1ns / 1ps

module registerfile (
    input  wire clk,
    input  wire reset,
    input  wire write_enable,
    input  wire [1:0] write_addr,
    input  wire [7:0] write_data,
    input  wire [1:0] read_addr1,
    input  wire [1:0] read_addr2,
    output reg  [7:0] read_data1,
    output reg  [7:0] read_data2
);

    reg [7:0] registers [0:3];

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 0;
        end else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end

    always @(*) begin
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];
    end

endmodule
