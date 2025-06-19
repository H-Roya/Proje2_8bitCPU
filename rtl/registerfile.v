`timescale 1ns / 1ps

module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire        write_enable,
    input  wire [1:0]  write_addr,
    input  wire [7:0]  write_data,
    input  wire [1:0]  read_addr1,
    input  wire [1:0]  read_addr2,
    output reg  [7:0]  read_data1,
    output reg  [7:0]  read_data2,
    output reg  [7:0]  pc_out,
    input  wire        pc_write_enable
);

    // 4 general-purpose registers (R0-R3)
    reg [7:0] registers [0:3];

    // Program Counter
    reg [7:0] pc;

    integer i;
    initial begin
        pc = 8'b0;
        for (i = 0; i < 4; i = i + 1)
            registers[i] = 8'b0;
    end

    // Synchronous logic for register write and PC update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 8'b0;
            for (i = 0; i < 4; i = i + 1)
                registers[i] <= 8'b0;
        end else begin
            if (write_enable)
                registers[write_addr] <= write_data;  // Then register writes start
            if (pc_write_enable)
                pc <= pc + 1; //PC increments first
        end
    end

    // Asynchronous reads
    always @(*) begin
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];
        pc_out = pc;
    end

    // Debugging: monitor register writes and PC updates
    always @(posedge clk) begin
        if (write_enable)
            $display("[%t] REG WRITE: R%0d = %h", $time, write_addr, write_data);
        if (pc_write_enable)
            $display("[%t] PC = %h", $time, pc);
    end

endmodule