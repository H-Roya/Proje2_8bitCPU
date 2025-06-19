`timescale 1ns / 1ps

module top_tb;
    reg clk = 0;
    reg reset = 1;

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
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, top_tb);

        // Apply reset
        reset = 1;
        #200;
        reset = 0;
        #1000;

        if (led_out == 4'b1111)
            $display("✅ TEST PASSED! Final LED output: %b", led_out);
        else
            $display("❌ TEST FAILED! Final LED output: %b", led_out);

        $finish;
    end

    always @(posedge clk) begin
        if (uut.u_datapath.pc == 4 && uut.u_datapath.instruction == 8'h1A) begin
            #20; // Wait for result
            if (uut.u_datapath.u_register_file.registers[2] != 8'h06) begin
                $display("ERROR: ADD failed! Expected 6, got %h", 
                    uut.u_datapath.u_register_file.registers[2]);
        end
    end
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