`timescale 1ns / 1ps

module top_tb;

    reg clk = 0;
    reg reset = 1;
    wire [3:0] led_out;

    top uut (
        .clk(clk),
        .reset(reset),
        .led_out(led_out)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, top_tb);

        #100 reset = 0;
        #1000;

        $finish;
    end

    always @(posedge clk) begin
        $display("T=%0t | LEDS=%b", $time, led_out);
    end

endmodule
