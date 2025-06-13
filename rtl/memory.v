module memory (
    input  wire clk,
    input  wire write_enable,
    input  wire [7:0] address,
    input  wire [7:0] write_data,
    output reg  [7:0] read_data
);

    reg [7:0] mem [0:255];

    //Test the hex file
    /*mem[0] = 8'h71; // LI R0, 1
    mem[1] = 8'h75; // LI R1, 5
    mem[2] = 8'h7A; // LI R2, 10
    mem[3] = 8'h1A; // ADD R3, R1, R2
    mem[4] = 8'h53; // LI R1, 0x75
    mem[5] = 8'h6F; // STORE R3 to mem[15]*/

    initial begin
        $readmemh("sim/program.hex", mem);
    end


    always @(posedge clk) begin
        if (write_enable) begin
            mem[address] <= write_data;
        end
        read_data <= mem[address];  // Synchronous read
    end

endmodule
