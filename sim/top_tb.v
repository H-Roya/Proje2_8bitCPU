`timescale 1ns / 1ps
module top_tb;
    reg clk = 0;
    reg reset = 1;
    wire [3:0] led_out;

    top uut (.clk(clk), .reset(reset), .led_out(led_out));

    always #10 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);

        #50 reset = 0;
        #1000;
        $finish;
    end
endmodule
