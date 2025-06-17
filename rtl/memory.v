module memory (
    input  wire clk,
    input  wire write_enable,
    input  wire [7:0] address,
    input  wire [7:0] write_data,
    output reg  [7:0] read_data
);
    reg [7:0] mem [0:255];

    initial begin
        mem[0] = 8'b01100001;  // LI R0, 1
        mem[1] = 8'b01110010;  // LI R1, 2
        mem[2] = 8'b00010001;  // ADD R0, R1
        mem[3] = 8'b11110000;  // HALT
    end

    always @(posedge clk) begin
        if (write_enable)
            mem[address] <= write_data;
        read_data <= mem[address];
    end
endmodule
