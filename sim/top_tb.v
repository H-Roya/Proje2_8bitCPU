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
        $display("PC=%h | Instr=%b | LEDs=%b | Z=%b N=%b C=%b", uut.u_datapath.pc, uut.u_datapath.instr, led_out, uut.u_datapath.z_flag, uut.u_datapath.n_flag, uut.u_datapath.c_flag);
        if (uut.halt) begin
            $display("HALT detected at PC=%h, stopping simulation.", uut.u_datapath.pc);
            $finish;
        end
    end


endmodule
