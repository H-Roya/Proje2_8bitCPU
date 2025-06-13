`timescale 1ns / 1ps

module top_tb;

    // Inputs
    reg clk = 0;
    reg reset = 1;

    // Outputs
    wire [3:0] led_out;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .reset(reset),
        .led_out(led_out)
    );

    // Clock generation: 50 MHz -> 20 ns period
    always #10 clk = ~clk;

    initial begin
        // Initialize waveform dump (for GTKWave or ModelSim VCD viewer)
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, top_tb);

        // Apply reset
        #100;
        reset = 0;

        // Run long enough to execute your program
        #1000; 

        // Optional final check
        if (led_out == 4'b1111)
            $display("✅ TEST PASSED! Final LED output: %b", led_out);
        else
            $display("❌ TEST FAILED! Final LED output: %b", led_out);

        $finish;
    end

    // Monitor key signals
    always @(posedge clk) begin
        if (!reset) begin
            $display("T=%4t | PC=%h | Instr=%h | LEDs=%b", 
                $time, 
                uut.u_datapath.pc, 
                uut.u_datapath.instruction, 
                led_out);
            $display("REGS: R0=%h R1=%h R2=%h R3=%h",
                uut.u_datapath.u_register_file.registers[0],
                uut.u_datapath.u_register_file.registers[1],
                uut.u_datapath.u_register_file.registers[2],
                uut.u_datapath.u_register_file.registers[3]);
        end
    end

endmodule
